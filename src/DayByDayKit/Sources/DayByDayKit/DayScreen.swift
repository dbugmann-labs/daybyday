import Foundation

/// The day view a person is looking at, and the record it is read from and kept at. See
/// `openspec/specs/day-screen/spec.md` for the behaviour contract and this change's `design.md`
/// § *The seam* for why the surface is shaped this way.
@MainActor
@Observable
public final class DayScreen {
    /// What a day screen is doing with the record at its place.
    public enum RecordState: Equatable, Sendable {
        /// The record was read, and a tick made on this screen is kept.
        case kept
        /// The record could not be read, for a reason a person cannot act on differently.
        case unreadable
        /// The record was written by a later version of DayByDay. It is whole; the app is what is
        /// behind, and what is at the place must not be replaced.
        case writtenByALaterVersion
    }

    /// What a day screen is doing with the roster at its place.
    public enum RosterState: Equatable, Sendable {
        /// The roster was read, and this screen draws what it keeps.
        case kept
        /// The roster could not be read or could not be written, for a reason a person cannot act
        /// on differently.
        case notKept
        /// The roster was written by a later version of DayByDay. It is whole; the app is what is
        /// behind, and what is at the place must not be replaced.
        case writtenByALaterVersion
    }

    private let commitments: [Commitment]
    private let place: URL
    private let rosterPlace: URL
    private var today: CalendarDate
    private var shownDay: CalendarDate
    private var store: RecordStore?
    private var rosterStore: RosterStore?
    private var roster: Roster

    /// The place a day screen keeps its record when it is not told another: one file, in a
    /// directory of this app's own, under the platform's application-support directory.
    public static var recordPlace: URL {
        let applicationSupport = FileManager.default.urls(
            for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return applicationSupport
            .appendingPathComponent("DayByDay", isDirectory: true)
            .appendingPathComponent("record.json")
    }

    /// The place a day screen keeps its roster when it is not told another: one file, in the same
    /// directory as `recordPlace`, but not the same file.
    public static var rosterPlace: URL {
        let applicationSupport = FileManager.default.urls(
            for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return applicationSupport
            .appendingPathComponent("DayByDay", isDirectory: true)
            .appendingPathComponent("roster.json")
    }

    /// Opens on `today`, reading the record kept at `recordPlace`.
    public init(
        startingFrom dayOne: [Commitment],
        asOf today: CalendarDate,
        keepingRecordAt recordPlace: URL = DayScreen.recordPlace,
        keepingRosterAt rosterPlace: URL = DayScreen.rosterPlace
    ) {
        self.commitments = dayOne
        self.today = today
        self.shownDay = today
        self.place = recordPlace
        self.rosterPlace = rosterPlace

        let opened = Self.open(at: recordPlace)
        self.store = opened.store
        self.recordState = opened.state

        let openedRoster = Self.openRoster(at: rosterPlace, takingOnIfEmpty: dayOne)
        self.rosterStore = openedRoster.store
        self.rosterState = openedRoster.state
        self.roster = openedRoster.roster

        // `today` here is the parameter above, not `self.today`: `self` is not yet fully
        // initialized (`dayView` is being assigned right now), so `self.shownDay` cannot be read
        // back. The parameter holds the same value `shownDay` was just set to, two lines up.
        self.dayView = DayView(
            of: openedRoster.roster.commitments(on: today), on: today,
            in: opened.store?.history ?? History())
    }

    /// Opens the record at `place`, telling apart the one refusal a person can act on
    /// differently: `RecordStoreError.laterForm` says the record was written by a later version
    /// of DayByDay, and every other reason a store can refuse to open — a run of bytes that is
    /// not a record, a tick that could not be formed, or anything Foundation itself throws — is
    /// answered alike, as `.unreadable`.
    private static func open(at place: URL) -> (store: RecordStore?, state: RecordState) {
        do {
            let store = try RecordStore(at: place)
            return (store, .kept)
        } catch RecordStoreError.laterForm {
            return (nil, .writtenByALaterVersion)
        } catch {
            return (nil, .unreadable)
        }
    }

    /// Opens the roster at `place`. A place written by a later version of DayByDay is told apart
    /// as `.writtenByALaterVersion`; every other reason the store can refuse to open is answered
    /// as `.notKept`, exactly as `open(at:)` answers the record's own refusals.
    ///
    /// Day one: when the roster this opens holds nothing at all, `dayOne` is taken on and kept at
    /// `place` before this returns, in the order it was handed. A roster already holding anything
    /// — including one every one of whose commitments has been stopped — is left exactly as it
    /// is. A failure keeping `dayOne` leaves `.notKept` and a roster holding nothing, never a
    /// roster taken on halfway.
    private static func openRoster(
        at place: URL, takingOnIfEmpty dayOne: [Commitment]
    ) -> (store: RosterStore?, state: RosterState, roster: Roster) {
        let store: RosterStore
        do {
            store = try RosterStore(at: place)
        } catch RosterStoreError.laterForm {
            return (nil, .writtenByALaterVersion, Roster())
        } catch {
            return (nil, .notKept, Roster())
        }

        guard store.roster == Roster() else {
            return (store, .kept, store.roster)
        }

        do {
            for commitment in dayOne {
                try store.add(commitment)
            }
        } catch {
            return (store, .notKept, store.roster)
        }

        return (store, .kept, store.roster)
    }

    /// The day view the person is looking at, as the record stood when it was last read.
    public private(set) var dayView: DayView

    /// The day this screen is showing, said in words: its day view's title, asked as of the day
    /// the screen was handed. Reads no clock.
    public var title: String {
        dayView.title(asOf: today)
    }

    /// Anything but `.kept` means the day is drawn from no record at all and no tick is taken.
    public private(set) var recordState: RecordState

    /// Anything but `.kept` means this screen draws no rows and takes nothing on.
    public private(set) var rosterState: RosterState

    /// Makes the tick `row` offers, or takes it back where `row` says its commitment is kept, and
    /// keeps the change before `dayView` says so. Does nothing when `row` is not one this screen's
    /// day view holds, or when this screen is not keeping a record. Throws when the change could
    /// not be kept, leaving `dayView` as it was.
    public func tick(_ row: DayView.Row) throws {
        guard dayView.rows.contains(row) else {
            return
        }
        guard let store else {
            return
        }
        guard let tick = row.tick(asOf: today) else {
            return
        }

        if row.isKept {
            try store.remove(tick)
        } else {
            try store.add(tick)
        }

        dayView = DayView(of: roster.commitments(on: shownDay), on: shownDay, in: store.history)
    }

    /// Shows the calendar day before the one being shown. Leaves the screen exactly as it is when
    /// it is showing 1 January 1583. Does not move the today, and does not read the roster or the
    /// record again — the commitments to hand over cannot be known until the date is, so the date
    /// is stepped first and the roster already held is asked about it.
    public func showPreviousDay() {
        guard let previousDate = shownDay.adding(days: -1) else {
            return
        }
        shownDay = previousDate
        dayView = DayView(
            of: roster.commitments(on: shownDay), on: shownDay, in: store?.history ?? History())
    }

    /// Shows the calendar day after the one being shown. Leaves the screen exactly as it is when
    /// it is showing 31 December 9999. Does not move the today, and does not read the roster or
    /// the record again.
    public func showNextDay() {
        guard let nextDate = shownDay.adding(days: 1) else {
            return
        }
        shownDay = nextDate
        dayView = DayView(
            of: roster.commitments(on: shownDay), on: shownDay, in: store?.history ?? History())
    }

    /// Shows the today this screen was last handed, from whatever day it is showing. Always has
    /// somewhere to go; does not read the roster or the record again.
    public func showToday() {
        shownDay = today
        dayView = DayView(
            of: roster.commitments(on: shownDay), on: shownDay, in: store?.history ?? History())
    }

    /// The app has been shown on `today`: the day view and the record are read again. A screen
    /// showing its today follows onto the new one; a screen showing any other day goes on
    /// showing that day. The comparison is against the today the screen held before this call.
    public func shown(asOf today: CalendarDate) {
        if shownDay == self.today {
            shownDay = today
        }
        self.today = today

        let opened = Self.open(at: place)
        self.store = opened.store
        self.recordState = opened.state

        let openedRoster = Self.openRoster(at: rosterPlace, takingOnIfEmpty: commitments)
        self.rosterStore = openedRoster.store
        self.rosterState = openedRoster.state
        self.roster = openedRoster.roster

        self.dayView = DayView(
            of: openedRoster.roster.commitments(on: shownDay), on: shownDay,
            in: opened.store?.history ?? History())
    }
}
