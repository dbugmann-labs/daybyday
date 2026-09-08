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

    /// The day this screen is showing, said in words: its day view's title, asked as of the day
    /// the screen was handed. Reads no clock.
    public var title: String {
        dayView.title(asOf: today)
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

    /// What `enter(_:on:)` reads a commit as: a number, a take-back, or a value that is not a
    /// number. See `design.md` § *Reading what was committed*.
    private enum CommittedText {
        case number(Decimal)
        case takeBack
        case notANumber
    }

    /// Reads `text` as `enter(_:on:)` does, in this capability's own way and consulting no
    /// locale. `Decimal(string:)` is a *prefix* parser, not a validator — `design.md` § *Context*
    /// measures five ways it silently reads a value nobody typed — so the shape of what was
    /// committed is checked in full before `Decimal(string:)` is ever called, and the parse is
    /// then given a text this reading built and never the text a person typed: the same number
    /// can be spelled in a way `Decimal(string:)` holds and in another it refuses, so the parse
    /// is asked about the one spelling this reading already knows says the value exactly.
    private static func read(_ text: String) -> CommittedText {
        let trimmed = Blank.trimmed(text)
        guard !trimmed.isEmpty else {
            return .takeBack
        }

        var digits = trimmed[...]
        var sign = ""
        if digits.first == "-" {
            sign = "-"
            digits.removeFirst()
        }

        var digitCount = 0
        var separatorCount = 0
        for character in digits {
            if character.isASCII, character.isNumber {
                digitCount += 1
            } else if character == "." || character == "," {
                separatorCount += 1
            } else {
                return .notANumber
            }
        }

        let (written, significantDigits) = Self.writtenOut(digits)
        guard digitCount >= 1, separatorCount <= 1, significantDigits <= 38 else {
            return .notANumber
        }
        guard significantDigits > 0 else {
            return .number(0)
        }

        guard let number = Decimal(string: sign + written) else {
            return .notANumber
        }
        return .number(number)
    }

    /// Writes `digits` out in the one spelling `read(_:)` asks `Decimal(string:)` about — text
    /// already proved to hold nothing but digits and at most one separator, with any leading `-`
    /// already removed — and gives back the count of significant digits that spelling holds: the
    /// whole part with its leading zeros dropped, a full stop where a `.` or `,` was typed, the
    /// fraction with its trailing zeros dropped, and no separator where nothing is left after it.
    /// The count is read off that same stripping, not off `digits` directly, because a leading
    /// zero the whole part loses can still open the fraction (`"0.08"` holds one significant
    /// digit, not two).
    ///
    /// `design.md` § *A number this system cannot keep exactly is not a number here*: a count
    /// above thirty-eight is a value that is not a number, and a count of zero is answered as
    /// `.number(0)` without `read(_:)` ever calling `Decimal(string:)` — a shortcut now rather
    /// than a guard, since every such text is written out as `"0"` here too, and no longer the
    /// only defence against a `nil` that once meant something else: a value at any magnitude can
    /// be refused for how it was spelled rather than for what it is worth, which is why the parse
    /// is never asked about the text as typed.
    private static func writtenOut(_ digits: Substring) -> (text: String, significantDigits: Int) {
        let parts = String(digits).replacingOccurrences(of: ",", with: ".")
            .split(separator: ".", omittingEmptySubsequences: false)
        var whole = parts[0]
        var fraction = parts.count > 1 ? parts[1] : Substring()
        while whole.first == "0" {
            whole.removeFirst()
        }
        while fraction.last == "0" {
            fraction.removeLast()
        }

        var counted = String(whole) + String(fraction)
        while counted.first == "0" {
            counted.removeFirst()
        }
        while counted.last == "0" {
            counted.removeLast()
        }
        guard !counted.isEmpty else {
            return ("0", 0)
        }

        let head = whole.isEmpty ? "0" : String(whole)
        let text = fraction.isEmpty ? head : head + "." + String(fraction)
        return (text, counted.count)
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
            switch Self.read(text) {
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

            switch Self.read(text) {
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

    /// The day view of `shownDay`, drawn from `roster` and `recordStore`'s history exactly as
    /// they stand now — asks neither again. Shared by every caller that re-forms `dayView` after
    /// changing what it is drawn from or which day it is drawn for: the writes `tick` and
    /// `enter(_:on:)` keep before re-forming it, and the moves `showPreviousDay`, `showNextDay`
    /// and `showToday` that only step the day already held.
    private func dayViewOfShownDay() -> DayView {
        DayView(
            of: roster.commitments(on: shownDay), on: shownDay,
            in: recordStore?.history ?? History())
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
            of: openedRoster.roster.commitments(on: shownDay), on: shownDay,
            in: opened.store?.history ?? History())
    }

    /// The person has come back to this screen from somewhere else in the app: the roster is read
    /// again and the day view is formed again for the day being shown. Takes no today, moves no
    /// day, and does not read the record.
    public func returnedTo() {
        let openedRoster = Self.openRoster(at: rosterPlace, takingOnIfEmpty: commitments)
        self.rosterState = openedRoster.state
        self.roster = openedRoster.roster

        self.dayView = DayView(
            of: openedRoster.roster.commitments(on: shownDay), on: shownDay,
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
