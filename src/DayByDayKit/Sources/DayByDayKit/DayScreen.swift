import Foundation
import os

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

    private let commitments: [Commitment]
    private let recordPlace: URL
    private let rosterPlace: URL
    private var today: CalendarDate
    private var shownDay: CalendarDate
    private var recordStore: RecordStore?
    private var roster: Roster

    /// The place a day screen keeps its record when it is not told another: one file, in a
    /// directory of this app's own, under the platform's application-support directory.
    public static var recordPlace: URL {
        applicationSupportPlace(fileName: "record.json")
    }

    /// The place a day screen keeps its roster when it is not told another: one file, in the same
    /// directory as `recordPlace`, but not the same file.
    public static var rosterPlace: URL {
        applicationSupportPlace(fileName: "roster.json")
    }

    /// The place named `fileName`, inside a directory of this app's own under the platform's
    /// application-support directory. `recordPlace` and `rosterPlace` differ only in `fileName`.
    private static func applicationSupportPlace(fileName: String) -> URL {
        let applicationSupport = FileManager.default.urls(
            for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return applicationSupport
            .appendingPathComponent("DayByDay", isDirectory: true)
            .appendingPathComponent(fileName)
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
        self.recordPlace = recordPlace
        self.rosterPlace = rosterPlace

        let opened = Self.open(at: recordPlace)
        self.recordStore = opened.store
        self.recordState = opened.state

        let openedRoster = Self.openRoster(at: rosterPlace, takingOnIfEmpty: dayOne)
        self.rosterState = openedRoster.state
        self.roster = openedRoster.roster

        // `today` here is the parameter above, not `self.today`: `self` is not yet fully
        // initialized (`dayView` is being assigned right now), so `self.shownDay` cannot be read
        // back. The parameter holds the same value `shownDay` was just set to, two lines up.
        self.dayView = DayView(
            of: openedRoster.roster.groups(on: today), on: today,
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
    /// is. A failure keeping `dayOne` leaves `.notKept` and, ordinarily, a roster holding nothing:
    /// whatever of `dayOne` had already been kept at `place` before the failure is removed again
    /// on a best-effort basis, so nothing it takes on survives and a later `shown(asOf:)` finds
    /// `place` holding nothing and retries day one, exactly as it would have found it after a
    /// failure on the very first commitment. That removal can itself fail; when it does, `place`
    /// is left holding a partial day one instead, which reads back as a legitimate non-empty
    /// roster, and day one is not retried.
    private static func openRoster(
        at place: URL, takingOnIfEmpty dayOne: [Commitment]
    ) -> (state: RosterState, roster: Roster) {
        let store: RosterStore
        do {
            store = try RosterStore(at: place)
        } catch RosterStoreError.laterForm {
            return (.writtenByALaterVersion, Roster())
        } catch {
            return (.notKept, Roster())
        }

        guard store.roster == Roster() else {
            return (.kept, store.roster)
        }

        do {
            for commitment in dayOne {
                try store.add(commitment)
            }
        } catch {
            // The write that just failed may have left day one partly kept at `place` — but it
            // may equally have failed before any byte reached `place` at all (the spec'd case is
            // a path beneath an existing ordinary file, where `createDirectory` throws first).
            // Only attempt removal, and only log, when something is actually there to remove;
            // otherwise this is an ordinary refusal to write, not a partial roster left behind.
            if FileManager.default.fileExists(atPath: place.path) {
                do {
                    try FileManager.default.removeItem(at: place)
                } catch let removalError {
                    // This removal is what stops a later open from reading that partial write
                    // back as a legitimate roster. A failure here — a sticky bit this process may
                    // write but not unlink in, a `uchg` flag on the file — must not be swallowed
                    // the way `try?` swallows it: logged rather than thrown, because the screen's
                    // answer is `.notKept` either way — design.md's own reading of `RosterState`
                    // — and rule 5 forbids inventing a state the delta does not carry to say more
                    // than that.
                    let message =
                        "could not remove the partial roster left at \(place.path) after day one "
                        + "failed to write: \(String(describing: removalError))"
                    Logger(subsystem: "DayByDayKit", category: "RosterStore")
                        .error("\(message, privacy: .public)")
                }
            }
            return (.notKept, Roster())
        }

        return (.kept, store.roster)
    }

    /// The day view the person is looking at, as the record stood when it was last read.
    public private(set) var dayView: DayView

    /// The day this screen is showing, said in words: its day view's title. Reads no clock.
    public var title: String {
        dayView.title
    }

    /// Whether this screen offers the way back to the today it was handed: `true` exactly where
    /// the day being shown is not that today. Reads no clock; the today is the one this screen
    /// was last handed, at `init` or at `shown(asOf:)`.
    public var offersGoingBackToToday: Bool {
        shownDay != today
    }

    /// What a day screen says about the reach of its day picker: the day the picker opens on,
    /// and the earliest day it reaches. `openspec/changes/add-day-picker/design.md` § *The seam*.
    public struct Reach: Hashable, Sendable {
        public let opensOn: CalendarDate
        public let earliest: CalendarDate
    }

    /// The reach of this screen's day picker: the day it opens on is the day being shown, and
    /// the earliest day it reaches is the earlier of the earliest day anything on this screen's
    /// roster is kept from — or, where the roster answers none, the today this screen was last
    /// handed — and the day being shown.
    public var dayPickerReach: Reach {
        let floor = roster.earliestKeptFrom ?? today
        let earliest = shownDay.days(until: floor) < 0 ? floor : shownDay
        return Reach(opensOn: shownDay, earliest: earliest)
    }

    /// Anything but `.kept` means the day is drawn from no record at all and no tick is taken.
    public private(set) var recordState: RecordState

    /// Anything but `.kept` means this screen draws no rows and takes nothing on.
    public private(set) var rosterState: RosterState

    /// What a person is told on a row, and nothing else: which row, and the cause where there is
    /// one a person can act on. `cause` is `nil` for a refusal by the place, which names nothing,
    /// and for a refused tick, which carries no cause at all.
    public struct Notice: Hashable, Sendable {
        public let row: DayView.Row
        public let cause: String?

        init(row: DayView.Row, cause: String? = nil) {
            self.row = row
            self.cause = cause
        }
    }

    /// The notice a person is owed, or `nil` when there is nothing to tell. Set when a change is
    /// refused, whether by the place, which throws, or by the value — a number outside its
    /// commitment's range, or text that is not a number — which does not; cleared by
    /// `shown(asOf:)`, by a change that reaches the record's place, and by the day being shown
    /// changing.
    public private(set) var notice: Notice?

    /// Makes the tick `row` offers, or takes it back where `row` says its commitment is kept, and
    /// keeps the change before `dayView` says so. Does nothing when `row` is not one this screen's
    /// day view holds, or when this screen is not keeping a record. Throws when the change could
    /// not be kept, leaving `dayView` as it was.
    public func tick(_ row: DayView.Row) throws {
        guard dayView.rows.contains(row) else {
            return
        }
        guard let recordStore else {
            return
        }
        guard let tick = row.tick(asOf: today) else {
            return
        }

        do {
            if row.isKept {
                try recordStore.remove(tick)
            } else {
                try recordStore.add(tick)
            }
        } catch {
            notice = Notice(row: row)
            throw error
        }
        notice = nil

        dayView = dayViewOfShownDay()
    }

    /// Enters what `text` holds on `row`, or takes that day's number back where it holds
    /// nothing, and keeps the change before `dayView` says so. Does nothing when `row` is not one
    /// this screen's day view holds, when this screen is not keeping a record, or when `row`
    /// offers no number entry as of `today`. Throws when the change could not be kept at the
    /// record's place, leaving `dayView` as it was; a value the commitment refuses or a value
    /// that is not a number keeps nothing and does not throw.
    public func enter(_ text: String, on row: DayView.Row) throws {
        guard dayView.rows.contains(row) else {
            return
        }
        guard let recordStore else {
            return
        }

        if let entry = row.numberEntry(asOf: today) {
            switch TypedNumber.read(text) {
            case .takeBack:
                do {
                    try recordStore.removeNumber(on: row.recordedDay)
                } catch {
                    notice = Notice(row: row)
                    throw error
                }
            case .number(let decimal):
                guard let number = row.numberRecord(decimal, asOf: today) else {
                    notice = Notice(row: row, cause: entry.refusalCause)
                    return
                }

                do {
                    try recordStore.add(number)
                } catch {
                    notice = Notice(row: row)
                    throw error
                }
            case .notANumber:
                notice = Notice(row: row, cause: "Not a number")
                return
            }
        } else if row.noteEntry(asOf: today) != nil {
            if Blank.saysNothing(text) {
                do {
                    try recordStore.removeNote(on: row.recordedDay)
                } catch {
                    notice = Notice(row: row)
                    throw error
                }
            } else {
                guard let note = row.noteRecord(Blank.trimmed(text), asOf: today) else {
                    return
                }

                do {
                    try recordStore.add(note)
                } catch {
                    notice = Notice(row: row)
                    throw error
                }
            }
        } else if row.totalEntry(asOf: today) != nil {
            guard !Blank.saysNothing(text) else {
                return
            }

            switch TypedNumber.read(text) {
            case .takeBack:
                return
            case .notANumber:
                notice = Notice(row: row, cause: "Not a number")
                return
            case .number(let decimal):
                guard let record = row.totalRecord(decimal, asOf: today) else {
                    return
                }

                switch record {
                case .addition(let addition):
                    do {
                        try recordStore.add(addition)
                    } catch {
                        notice = Notice(row: row)
                        throw error
                    }
                case .notAboveZero:
                    notice = Notice(row: row, cause: "Must be more than 0")
                    return
                case .tooLargeToAdd:
                    notice = Notice(row: row, cause: "Too large to add")
                    return
                }
            }
        } else {
            return
        }
        notice = nil

        dayView = dayViewOfShownDay()
    }

    /// Takes back the last addition `row`'s day holds, and keeps the change before `dayView`
    /// says so. Does nothing when `row` is not one this screen's day view holds, when this screen
    /// is not keeping a record, or when `row` offers no take-back as of `today`. Throws when the
    /// change could not be kept at the record's place, leaving `dayView` as it was.
    public func takeBackLast(on row: DayView.Row) throws {
        guard dayView.rows.contains(row) else {
            return
        }
        guard let recordStore else {
            return
        }
        guard row.offersTakeBackLast(asOf: today) else {
            return
        }

        do {
            try recordStore.removeLastAddition(on: row.recordedDay)
        } catch {
            notice = Notice(row: row)
            throw error
        }
        notice = nil

        dayView = dayViewOfShownDay()
    }

    /// The day view of `day`, drawn from `roster` and `recordStore`'s history exactly as they
    /// stand now — asks neither again.
    private func dayView(on day: CalendarDate) -> DayView {
        DayView(of: roster.groups(on: day), on: day, in: recordStore?.history ?? History())
    }

    /// The day view of `shownDay`, drawn from `roster` and `recordStore`'s history exactly as
    /// they stand now — asks neither again. Shared by every caller that re-forms `dayView` after
    /// changing what it is drawn from or which day it is drawn for: the writes `tick` and
    /// `enter(_:on:)` keep before re-forming it, and the moves `showPreviousDay`, `showNextDay`
    /// and `showToday` that only step the day already held.
    private func dayViewOfShownDay() -> DayView {
        dayView(on: shownDay)
    }

    /// The day view of the calendar date one day before `shownDay`, or `nil` where `shownDay` is
    /// 1 January 1583. Formed for that day's own roster answer, never from `dayView`'s groups or
    /// from `roster.groups(on: shownDay)` — `design.md` § *The neighbour is formed for its own
    /// day*. Reads neither the roster nor the record again, and changes nothing about the screen.
    public var previousDayView: DayView? {
        guard let previousDate = shownDay.adding(days: -1) else {
            return nil
        }
        return dayView(on: previousDate)
    }

    /// The day view of the calendar date one day after `shownDay`, or `nil` where `shownDay` is
    /// 31 December 9999. The same as `previousDayView`, one day the other way.
    public var nextDayView: DayView? {
        guard let nextDate = shownDay.adding(days: 1) else {
            return nil
        }
        return dayView(on: nextDate)
    }

    /// Shows the calendar day before the one being shown. Leaves the screen exactly as it is when
    /// it is showing 1 January 1583. Does not move the today, and does not read the roster or the
    /// record again — the commitments to hand over cannot be known until the date is, so the date
    /// is stepped first and the roster already held is asked about it.
    public func showPreviousDay() {
        guard let previousDate = shownDay.adding(days: -1) else {
            return
        }
        notice = nil
        shownDay = previousDate
        dayView = dayViewOfShownDay()
    }

    /// Shows the calendar day after the one being shown. Leaves the screen exactly as it is when
    /// it is showing 31 December 9999. Does not move the today, and does not read the roster or
    /// the record again.
    public func showNextDay() {
        guard let nextDate = shownDay.adding(days: 1) else {
            return
        }
        notice = nil
        shownDay = nextDate
        dayView = dayViewOfShownDay()
    }

    /// Shows the today this screen was last handed, from whatever day it is showing. Always has
    /// somewhere to go; does not read the roster or the record again.
    public func showToday() {
        if shownDay != today {
            notice = nil
        }
        shownDay = today
        dayView = dayViewOfShownDay()
    }

    /// Shows `day`, the day picked on this screen's day picker, where it is not earlier than
    /// `dayPickerReach.earliest`; leaves the screen exactly as it was, with nothing formed again
    /// and nothing said about it, where it is earlier. Does not move the today, and does not read
    /// the roster or the record again.
    public func showDay(_ day: CalendarDate) {
        guard day.days(until: dayPickerReach.earliest) <= 0 else {
            return
        }
        if shownDay != day {
            notice = nil
        }
        shownDay = day
        dayView = dayViewOfShownDay()
    }

    /// The app has been shown on `today`: the day view and the record are read again. A screen
    /// showing its today follows onto the new one; a screen showing any other day goes on
    /// showing that day. The comparison is against the today the screen held before this call.
    public func shown(asOf today: CalendarDate) {
        notice = nil

        if shownDay == self.today {
            shownDay = today
        }
        self.today = today

        let opened = Self.open(at: recordPlace)
        self.recordStore = opened.store
        self.recordState = opened.state

        let openedRoster = Self.openRoster(at: rosterPlace, takingOnIfEmpty: commitments)
        self.rosterState = openedRoster.state
        self.roster = openedRoster.roster

        self.dayView = DayView(
            of: openedRoster.roster.groups(on: shownDay), on: shownDay,
            in: opened.store?.history ?? History())
    }

    /// The person has come back to this screen from somewhere else in the app: the roster is read
    /// again and the day view is formed again for the day being shown. Takes no today, moves no
    /// day. Where this screen is keeping a record, that is read again too — a rename or a
    /// rhythm change made elsewhere reaches every row this screen draws. A screen not keeping a
    /// record does not start keeping one by being returned to: `design.md` § *A day screen
    /// returned to now reads its record place again where it is keeping one*.
    public func returnedTo() {
        let openedRoster = Self.openRoster(at: rosterPlace, takingOnIfEmpty: commitments)
        self.rosterState = openedRoster.state
        self.roster = openedRoster.roster

        if recordState == .kept {
            let opened = Self.open(at: recordPlace)
            self.recordStore = opened.store
            self.recordState = opened.state
        }

        self.dayView = DayView(
            of: openedRoster.roster.groups(on: shownDay), on: shownDay,
            in: recordStore?.history ?? History())
    }
}

// `record` spells a take-back with a commitment and a date, and a day screen holds neither —
// only the `RecordedDay` its row already is. Private to this capability's own file, per
// `design.md` § *The seam*.
private extension RecordStore {
    func removeNumber(on day: RecordedDay) throws {
        try removeNumber(for: day.commitment, on: day.date)
    }

    func removeNote(on day: RecordedDay) throws {
        try removeNote(for: day.commitment, on: day.date)
    }

    func removeLastAddition(on day: RecordedDay) throws {
        try removeLastAddition(for: day.commitment, on: day.date)
    }
}
