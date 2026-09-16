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

    /// What a day screen is doing with the one-offs at its place. `design.md` § *The seam*.
    public enum OneOffState: Equatable, Sendable {
        /// The one-offs were read, and a change made on this screen is kept.
        case kept
        /// The one-offs could not be read, for a reason a person cannot act on differently.
        case unreadable
        /// The one-offs were written by a later version of DayByDay. They are whole; the app is
        /// what is behind, and what is at the place must not be replaced.
        case writtenByALaterVersion
    }

    private let commitments: [Commitment]
    private let recordPlace: URL
    private let rosterPlace: URL
    private let oneOffPlace: URL
    private var today: CalendarDate
    private var shownDay: CalendarDate
    private var recordStore: RecordStore?
    private var roster: Roster
    private var oneOffStore: OneOffStore?

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

    /// The place a day screen keeps its one-offs when it is not told another: one file, in the
    /// same directory as `recordPlace` and `rosterPlace`, but not either of those files.
    public static var oneOffPlace: URL {
        applicationSupportPlace(fileName: "one-offs.json")
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
        keepingRosterAt rosterPlace: URL = DayScreen.rosterPlace,
        keepingOneOffsAt oneOffPlace: URL = DayScreen.oneOffPlace
    ) {
        self.commitments = dayOne
        self.today = today
        self.shownDay = today
        self.recordPlace = recordPlace
        self.rosterPlace = rosterPlace
        self.oneOffPlace = oneOffPlace

        let read = Self.readRecordAndRoster(
            recordAt: recordPlace, rosterAt: rosterPlace, oneOffAt: oneOffPlace,
            takingOnIfEmpty: dayOne)
        self.recordStore = read.recordStore
        self.recordState = read.recordState
        self.rosterState = read.rosterState
        self.roster = read.roster
        self.oneOffStore = read.oneOffStore
        self.oneOffState = read.oneOffState

        // `today` here is the parameter above, not `self.today`: `self` is not yet fully
        // initialized (`dayView` is being assigned right now), so `self.shownDay` cannot be read
        // back. The parameter holds the same value `shownDay` was just set to, two lines up.
        self.dayView = Self.formDayView(
            of: read.roster.groups(on: today), oneOffs: read.oneOffStore, asOf: today,
            on: today, in: read.recordStore?.history ?? History())
    }

    /// What reading the record, the roster and the one-off places produces: a restore in
    /// progress undone first, then a save in progress — `openspec/changes/restore-from-a-copy
    /// /design.md` § *Whole or nothing, across a stop* (ADR-1056) and `openspec/specs/commitment
    /// /spec.md` § *Reading the places undoes a torn save as it was* — then the roster opened,
    /// taking on `dayOne` where it holds nothing, the record opened, any orphaned record carried
    /// back to its one possible source, and the one-offs opened. Shared by `init` and
    /// `shown(asOf:)`, which always read all three; `returnedTo()` reads its record place only
    /// where it is already keeping one, so it calls `RestoreInProgress` and `SaveInProgress`
    /// directly rather than through this. Where the restore in progress cannot be undone, nothing
    /// is read at all, from any of the three — `design.md` § *Whole or nothing, across a stop*:
    /// "nothing SHALL be read from those places nor written over them." Where only the save in
    /// progress cannot be undone, the record answers as one that could not be read without
    /// opening it for real — `design.md` § *A torn save that cannot be undone reuses two existing
    /// states* — and the roster is opened read-only: taking `dayOne` on writes the roster place,
    /// which the same requirement's "write nothing at either place" forbids while a torn save
    /// stands unresolved, so the check runs first and day one is offered only once it has
    /// cleared. `openspec/specs/commitment/spec.md` § *A torn save that cannot be undone keeps
    /// nothing from the record place*. The one-offs, unlike the record, are unaffected by a torn
    /// save — that condition is specific to the record and the roster — so they are still opened
    /// in that branch.
    private static func readRecordAndRoster(
        recordAt recordPlace: URL, rosterAt rosterPlace: URL, oneOffAt oneOffPlace: URL,
        takingOnIfEmpty dayOne: [Commitment]
    ) -> (
        recordStore: RecordStore?, recordState: RecordState, roster: Roster, rosterState: RosterState,
        oneOffStore: OneOffStore?, oneOffState: OneOffState
    ) {
        // A restore in progress that cannot be undone: nothing is read from the three places nor
        // written over them — `openspec/changes/restore-from-a-copy/design.md` § *Whole or
        // nothing, across a stop* (ADR-1056), a stricter rule than a torn save's own read-only
        // fallback just below, which still reads a roster this condition never reaches for.
        guard
            RestoreInProgress.undoTornRestore(
                recordAt: recordPlace, rosterAt: rosterPlace, oneOffsAt: oneOffPlace)
        else {
            return (nil, .unreadable, Roster(), .notKept, nil, .unreadable)
        }
        guard SaveInProgress.undoTornSave(recordAt: recordPlace, rosterAt: rosterPlace) else {
            let readOnly = Self.openRoster(at: rosterPlace, takingOnIfEmpty: [])
            let openedOneOffs = Self.openOneOffs(at: oneOffPlace)
            return (
                nil, .unreadable, readOnly.roster, readOnly.state, openedOneOffs.store,
                openedOneOffs.state
            )
        }

        let openedRoster = Self.openRoster(at: rosterPlace, takingOnIfEmpty: dayOne)

        let opened = Self.open(at: recordPlace)
        if let recordStore = opened.store, openedRoster.state == .kept {
            SaveInProgress.carryBackOrphanedRecords(in: recordStore, against: openedRoster.roster)
        }

        let openedOneOffs = Self.openOneOffs(at: oneOffPlace)

        return (
            opened.store, opened.state, openedRoster.roster, openedRoster.state,
            openedOneOffs.store, openedOneOffs.state
        )
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

    /// Opens the one-offs at `place`, telling apart the one refusal a person can act on
    /// differently — `OneOffStoreError.laterForm` says the one-offs were written by a later
    /// version of DayByDay — exactly as `open(at:)` answers the record's own refusals.
    private static func openOneOffs(at place: URL) -> (store: OneOffStore?, state: OneOffState) {
        do {
            let store = try OneOffStore(at: place)
            return (store, .kept)
        } catch OneOffStoreError.laterForm {
            return (nil, .writtenByALaterVersion)
        } catch {
            return (nil, .unreadable)
        }
    }

    /// Forms a day view of `groups` on `date`, from `history`, and of the one-offs `oneOffStore`
    /// holds as of `today` — or of no one-offs at all where `oneOffStore` is `nil`, so a screen
    /// not keeping one-offs draws no One-offs group rather than an empty one. `design.md` § *The
    /// empty group is the offer*.
    private static func formDayView(
        of groups: [Roster.Group], oneOffs oneOffStore: OneOffStore?, asOf today: CalendarDate,
        on date: CalendarDate, in history: History
    ) -> DayView {
        guard let oneOffStore else {
            return DayView(of: groups, on: date, in: history)
        }
        return DayView(
            of: groups, oneOffs: oneOffStore.oneOffs, asOf: today, on: date, in: history)
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

    /// Anything but `.kept` means this screen holds no One-offs group on any day.
    public private(set) var oneOffState: OneOffState

    /// What a person is told on a row, and nothing else: which row, and the cause where there is
    /// one a person can act on. `cause` is `nil` for a refusal by the place, which names nothing,
    /// and for a refused tick, which carries no cause at all. Exactly one of `row` and
    /// `oneOffRow` is set. `design.md` § *One notice carrying a row of either kind*.
    public struct Notice: Hashable, Sendable {
        public let row: DayView.Row?
        public let oneOffRow: DayView.OneOffRow?
        public let cause: String?

        init(row: DayView.Row, cause: String? = nil) {
            self.row = row
            self.oneOffRow = nil
            self.cause = cause
        }

        init(oneOffRow: DayView.OneOffRow) {
            self.row = nil
            self.oneOffRow = oneOffRow
            self.cause = nil
        }
    }

    /// The notice a person is owed, or `nil` when there is nothing to tell. Set when a change is
    /// refused, whether by the place, which throws, or by the value — a number outside its
    /// commitment's range, or text that is not a number — which does not; cleared by
    /// `shown(asOf:)`, by a change that reaches the record's place, and by the day being shown
    /// changing.
    public private(set) var notice: Notice?

    /// What is told under the one-off entry, or under a one-off row's name field — never the
    /// screen's one `notice`, which a one-off add or rename never sets. `design.md` § *A refusal
    /// under a name field is its own value, and there is one at a time*.
    public struct NameRefusal: Hashable, Sendable {
        public let row: DayView.OneOffRow?
        public let text: String
        public let cause: String?
    }

    /// The refusal told under the one-off entry (`row == nil`) or under a row's name field, or
    /// `nil` when there is nothing to tell. `design.md` § *The seam*.
    public private(set) var nameRefusal: NameRefusal?

    /// Adds a one-off named `text`, blank space at both ends disregarded, dated the day this
    /// screen is showing — already done on that day where it is earlier than the today this
    /// screen was last handed, not done on that today or a later day. Does nothing when this
    /// screen is not keeping one-offs, or when `text` says nothing. Refused without an error,
    /// telling "Already on this day" under the one-off entry and keeping nothing, where a one-off
    /// with that name is already held on the day being shown. Throws when the add could not be
    /// kept at the one-off place, telling the failure under the one-off entry naming no cause.
    /// `design.md` § *A refusal under a name field is its own value, and there is one at a time*.
    public func addOneOff(named text: String) throws {
        guard let oneOffStore else {
            return
        }
        guard !Blank.saysNothing(text) else {
            return
        }
        guard let oneOff = OneOff(name: Blank.trimmed(text), date: shownDay) else {
            return
        }

        do {
            let kept: Bool
            if shownDay.days(until: today) > 0 {
                kept = try oneOffStore.add(oneOff, doneOn: shownDay)
            } else {
                kept = try oneOffStore.add(oneOff)
            }
            guard kept else {
                nameRefusal = NameRefusal(row: nil, text: text, cause: "Already on this day")
                return
            }
        } catch {
            nameRefusal = NameRefusal(row: nil, text: text, cause: nil)
            throw error
        }

        oneOffChangeKept(endingRefusalFor: nil)
    }

    /// Renames the one-off `row` holds to `text`, blank space at both ends disregarded, keeping
    /// its date, whether it is done and the day it was done. Does nothing when `row` is not one
    /// this screen's day view holds, or when this screen is not keeping one-offs. A rename
    /// committed saying nothing removes the one-off outright; one whose text, so disregarded, is
    /// `row`'s own name changes nothing and writes nothing. Refused without an error, telling
    /// "Already on this day" under `row`'s name field and keeping nothing, where a one-off with
    /// that name is already held on `row`'s date. Throws when the change could not be kept at the
    /// one-off place, telling the failure under `row`'s name field naming no cause. `design.md`
    /// § *A rename is one act in `one-off`, and keeps the one-off's place*.
    public func rename(_ row: DayView.OneOffRow, to text: String) throws {
        guard dayView.oneOffGroup?.rows.contains(row) ?? false else {
            return
        }
        guard let oneOffStore else {
            return
        }

        if Blank.saysNothing(text) {
            do {
                guard try oneOffStore.remove(row.oneOff) else {
                    return
                }
            } catch {
                nameRefusal = NameRefusal(row: row, text: text, cause: nil)
                throw error
            }

            oneOffChangeKept(endingRefusalFor: row)
            return
        }

        let trimmed = Blank.trimmed(text)
        guard trimmed != row.name else {
            // Changes, writes and tells nothing (shipped requirement): nothing reaches the
            // one-off place, so neither `notice` nor `nameRefusal` ends here — only a change
            // that is actually kept, or refused, ends what a name field is telling.
            return
        }

        do {
            guard try oneOffStore.rename(row.oneOff, to: trimmed) else {
                nameRefusal = NameRefusal(row: row, text: text, cause: "Already on this day")
                return
            }
        } catch {
            nameRefusal = NameRefusal(row: row, text: text, cause: nil)
            throw error
        }

        oneOffChangeKept(endingRefusalFor: row)
    }

    /// Removes the one-off `row` holds outright. Does nothing when `row` is not one this screen's
    /// day view holds, or when this screen is not keeping one-offs. Throws when the removal could
    /// not be kept at the one-off place, telling the failure on `row` — the same rule a refused
    /// tick tells by. `design.md` § *The words, and where a removal is told*.
    public func remove(_ row: DayView.OneOffRow) throws {
        guard dayView.oneOffGroup?.rows.contains(row) ?? false else {
            return
        }
        guard let oneOffStore else {
            return
        }

        do {
            guard try oneOffStore.remove(row.oneOff) else {
                return
            }
        } catch {
            notice = Notice(oneOffRow: row)
            throw error
        }
        notice = nil

        dayView = dayViewOfShownDay()
        endNameRefusalIfItsRowIsGone()
    }

    /// The person has started editing a one-off name field — the entry or a row's. Ends whatever
    /// `nameRefusal` was telling — `openspec/specs/day-screen/spec.md` requirement *What a day
    /// screen tells under a one-off name field lasts until its text is edited, the day it is
    /// showing changes, or the app is shown again*.
    public func oneOffNameEdited() {
        nameRefusal = nil
    }

    /// Clears `nameRefusal` when it currently stands under `row`'s own field — the entry when
    /// `row` is `nil` — and leaves it as it is otherwise, since a change kept on a row or from
    /// another field must not end what a different field is telling. `design.md` § *A refusal
    /// under a name field is its own value, and there is one at a time*.
    private func endNameRefusal(forRow row: DayView.OneOffRow?) {
        if nameRefusal?.row == row {
            nameRefusal = nil
        }
    }

    /// Clears `nameRefusal` when the row it names is no longer one `dayView`'s One-offs group
    /// holds — a tick re-keys a row by value, so a refusal told under a row that was just ticked
    /// must end with it. Does nothing when `nameRefusal` is telling under the one-off entry, which
    /// names no row.
    private func endNameRefusalIfItsRowIsGone() {
        guard let row = nameRefusal?.row else {
            return
        }
        if dayView.oneOffGroup?.rows.contains(row) != true {
            nameRefusal = nil
        }
    }

    /// The four steps a kept one-off add, remove-by-blank-rename or rename all end with alike:
    /// nothing is owed any more, whatever `row`'s own field was telling (the entry when `nil`) is
    /// over, `dayView` reads the place fresh, and a refusal left standing under a row the change
    /// just removed does not outlive it.
    private func oneOffChangeKept(endingRefusalFor row: DayView.OneOffRow?) {
        notice = nil
        endNameRefusal(forRow: row)
        dayView = dayViewOfShownDay()
        endNameRefusalIfItsRowIsGone()
    }

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

    /// Makes the tick `row` offers, or takes it back where `row` says its one-off is done, and
    /// keeps the change at the one-off place before `dayView` says so. Does nothing when `row` is
    /// not one this screen's day view holds, or when `row` offers no tick as of today. Throws
    /// when the change could not be kept, leaving `dayView` as it was. `design.md` § *The seam*.
    public func tick(_ row: DayView.OneOffRow) throws {
        guard dayView.oneOffGroup?.rows.contains(row) ?? false else {
            return
        }
        guard let oneOffStore else {
            return
        }
        guard row.offersTick(asOf: today) else {
            return
        }

        do {
            if row.isDone {
                try oneOffStore.takeBack(row.oneOff)
            } else {
                try oneOffStore.tick(row.oneOff, on: today)
            }
        } catch {
            notice = Notice(oneOffRow: row)
            throw error
        }
        notice = nil

        dayView = dayViewOfShownDay()
        endNameRefusalIfItsRowIsGone()
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

    /// The day view of `day`, drawn from `roster`, `recordStore`'s history and `oneOffStore`'s
    /// one-offs exactly as they stand now — asks none of the three again, and asks the one-offs
    /// which stand as of `today`, never as of `day`.
    private func dayView(on day: CalendarDate) -> DayView {
        Self.formDayView(
            of: roster.groups(on: day), oneOffs: oneOffStore, asOf: today, on: day,
            in: recordStore?.history ?? History())
    }

    /// The day view of `shownDay`, drawn from `roster`, `recordStore`'s history and
    /// `oneOffStore`'s one-offs exactly as they stand now — asks none of the three again. Shared
    /// by every caller that re-forms `dayView` after changing what it is drawn from or which day
    /// it is drawn for: the writes `tick` and `enter(_:on:)` keep before re-forming it, and the
    /// moves `showPreviousDay`, `showNextDay` and `showToday` that only step the day already
    /// held.
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
        nameRefusal = nil
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
        nameRefusal = nil
        shownDay = nextDate
        dayView = dayViewOfShownDay()
    }

    /// Shows the today this screen was last handed, from whatever day it is showing. Always has
    /// somewhere to go; does not read the roster or the record again.
    public func showToday() {
        if shownDay != today {
            notice = nil
            nameRefusal = nil
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
            nameRefusal = nil
        }
        shownDay = day
        dayView = dayViewOfShownDay()
    }

    /// The app has been shown on `today`: the day view and the record are read again. A screen
    /// showing its today follows onto the new one; a screen showing any other day goes on
    /// showing that day. The comparison is against the today the screen held before this call.
    public func shown(asOf today: CalendarDate) {
        notice = nil
        nameRefusal = nil

        if shownDay == self.today {
            shownDay = today
        }
        self.today = today

        let read = Self.readRecordAndRoster(
            recordAt: recordPlace, rosterAt: rosterPlace, oneOffAt: oneOffPlace,
            takingOnIfEmpty: commitments)
        self.recordStore = read.recordStore
        self.recordState = read.recordState
        self.rosterState = read.rosterState
        self.roster = read.roster
        self.oneOffStore = read.oneOffStore
        self.oneOffState = read.oneOffState

        self.dayView = Self.formDayView(
            of: read.roster.groups(on: shownDay), oneOffs: read.oneOffStore,
            asOf: self.today, on: shownDay, in: read.recordStore?.history ?? History())
    }

    /// The person has come back to this screen from somewhere else in the app: the roster, and
    /// where this screen is keeping a record, the record, are read again, and the day view is
    /// formed again for the day being shown. Takes no today, moves no day, and tells nothing it
    /// was telling. Where `commitmentsScreen` has restored a copy since it was opened, this
    /// instead opens all three places afresh, whether or not each was already kept, and takes on
    /// the commitments this screen was handed where the roster it reads holds nothing at all —
    /// `openspec/specs/day-screen/spec.md` § *A day screen returned to from a commitments screen
    /// that has restored a copy draws what the copy holds*. Returned to from a commitments screen
    /// that has restored no copy, or from none at all, this is returned to exactly as being
    /// returned to always was.
    public func returnedTo(from commitmentsScreen: CommitmentsScreen? = nil) {
        guard commitmentsScreen?.hasRestoredACopy == true else {
            returnedToOrdinarily()
            return
        }
        returnedToAfterARestore()
    }

    /// Being returned to after a restore: opens the record, the roster and the one-off places
    /// afresh, whether or not each was already kept, taking on the commitments this screen was
    /// handed where the roster reads nothing at all. Where a restore in progress cannot itself be
    /// undone, all three answer as reading nothing, exactly as `readRecordAndRoster` answers the
    /// same condition at `init` and `shown(asOf:)`. Where only a save in progress stands and
    /// cannot be undone, the record answers as unreadable and the roster is opened read-only,
    /// exactly as `readRecordAndRoster` answers that condition too — but the one-offs are
    /// unaffected by a torn save, so they are still opened afresh here, same as everywhere else
    /// in this function.
    private func returnedToAfterARestore() {
        notice = nil
        nameRefusal = nil

        // A restore in progress that cannot be undone: nothing is read, exactly as
        // `readRecordAndRoster` answers the same condition at `init` and `shown(asOf:)` — a
        // stricter rule than a torn save's own read-only fallback just below.
        guard
            RestoreInProgress.undoTornRestore(
                recordAt: recordPlace, rosterAt: rosterPlace, oneOffsAt: oneOffPlace)
        else {
            self.rosterState = .notKept
            self.roster = Roster()
            self.recordStore = nil
            self.recordState = .unreadable
            self.oneOffStore = nil
            self.oneOffState = .unreadable
            self.dayView = Self.formDayView(of: [], oneOffs: nil, asOf: today, on: shownDay, in: History())
            return
        }
        guard SaveInProgress.undoTornSave(recordAt: recordPlace, rosterAt: rosterPlace) else {
            let readOnly = Self.openRoster(at: rosterPlace, takingOnIfEmpty: [])
            self.rosterState = readOnly.state
            self.roster = readOnly.roster
            self.recordStore = nil
            self.recordState = .unreadable
            let openedOneOffs = Self.openOneOffs(at: oneOffPlace)
            self.oneOffStore = openedOneOffs.store
            self.oneOffState = openedOneOffs.state
            self.dayView = Self.formDayView(
                of: readOnly.roster.groups(on: shownDay), oneOffs: openedOneOffs.store, asOf: today,
                on: shownDay, in: History())
            return
        }

        let openedRoster = Self.openRoster(at: rosterPlace, takingOnIfEmpty: commitments)
        self.rosterState = openedRoster.state
        self.roster = openedRoster.roster

        let openedRecord = Self.open(at: recordPlace)
        self.recordStore = openedRecord.store
        self.recordState = openedRecord.state

        if let recordStore = openedRecord.store, openedRoster.state == .kept {
            SaveInProgress.carryBackOrphanedRecords(in: recordStore, against: openedRoster.roster)
        }

        let openedOneOffs = Self.openOneOffs(at: oneOffPlace)
        self.oneOffStore = openedOneOffs.store
        self.oneOffState = openedOneOffs.state

        self.dayView = Self.formDayView(
            of: openedRoster.roster.groups(on: shownDay), oneOffs: openedOneOffs.store, asOf: today,
            on: shownDay, in: recordStore?.history ?? History())
    }

    /// Being returned to where no copy has been restored: the roster is read again and the day
    /// view is formed again for the day being shown. Takes no today, moves no day. Where this
    /// screen is keeping a record, that is read again too — a rename or a rhythm change made
    /// elsewhere reaches every row this screen draws. A screen not keeping a record does not
    /// start keeping one by being returned to: `design.md` § *A day screen returned to now reads
    /// its record place again where it is keeping one*. The one-offs are not read again — the
    /// spec requirement "A day screen draws the one-offs at its one-off place as of the today it
    /// was handed" says "at no other moment" than being opened and the app being shown again.
    private func returnedToOrdinarily() {
        let openedRoster: (state: RosterState, roster: Roster)

        if recordState == .kept {
            // The save in progress is read here, before the roster is ever handed day one to
            // take on — `design.md` § *Reading the places undoes a torn save as it was* — and
            // only on this path: a screen not keeping a record does not start reading its places
            // for one by being returned to, exactly as it does not start keeping one. Where the
            // undo cannot be completed, the roster is opened read-only, exactly as
            // `readRecordAndRoster` opens it for the same condition at `init` and
            // `shown(asOf:)` — `openspec/specs/commitment/spec.md` § *A torn save that cannot be
            // undone keeps nothing from the record place*: "a screen reading its places SHALL
            // write nothing at either place". Taking on day one unconditionally, before this
            // check, would write it to an empty roster place while the torn save still stood.
            if SaveInProgress.undoTornSave(recordAt: recordPlace, rosterAt: rosterPlace) {
                openedRoster = Self.openRoster(at: rosterPlace, takingOnIfEmpty: commitments)

                let opened = Self.open(at: recordPlace)
                self.recordStore = opened.store
                self.recordState = opened.state

                if let recordStore = opened.store, openedRoster.state == .kept {
                    SaveInProgress.carryBackOrphanedRecords(in: recordStore, against: openedRoster.roster)
                }
            } else {
                openedRoster = Self.openRoster(at: rosterPlace, takingOnIfEmpty: [])
                self.recordStore = nil
                self.recordState = .unreadable
            }
        } else {
            openedRoster = Self.openRoster(at: rosterPlace, takingOnIfEmpty: commitments)
        }

        self.rosterState = openedRoster.state
        self.roster = openedRoster.roster

        self.dayView = Self.formDayView(
            of: openedRoster.roster.groups(on: shownDay), oneOffs: oneOffStore, asOf: today,
            on: shownDay, in: recordStore?.history ?? History())
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
