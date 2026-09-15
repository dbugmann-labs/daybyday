import Foundation

/// The roster a person manages: what they keep, what they have stopped, and the form that
/// defines a new commitment. See `openspec/specs/commitment/spec.md` for the behaviour contract
/// and this change's `design.md` § *The seam* for why the surface is shaped this way.
@MainActor
@Observable
public final class CommitmentsScreen {
    /// The place a commitments screen keeps its roster when it is not told another: exactly the
    /// place a day screen keeps its. A static, so that a test can assert the two agree without
    /// opening the real Application Support directory.
    public static var rosterPlace: URL { DayScreen.rosterPlace }

    /// Internal rather than `private`, so a test reaching through `@testable import` can confirm a
    /// screen opened with no place given actually keeps this — the one it was handed, not merely
    /// a second expression that is definitionally the same thing. `design.md` § *The seam*.
    let place: URL
    private let recordPlace: URL
    /// The one-off place `makeACopy` reads — this screen keeps no one-off store of its own to
    /// draw from, `design.md` § *Context*: a copy is read fresh from the three places every time
    /// it is asked for, never from what a screen already holds.
    /// `openspec/changes/make-a-copy/design.md` § *The seam*.
    private let oneOffPlace: URL
    private var rosterStore: RosterStore?
    private var recordStore: RecordStore?

    /// Opens on `today`, reading the roster kept at `place` and, for the record place a change
    /// carries over at, the record kept at `keepingRecordAt`. Defaults to exactly the place a day
    /// screen keeps its record, `design.md` § *The seam*: `CommitmentsScreen.init` gains this
    /// parameter and nothing else changes shape, so every existing call site compiles unchanged.
    /// `keepingOneOffsAt` defaults to the place a day screen keeps its one-offs, on the same
    /// footing — `openspec/changes/make-a-copy/design.md` § *The seam*.
    public init(
        asOf today: CalendarDate, keepingRosterAt place: URL = CommitmentsScreen.rosterPlace,
        keepingRecordAt recordPlace: URL = DayScreen.recordPlace,
        keepingOneOffsAt oneOffPlace: URL = DayScreen.oneOffPlace
    ) {
        self.place = place
        self.recordPlace = recordPlace
        self.oneOffPlace = oneOffPlace
        self.dayToKeepFrom = today

        let opened = Self.readPlaces(place: place, recordPlace: recordPlace)
        self.rosterStore = opened.rosterStore
        self.rosterState = opened.rosterState
        self.recordStore = opened.recordStore
        self.recordsBelongToNoCommitment = opened.recordsBelongToNoCommitment
        refreshLists(from: opened.rosterStore)
    }

    /// What reading the places produces: a save in progress undone first — `openspec/specs
    /// /commitment/spec.md` § *Reading the places undoes a torn save as it was* — then the roster
    /// and the record opened, and any orphaned record carried back to its one possible source
    /// before this screen says whether any remain. Shared by `init` and `shown(asOf:)`, the two
    /// places this screen reads both of its places afresh. Where the save in progress cannot be
    /// undone, this answers as a roster that cannot be read and a record that is not kept,
    /// without opening either place for real — `design.md` § *A torn save that cannot be undone
    /// reuses two existing states*.
    private static func readPlaces(
        place: URL, recordPlace: URL
    ) -> (
        rosterStore: RosterStore?, rosterState: RosterState, recordStore: RecordStore?,
        recordsBelongToNoCommitment: Bool
    ) {
        guard SaveInProgress.undoTornSave(recordAt: recordPlace, rosterAt: place) else {
            return (nil, .notKept, nil, false)
        }

        let opened = Self.open(at: place)
        let recordStore = Self.openRecord(at: recordPlace)

        guard let rosterStore = opened.store, let recordStore else {
            return (opened.store, opened.state, recordStore, false)
        }

        let recordsBelongToNoCommitment = SaveInProgress.carryBackOrphanedRecords(
            in: recordStore, against: rosterStore.roster)
        return (rosterStore, opened.state, recordStore, recordsBelongToNoCommitment)
    }

    /// Opens the roster at `place`. A place written by a later version of DayByDay is told apart
    /// as `.writtenByALaterVersion`; every other reason the store can refuse to open is answered
    /// as `.notKept`, exactly as `DayScreen`'s own opening answers the roster's refusals. This
    /// screen never takes anything on when the roster it opens holds nothing — day one belongs to
    /// the day screen alone.
    private static func open(at place: URL) -> (store: RosterStore?, state: RosterState) {
        do {
            let store = try RosterStore(at: place)
            return (store, .kept)
        } catch RosterStoreError.laterForm {
            return (nil, .writtenByALaterVersion)
        } catch {
            return (nil, .notKept)
        }
    }

    /// Opens the record at `place`. Every reason the store can refuse to open — a run of bytes
    /// that is not a record, or a place a later version of DayByDay wrote — is answered alike,
    /// `nil`: a change that then needs to carry a record over refuses as `.notKept`, the same
    /// place-could-not-be-written refusal a roster failure already answers with, `design.md`
    /// § *A place that could not be written*.
    private static func openRecord(at place: URL) -> RecordStore? {
        try? RecordStore(at: place)
    }

    /// The commitments `roster` has stopped keeping, in the order `roster` holds them. A removed
    /// commitment is in neither this list nor `kept` — `design.md` § *The seam*: removal is a
    /// third state, not a second way to be stopped.
    private static func stopped(in roster: Roster) -> [Commitment] {
        roster.entries.compactMap { $0.keptUntil == nil || $0.isRemoved ? nil : $0.commitment }
    }

    /// Sets `keptGroups`, `kept` and `stopped` from `store`, or empties all three when `store`
    /// is `nil`. The one site every read of the roster funnels through, so that no list is ever
    /// ahead of what is at the place.
    private func refreshLists(from store: RosterStore?) {
        keptGroups = store?.roster.groups ?? []
        kept = keptGroups.flatMap(\.commitments)
        stopped = store.map { Self.stopped(in: $0.roster) } ?? []
    }

    /// What this screen keeps, in **groups**: a group is a category, or no category at all,
    /// together with the entries under it, in the order the roster holds them. The groups, their
    /// order and what is in each are the roster's answer, read off it and drawn — this screen
    /// sorts none of them and invents none of its own. `design.md` § *The seam*.
    public private(set) var keptGroups: [Roster.Group] = []

    /// The categories the commitments this screen keeps are under, each once, in the order their
    /// groups are drawn. A category only a stopped commitment is under is not among them — the
    /// stopped list draws no headings, so offering it here would offer a heading nothing kept is
    /// under.
    public var categoriesInUse: [String] { keptGroups.compactMap(\.category) }

    /// The commitments the roster is keeping, read across `keptGroups` in the order they are
    /// drawn — the same commitments `keptGroups` holds and each exactly once, but not
    /// necessarily in the roster's own flat order once more than one category is in play.
    public private(set) var kept: [Commitment] = []

    /// The commitments the roster has stopped keeping, in the order the roster holds them.
    public private(set) var stopped: [Commitment] = []

    /// Anything but `.kept` means both lists are empty and nothing is taken on.
    public private(set) var rosterState: RosterState = .notKept

    /// Whether the record place holds any record of a commitment the roster holds in no state,
    /// once carrying it back to its one possible source is done —
    /// `openspec/specs/commitment/spec.md` § *A commitments screen says whether any record
    /// belongs to no commitment*. `false` where this screen cannot read either place, or holds a
    /// torn save it cannot undo.
    public private(set) var recordsBelongToNoCommitment: Bool = false

    /// The day to offer as the day a commitment is kept from: the day this screen was handed.
    public private(set) var dayToKeepFrom: CalendarDate

    /// Which of the four kinds a form is offering. Deliberately not `Commitment.Kind`, which
    /// carries the range or the target as a formed value: this is the picker, and what a person
    /// typed for the other two arrives beside it as text. `design.md` § *The seam*.
    public enum KindChoice: Hashable, Sendable, CaseIterable {
        case tick, number, note, total
    }

    /// The kind to offer for a new commitment: always the tick. It is the same answer
    /// `dayToKeepFrom` gives, for the same reason — a form that chose its own starting kind
    /// would be deciding, in a layer nothing regresses, which kind is the ordinary one.
    public var kindToOffer: KindChoice { .tick }

    /// The commitment a stop has been asked for and not yet confirmed or cancelled.
    public private(set) var awaitingConfirmation: Commitment?

    /// The commitment a removal has been asked for and not yet confirmed or cancelled.
    public private(set) var awaitingRemoval: Commitment?

    /// What has been typed back to confirm removing `awaitingRemoval`. Settable so the shell can
    /// bind a text field to it; `design.md` § *The screen holds what has been typed* is why this
    /// lives here rather than in `@State`. Cleared to `""` whenever a removal is asked for, when
    /// a second one is asked for, when either is cancelled or confirmed, and when the app is
    /// shown again.
    public var nameTypedBack: String = ""

    /// Whether `nameTypedBack` matches the name of the commitment awaiting removal, once
    /// surrounding blank space is trimmed from both. `false` when nothing is awaiting removal.
    /// This is a fact about two strings, not words a person reads — ADR-1022, restated for
    /// removal in `design.md` § *Nothing here is words a person reads*.
    public var nameTypedBackMatches: Bool {
        guard let awaitingRemoval else {
            return false
        }
        return nameTypedBack.trimmingCharacters(in: .whitespacesAndNewlines)
            == awaitingRemoval.name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// The change asked for last that was refused, and why — at most one at a time, `nil` when the
    /// last change asked for was kept and when none has been asked for. Cleared by `shown(asOf:)`.
    public private(set) var refusedChange: RefusedChange?

    /// A change a commitments screen was asked for and refused: which one, and why. The commitment
    /// is carried on the changes that are asked about a commitment already on a list — stopping,
    /// taking one up again, removing, moving and changing — so that a person is told beside the
    /// row they tapped rather than in one place for all of them.
    public enum RefusedChange: Equatable, Sendable {
        case defining(Refusal)
        case stopping(Commitment, Refusal)
        case keepingAgain(Commitment, Refusal)
        case removing(Commitment, Refusal)
        case moving(Commitment, Refusal)
        case movingGroup(String, Refusal)
        /// A change asked for, refused, and held against the commitment it was asked to change
        /// rather than the one it would have produced — `design.md` § *The two new refusals*.
        case changing(Commitment, Refusal)
        /// A restart asked for and refused, held against the commitment it was asked about — the
        /// eighth kind of refused change. `openspec/changes/add-interval-restart/design.md` §
        /// *The seam*.
        case restarting(Commitment, Refusal)
        /// A copy asked for and refused — the ninth kind of refused change. Names which of the
        /// three stores could not be read, or `nil` where the copy could not be written instead.
        /// `openspec/changes/make-a-copy/design.md` § *The refusal is the screen's existing one,
        /// with one new cause*.
        case makingACopy(Copy.Store?, Refusal)
    }

    /// Why a change was refused. `nil` from any of the thirteen below means it was kept at the
    /// place before that call returned. `Error` conformance is for `makeACopy`'s
    /// `Result<URL, Refusal>` alone — `design.md` § *The seam* — and carries no behaviour: every
    /// other caller still reads a plain `Refusal?`, never catches one.
    public enum Refusal: Error, Equatable, Sendable {
        /// A name that is empty or made only of blank space.
        case namesNothing
        /// A weekday set with no days in it — the one refusal the rule engine does not make.
        case dueOnNoDay
        /// A day of the month, an interval or a weekly quota outside what that rhythm allows.
        /// One case for all three: the person changes the number in the field they are on.
        case rhythmOutOfRange
        /// The roster is already keeping this commitment.
        case alreadyKept
        /// The roster could not be written, the record place could not be written, or this
        /// screen is not keeping either.
        case notKept
        /// A change a stopped commitment does not take: its rhythm and its kept-from day have no
        /// days left to decide about. The act is to take the commitment up again first.
        case stoppedCommitmentCannotChangeRhythm
        /// A day already recorded on that the change would leave not due — moving the kept-from
        /// day later on any rhythm, or moving an interval rhythm's kept-from day off a whole
        /// number of intervals in either direction. `design.md` § *An interval rhythm's grid
        /// moves with the day it is kept from*.
        case wouldLeaveARecordedDayNotDue
        /// A change that would carry records onto a commitment the record place already holds
        /// records of, told apart from `wouldLeaveARecordedDayNotDue` — which is given instead
        /// where a change meets both causes. `design.md` § *The not-due cause is judged first,
        /// then the records already kept*.
        case recordsAlreadyExist
        /// A range whose lowest is above its highest, whose end is not a number, or with one
        /// end typed and the other blank.
        case rangeIsNotARange
        /// A target that is not a number, not above zero, or blank.
        case targetIsNotATarget
        /// A restart asked from a date later than the day this screen was handed.
        case restartDayIsAfterToday
        /// A restart asked from a date earlier than the day the commitment is kept from.
        case restartDayIsBeforeKeptFrom
        /// A restart asked from a date the commitment is already due on — restarting there would
        /// change nothing.
        case alreadyDueOnRestartDay
        /// A store that could not be read while forming a copy — which one is named on the
        /// `RefusedChange` this leaves, not here, so the value answered to the caller stays the
        /// same whichever store it was. `openspec/changes/make-a-copy/design.md` § *The refusal
        /// is the screen's existing one, with one new cause*.
        case storeCouldNotBeRead
    }

    /// A field of the sheet a commitments screen draws — a define, a change or a restart form —
    /// that a refusal can be about. One control in one row whichever rhythm is chosen, so `.rhythm`
    /// covers the chips, the wheel, the interval row and the quota stepper alike: the refusal
    /// carried beside the field already says which of them is at fault. `design.md` § *One rhythm
    /// field, and the foot is no field at all*.
    public enum SheetField: Equatable, Sendable {
        case name, rhythm, keptFrom, range, target, restartDay
    }

    /// A refusal told on a commitments screen's sheet, and which field of it the refusal is about
    /// — `nil` for a refusal about the whole change, told at the foot of the form. `design.md` §
    /// *A second value, not a place on the refused change*: held beside `refusedChange` rather
    /// than added to it, so a name typed on a sheet cannot end a refusal told beside a row on
    /// either list.
    public struct SheetRefusal: Equatable, Sendable {
        public let field: SheetField?
        public let refusal: Refusal
    }

    /// What this screen tells on its sheet, or `nil` when there is nothing to tell. `design.md` §
    /// *The seam*.
    public private(set) var sheetRefusal: SheetRefusal?

    /// The sheet's `field` has been edited. Ends `sheetRefusal` where it is about `field`, and
    /// leaves it standing otherwise — including where it is about the whole change, which no edit
    /// can reach. `openspec/specs/commitment/spec.md` § *What a commitments screen tells on its
    /// sheet lasts until that field is edited, the next ask, the sheet closing or the app being
    /// shown again*.
    public func sheetFieldEdited(_ field: SheetField) {
        if sheetRefusal?.field == field {
            sheetRefusal = nil
        }
    }

    /// The sheet has been closed. Ends `sheetRefusal` unconditionally.
    public func sheetClosed() {
        sheetRefusal = nil
    }

    /// The weekday set a form starts its chips from where it has nothing behind them: always all
    /// seven, whatever the roster holds. `design.md` § *The weekdays offered are their own
    /// requirement*.
    public var weekdaysToOffer: Set<Weekday> {
        []
    }

    /// What a commitment on either of this screen's lists is made of — the value a sheet fills
    /// itself from to change one. A value and not a form: it holds nothing a person typed and
    /// nothing a person reads. `design.md` § *The seam*.
    public struct Change: Equatable, Sendable {
        public let name: String
        public let rhythm: Rhythm
        public let keptFrom: CalendarDate
        public let category: String?
        /// `false` for a commitment its roster has stopped keeping: it has no days left for a
        /// rhythm to decide about, so the only change it takes is a rename.
        public let canChangeRhythmAndKeptFrom: Bool
        /// The kind this commitment's days take, with the range or the target that kind
        /// carries. Shown, and not one of the four a change is asked with: a kind is set when a
        /// commitment is defined and never changes. `design.md` § *The seam*.
        public let kind: Commitment.Kind
        /// Whether this commitment can be restarted: `true` where its roster is keeping it and
        /// its schedule is an interval of days, `false` otherwise.
        /// `openspec/changes/add-interval-restart/design.md` § *The seam*.
        public let canRestart: Bool
    }

    /// Forms a commitment from `name`, the schedule `rhythm` names when kept from `keptFrom`,
    /// `keptFrom` and `kind`, and takes it on. Takes a commitment the roster has stopped up
    /// again. `lowest`, `highest` and `target` are the number kind's range and the total kind's
    /// target, exactly as a person typed them — read only for the kind that has room for them,
    /// `design.md` § *A range or a target left in a field the chosen kind has no room for is
    /// ignored*.
    public func define(
        name: String, on rhythm: Rhythm, keptFrom: CalendarDate, under category: String?,
        kind: KindChoice = .tick, lowest: String = "", highest: String = "", target: String = ""
    ) -> Refusal? {
        if case .weekdays(let weekdays) = rhythm, weekdays.isEmpty {
            refusedChange = .defining(.dueOnNoDay)
            sheetRefusal = SheetRefusal(field: .rhythm, refusal: .dueOnNoDay)
            return .dueOnNoDay
        }

        guard let schedule = rhythm.schedule(keptFrom: keptFrom) else {
            refusedChange = .defining(.rhythmOutOfRange)
            sheetRefusal = SheetRefusal(field: .rhythm, refusal: .rhythmOutOfRange)
            return .rhythmOutOfRange
        }

        guard !Blank.saysNothing(name) else {
            refusedChange = .defining(.namesNothing)
            sheetRefusal = SheetRefusal(field: .name, refusal: .namesNothing)
            return .namesNothing
        }

        let formedKind: Commitment.Kind
        switch kind {
        case .tick:
            formedKind = .tick
        case .number:
            switch Self.range(lowest: lowest, highest: highest) {
            case .success(let range):
                formedKind = .number(range: range)
            case .failure(let refusal):
                refusedChange = .defining(refusal)
                sheetRefusal = SheetRefusal(field: .range, refusal: refusal)
                return refusal
            }
        case .note:
            formedKind = .note
        case .total:
            switch Self.target(target) {
            case .success(let target):
                formedKind = .total(target: target)
            case .failure(let refusal):
                refusedChange = .defining(refusal)
                sheetRefusal = SheetRefusal(field: .target, refusal: refusal)
                return refusal
            }
        }

        let commitment = Commitment(name: name, schedule: schedule, keptFrom: keptFrom, kind: formedKind)!

        guard let rosterStore else {
            refusedChange = .defining(.notKept)
            sheetRefusal = SheetRefusal(field: nil, refusal: .notKept)
            return .notKept
        }

        do {
            guard try rosterStore.add(commitment, under: category) else {
                refusedChange = .defining(.alreadyKept)
                sheetRefusal = SheetRefusal(field: nil, refusal: .alreadyKept)
                return .alreadyKept
            }
        } catch {
            refusedChange = .defining(.notKept)
            sheetRefusal = SheetRefusal(field: nil, refusal: .notKept)
            return .notKept
        }

        refusedChange = nil
        refreshLists(from: rosterStore)
        return nil
    }

    /// What reading a range or a target from what a person typed comes back as: the same shape
    /// `Swift.Result` offers, without asking `Refusal` to conform to `Error` merely to be handed
    /// back alongside the value — nothing above this seam throws or catches one.
    private enum Reading<Value> {
        case success(Value)
        case failure(Refusal)
    }

    /// `lowest` and `highest` read as a range for the number kind — `nil` where both are blank,
    /// which is no range and is kept; `.rangeIsNotARange` where one is blank and the other is
    /// not, where either does not read as a number, or where the lowest reads above the highest.
    /// `design.md` § *Blank is asked before the reading*.
    private static func range(
        lowest: String, highest: String
    ) -> Reading<Commitment.Range?> {
        let lowestIsBlank = Blank.saysNothing(lowest)
        let highestIsBlank = Blank.saysNothing(highest)

        if lowestIsBlank, highestIsBlank {
            return .success(nil)
        }
        guard !lowestIsBlank, !highestIsBlank else {
            return .failure(.rangeIsNotARange)
        }
        guard case .number(let lowestValue) = TypedNumber.read(lowest),
            case .number(let highestValue) = TypedNumber.read(highest)
        else {
            return .failure(.rangeIsNotARange)
        }
        guard let range = Commitment.Range(lowest: lowestValue, highest: highestValue) else {
            return .failure(.rangeIsNotARange)
        }
        return .success(range)
    }

    /// `text` read as a target for the total kind — `.targetIsNotATarget` where it is blank,
    /// does not read as a number, or reads as a number not above zero.
    private static func target(_ text: String) -> Reading<Commitment.Target> {
        guard case .number(let value) = TypedNumber.read(text), let target = Commitment.Target(value)
        else {
            return .failure(.targetIsNotATarget)
        }
        return .success(target)
    }

    /// What `commitment` is made of, so a form opened to change it starts from what that
    /// commitment is rather than from what a new one would be. `nil` for a commitment on neither
    /// of this screen's lists — kept or stopped are the only two a change can reach.
    public func whatItIsMadeOf(_ commitment: Commitment) -> Change? {
        guard let rosterStore,
            let entry = rosterStore.roster.entries.first(where: { $0.commitment == commitment }),
            !entry.isRemoved
        else {
            return nil
        }

        return Change(
            name: commitment.name, rhythm: Rhythm(commitment.schedule), keptFrom: commitment.keptFrom,
            category: entry.category, canChangeRhythmAndKeptFrom: entry.keptUntil == nil,
            kind: commitment.kind,
            canRestart: entry.keptUntil == nil && Self.isIntervalSchedule(commitment.schedule))
    }

    /// Whether `schedule` is an interval of days — the one rhythm a restart applies to.
    /// `openspec/changes/add-interval-restart/design.md` § *The seam*.
    private static func isIntervalSchedule(_ schedule: Schedule) -> Bool {
        if case .everyNDays = schedule {
            return true
        }
        return false
    }

    /// `category`, or nothing where `category` holds nothing but blank space — the same
    /// normalization `Roster` applies to a category, applied here so the no-op check below and
    /// the roster's own comparison never disagree on what "the category it is already under"
    /// means. `design.md` § *B-037 carries no requirement*.
    private static func normalizedCategory(_ category: String?) -> String? {
        category.flatMap { Blank.saysNothing($0) ? nil : $0 }
    }

    /// Which field a refusal that could be about either the rhythm or the day kept from is
    /// about: whichever of the two `commitment` is actually made of differs from what was asked,
    /// and `nil` — the whole change — where both differ. `openspec/specs/commitment/spec.md` §
    /// *A commitments screen says whether a refusal about a rhythm or a day kept from is about
    /// one of them or the whole change*, `design.md` § *The screen decides which field, not the
    /// sheet*.
    private static func ambiguousField(
        askedRhythm: Rhythm, askedKeptFrom: CalendarDate, from commitment: Commitment
    ) -> SheetField? {
        let rhythmDiffers = Rhythm(commitment.schedule) != askedRhythm
        let keptFromDiffers = commitment.keptFrom != askedKeptFrom
        if rhythmDiffers, !keptFromDiffers {
            return .rhythm
        }
        if keptFromDiffers, !rhythmDiffers {
            return .keptFrom
        }
        return nil
    }

    /// Why carrying every record of `commitment` over to `target` would be refused, reading
    /// `history` rather than writing it — `nil` where it may proceed. The not-due cause is
    /// judged first: every date `commitment` holds a record on must be due on `target`, or the
    /// change is refused as leaving a recorded day not due. Only then is `target` asked whether
    /// the record place already holds any record of it, whether or not `commitment` holds any
    /// itself — a rename must not adopt records that belong to no commitment on the roster.
    /// `design.md` § *The not-due cause is judged first, then the records already kept* and §
    /// *Refused whether or not the source holds records*.
    private static func refusalCarryingRecords(
        from commitment: Commitment, to target: Commitment, in history: History
    ) -> Refusal? {
        guard history.datesRecorded(for: commitment).allSatisfy({ target.isDue(on: $0) }) else {
            return .wouldLeaveARecordedDayNotDue
        }
        guard !history.holdsRecords(of: target) else {
            return .recordsAlreadyExist
        }
        return nil
    }

    /// Keeps a save in progress beside `recordPlace`, naming `source`'s records as carried to
    /// `carried`, where `hasRecords` says there is anything of `source` to carry — a change or
    /// restart that carries none keeps none, `design.md` § *The save in progress lives beside
    /// the record place, not at a place of its own*. `nil` on success, with or without one kept;
    /// `.notKept` — a place that could not be written, writing nothing — otherwise. Takes
    /// `hasRecords` already judged rather than a `History` to ask itself, because a restart's own
    /// answer is dated — onOrAfter the day it restarts from — while a change's is not.
    private static func keepSaveInProgressIfCarrying(
        from source: Commitment, to carried: Commitment, whenAnyRecorded hasRecords: Bool,
        at recordPlace: URL
    ) -> Refusal? {
        guard hasRecords else {
            return nil
        }
        do {
            try SaveInProgress(carriedFrom: source, to: carried).keep(
                at: SaveInProgress.place(besideRecordAt: recordPlace))
        } catch {
            return .notKept
        }
        return nil
    }

    /// Runs after this screen's own `recordStore` has already carried records forward for a
    /// change or a restart, to undo the save in progress that carry kept — exactly the call the
    /// next read of the places would make, but run here so the file never outlives a save that
    /// landed or stands torn. A successful undo runs through a second, disjoint `RecordStore`
    /// `SaveInProgress` opens for itself, so this screen's own copy — which already carried the
    /// records forward before this runs — is left holding what the record place no longer has
    /// until this reopens it; skipping that reopen would let this screen's next write put the
    /// stale copy back over whatever the undo just corrected. Where the undo itself cannot be
    /// completed, this screen goes on to hold a torn save it cannot undo, answering exactly as
    /// `readPlaces` does for the same condition at `init` — `design.md` § *A torn save that
    /// cannot be undone reuses two existing states* and `openspec/specs/commitment/spec.md` §
    /// *A change that carries records leaves a save in progress until its roster place is
    /// written*: "Where that undo fails, the screen SHALL from then on hold a torn save it
    /// cannot undo." Answers whether the undo succeeded: every caller on a success path — the
    /// roster place was just written and this is only tidying the file up after it — MUST stop
    /// at `false` rather than going on to draw its lists from the local `RosterStore` binding it
    /// opened this change or restart with, which is still set and still reflects the write even
    /// once this has cleared `self.rosterStore` for it.
    @discardableResult
    private func undoTornSaveMadeDuringThisChange() -> Bool {
        guard SaveInProgress.undoTornSave(recordAt: recordPlace, rosterAt: place) else {
            rosterStore = nil
            rosterState = .notKept
            recordStore = nil
            recordsBelongToNoCommitment = false
            refreshLists(from: nil)
            return false
        }
        recordStore = Self.openRecord(at: recordPlace)
        return true
    }

    /// Changes `commitment`, on either of this screen's lists, for the commitment `name`,
    /// `rhythm` and `keptFrom` name, under `category`. Works out from those which of two acts —
    /// carrying every record over to the changed commitment, or superseding — the change needs,
    /// performing both in one order where it needs both: the carry-over first, then the
    /// supersession. See `openspec/specs/commitment/spec.md` § *A commitments screen changes a
    /// commitment on either of its lists* and `design.md` § *Two acts, not one*.
    public func change(
        _ commitment: Commitment, toName name: String, on rhythm: Rhythm, keptFrom: CalendarDate,
        under category: String?
    ) -> Refusal? {
        guard kept.contains(commitment) || stopped.contains(commitment) else {
            return nil
        }

        guard let rosterStore,
            let entry = rosterStore.roster.entries.first(where: { $0.commitment == commitment })
        else {
            refusedChange = .changing(commitment, .notKept)
            return .notKept
        }

        let isStopped = stopped.contains(commitment)
        let sameRhythm = Rhythm(commitment.schedule) == rhythm

        guard !isStopped || (sameRhythm && keptFrom == commitment.keptFrom) else {
            refusedChange = .changing(commitment, .stoppedCommitmentCannotChangeRhythm)
            sheetRefusal = SheetRefusal(
                field: Self.ambiguousField(askedRhythm: rhythm, askedKeptFrom: keptFrom, from: commitment),
                refusal: .stoppedCommitmentCannotChangeRhythm)
            return .stoppedCommitmentCannotChangeRhythm
        }

        guard !Blank.saysNothing(name) else {
            refusedChange = .changing(commitment, .namesNothing)
            return .namesNothing
        }

        if case .weekdays(let weekdays) = rhythm, weekdays.isEmpty {
            refusedChange = .changing(commitment, .dueOnNoDay)
            return .dueOnNoDay
        }

        guard let newSchedule = rhythm.schedule(keptFrom: keptFrom) else {
            refusedChange = .changing(commitment, .rhythmOutOfRange)
            return .rhythmOutOfRange
        }

        let normalizedCategory = Self.normalizedCategory(category)

        if sameRhythm {
            // A different name, a different day kept from, or both, on the rhythm the
            // commitment already runs on — every record of it is carried over to the changed
            // one, and the roster then changes the commitment for it, in the place it holds it.
            // An unchanged day kept from keeps the schedule the commitment already has, even
            // where that schedule's own start date differs from it; only a different day
            // rebuilds the schedule from that day. `design.md` § *An unchanged day kept from
            // keeps the schedule it has*.
            let changedSchedule = keptFrom == commitment.keptFrom ? commitment.schedule : newSchedule
            let changedCommitment = Commitment(
                name: name, schedule: changedSchedule, keptFrom: keptFrom, kind: commitment.kind)!

            if changedCommitment == commitment, normalizedCategory == entry.category {
                // The four things name the commitment that is already there, and the category
                // it is already under: change nothing, write nothing, refuse nothing.
                return nil
            }

            guard
                changedCommitment == commitment
                    || !rosterStore.roster.entries.contains(where: { $0.commitment == changedCommitment })
            else {
                refusedChange = .changing(commitment, .alreadyKept)
                return .alreadyKept
            }

            if changedCommitment != commitment {
                guard let recordStore else {
                    refusedChange = .changing(commitment, .notKept)
                    return .notKept
                }

                if let refusal = Self.refusalCarryingRecords(
                    from: commitment, to: changedCommitment, in: recordStore.history)
                {
                    refusedChange = .changing(commitment, refusal)
                    let field: SheetField? =
                        refusal == .wouldLeaveARecordedDayNotDue
                        ? Self.ambiguousField(askedRhythm: rhythm, askedKeptFrom: keptFrom, from: commitment)
                        : nil
                    sheetRefusal = SheetRefusal(field: field, refusal: refusal)
                    return refusal
                }

                if let refusal = Self.keepSaveInProgressIfCarrying(
                    from: commitment, to: changedCommitment,
                    whenAnyRecorded: recordStore.history.holdsRecords(of: commitment), at: recordPlace)
                {
                    refusedChange = .changing(commitment, refusal)
                    return refusal
                }

                do {
                    // The two checks above already answer both causes `carryOver` itself
                    // refuses for; a `false` here means a record type has gained a formation
                    // rule beyond `isDue` that they do not yet cover. Treated the same as the
                    // requirement already does for a day a record could not have been made on:
                    // `openspec/specs/commitment/spec.md` § *A commitments screen refuses a
                    // change it cannot make* — "no record SHALL be carried over to a day it
                    // could not have been made on".
                    guard try recordStore.carryOver(commitment, to: changedCommitment) else {
                        refusedChange = .changing(commitment, .wouldLeaveARecordedDayNotDue)
                        return .wouldLeaveARecordedDayNotDue
                    }
                } catch {
                    refusedChange = .changing(commitment, .notKept)
                    return .notKept
                }
            }

            do {
                _ = try rosterStore.change(commitment, to: changedCommitment, under: category)
            } catch {
                if changedCommitment != commitment {
                    undoTornSaveMadeDuringThisChange()
                }
                refusedChange = .changing(commitment, .notKept)
                return .notKept
            }

            if changedCommitment != commitment {
                // Told the save finished by the roster it just wrote, not by the file: this is
                // the same call the next read of the places would make, run here so the file
                // never outlives a save that landed. `design.md` § *A save finished is told by
                // the roster, not by the file*. Where that undo itself cannot be completed, this
                // screen now holds a torn save it cannot undo — `rosterStore` above is the
                // `self.rosterStore` this just cleared, not a fresh read, so drawing the lists
                // from it here would redraw exactly what the screen can no longer answer for.
                guard undoTornSaveMadeDuringThisChange() else {
                    refusedChange = nil
                    return nil
                }
            }

            refusedChange = nil
            refreshLists(from: rosterStore)
            return nil
        }

        // A different rhythm: the roster supersedes. `commitment` is kept until the day before
        // the day this screen was handed and held removed; the commitment the four things name
        // — kept from the day this screen was handed — is taken on in its place.
        let nameOrKeptFromChanged = name != commitment.name || keptFrom != commitment.keptFrom
        let supersedeKeptUntil = Self.dayBefore(dayToKeepFrom)
        let finalNewCommitment = Commitment(
            name: name, schedule: newSchedule, keptFrom: dayToKeepFrom, kind: commitment.kind)!

        guard !nameOrKeptFromChanged else {
            // Both, in one save: the carry-over first — the superseded commitment carries the
            // new name and the corrected day it was kept from — then the supersession, which
            // starts today. `design.md` § *Both in one save*.
            // The commitment carried to before a supersession follows the same rule as the
            // same-rhythm path: an unchanged day kept from keeps the schedule `commitment`
            // already has, on the rhythm it already runs on. `design.md` § *An unchanged day
            // kept from keeps the schedule it has*.
            let oldRhythm = Rhythm(commitment.schedule)
            let carryTargetSchedule =
                keptFrom == commitment.keptFrom ? commitment.schedule : oldRhythm.schedule(keptFrom: keptFrom)!
            let carryTarget = Commitment(
                name: name, schedule: carryTargetSchedule, keptFrom: keptFrom, kind: commitment.kind)!

            guard !rosterStore.roster.entries.contains(where: { $0.commitment == carryTarget })
            else {
                refusedChange = .changing(commitment, .alreadyKept)
                return .alreadyKept
            }
            guard !rosterStore.roster.entries.contains(where: { $0.commitment == finalNewCommitment })
            else {
                refusedChange = .changing(commitment, .alreadyKept)
                return .alreadyKept
            }

            guard let recordStore else {
                refusedChange = .changing(commitment, .notKept)
                return .notKept
            }

            if let refusal = Self.refusalCarryingRecords(
                from: commitment, to: carryTarget, in: recordStore.history)
            {
                refusedChange = .changing(commitment, refusal)
                return refusal
            }

            if let refusal = Self.keepSaveInProgressIfCarrying(
                from: commitment, to: carryTarget,
                whenAnyRecorded: recordStore.history.holdsRecords(of: commitment), at: recordPlace)
            {
                refusedChange = .changing(commitment, refusal)
                return refusal
            }

            do {
                // Same fallback as the same-rhythm path above: the two checks already answer
                // both causes `carryOver` refuses for, so a `false` here can only be a formation
                // rule beyond `isDue` that they do not yet cover.
                guard try recordStore.carryOver(commitment, to: carryTarget) else {
                    refusedChange = .changing(commitment, .wouldLeaveARecordedDayNotDue)
                    return .wouldLeaveARecordedDayNotDue
                }
            } catch {
                refusedChange = .changing(commitment, .notKept)
                return .notKept
            }

            do {
                // The rename and the supersession are one act on the roster, not two: both are
                // applied to a single in-memory `Roster` value and kept in one write, so a place
                // that goes unwritable partway through can never leave the rename kept and the
                // supersession refused, or the reverse.
                var nextRoster = rosterStore.roster
                _ = nextRoster.change(commitment, to: carryTarget, under: entry.category)
                _ = nextRoster.supersede(
                    carryTarget, with: finalNewCommitment, keptUntil: supersedeKeptUntil,
                    under: category)
                _ = try rosterStore.replace(with: nextRoster)
            } catch {
                undoTornSaveMadeDuringThisChange()
                refusedChange = .changing(commitment, .notKept)
                return .notKept
            }

            // Told the save finished by the roster it just wrote, not by the file — the same
            // call the next read of the places would make, run here so the file never outlives a
            // save that landed. `design.md` § *A save finished is told by the roster, not by the
            // file*. Where that undo itself cannot be completed, this screen now holds a torn
            // save it cannot undo — `rosterStore` above is the `self.rosterStore` this just
            // cleared, not a fresh read, so drawing the lists from it here would redraw exactly
            // what the screen can no longer answer for.
            guard undoTornSaveMadeDuringThisChange() else {
                refusedChange = nil
                return nil
            }

            refusedChange = nil
            refreshLists(from: rosterStore)
            return nil
        }

        guard !rosterStore.roster.entries.contains(where: { $0.commitment == finalNewCommitment })
        else {
            refusedChange = .changing(commitment, .alreadyKept)
            return .alreadyKept
        }

        do {
            _ = try rosterStore.supersede(
                commitment, with: finalNewCommitment, keptUntil: supersedeKeptUntil, under: category)
        } catch {
            refusedChange = .changing(commitment, .notKept)
            return .notKept
        }

        refusedChange = nil
        refreshLists(from: rosterStore)
        return nil
    }

    /// Why carrying the records of `commitment` made on or after `day` over to `restarted` would
    /// be refused, reading `history` rather than writing it — `nil` where it may proceed. Mirrors
    /// `refusalCarryingRecords(from:to:in:)`, but judges only the dates on or after `day`: the
    /// same not-due-first order, then records already kept.
    /// `openspec/changes/add-interval-restart/design.md` § *The order refusals are judged in*.
    private static func refusalCarryingRecordsOnOrAfter(
        from commitment: Commitment, to restarted: Commitment, onOrAfter day: CalendarDate,
        in history: History
    ) -> Refusal? {
        let datesOnOrAfter = history.datesRecorded(for: commitment).filter { day.days(until: $0) >= 0 }
        guard datesOnOrAfter.allSatisfy({ restarted.isDue(on: $0) }) else {
            return .wouldLeaveARecordedDayNotDue
        }
        guard !history.holdsRecords(of: restarted) else {
            return .recordsAlreadyExist
        }
        return nil
    }

    /// Restarts `commitment`'s count from `day`: supersedes it as of the day before `day` with a
    /// commitment alike in name, interval and kind, whose schedule starts on `day` and which is
    /// kept from `day`, under the category `commitment` is under. Every record of `commitment`
    /// made on or after `day` is carried onto the restarted commitment at the record place,
    /// written before the roster place; every record made before `day` stays under `commitment`.
    /// See `openspec/specs/commitment/spec.md` §§ *A commitments screen restarts an interval
    /// commitment it keeps, from a day it is given*, *A commitments screen refuses a restart it
    /// cannot make* and *A commitments screen says whether a commitment can be restarted, and
    /// offers the day it was handed to restart from*, and this change's `design.md`.
    ///
    /// Does nothing and says nothing when `commitment` cannot be restarted: not on `kept`, or not
    /// on an interval schedule. Otherwise refuses, in order: a day later than `dayToKeepFrom`; a
    /// day earlier than `commitment`'s own `keptFrom`; a day `commitment` is already due on; a
    /// restart whose result the roster already holds, in any state; a day already recorded on
    /// that the restart would leave not due; records already kept under the restarted
    /// commitment; and a place that could not be written.
    @discardableResult public func restart(_ commitment: Commitment, from day: CalendarDate) -> Refusal? {
        // `kept.contains(commitment)` already guarantees `rosterStore` is not `nil` and holds an
        // `entry` for `commitment`: `rosterStore` is assigned only in `init` and `shown(asOf:)`,
        // each immediately followed by `refreshLists(from:)` on that same store, which is the one
        // place `kept` is ever set — straight off `rosterStore.roster.groups` — so the two never
        // drift apart. Binding both here, beside the interval schedule check, costs no refusal an
        // unreachable guard further down would ever have produced.
        guard kept.contains(commitment), case .everyNDays(let interval, from: _) = commitment.schedule,
            let rosterStore,
            let entry = rosterStore.roster.entries.first(where: { $0.commitment == commitment })
        else {
            return nil
        }

        guard day.days(until: dayToKeepFrom) >= 0 else {
            refusedChange = .restarting(commitment, .restartDayIsAfterToday)
            sheetRefusal = SheetRefusal(field: .restartDay, refusal: .restartDayIsAfterToday)
            return .restartDayIsAfterToday
        }

        guard commitment.keptFrom.days(until: day) >= 0 else {
            refusedChange = .restarting(commitment, .restartDayIsBeforeKeptFrom)
            sheetRefusal = SheetRefusal(field: .restartDay, refusal: .restartDayIsBeforeKeptFrom)
            return .restartDayIsBeforeKeptFrom
        }

        guard !commitment.isDue(on: day) else {
            refusedChange = .restarting(commitment, .alreadyDueOnRestartDay)
            sheetRefusal = SheetRefusal(field: .restartDay, refusal: .alreadyDueOnRestartDay)
            return .alreadyDueOnRestartDay
        }

        let restartedSchedule = Schedule.everyNDays(interval, from: day)
        let restarted = Commitment(
            name: commitment.name, schedule: restartedSchedule, keptFrom: day, kind: commitment.kind)!

        guard !rosterStore.roster.entries.contains(where: { $0.commitment == restarted }) else {
            refusedChange = .restarting(commitment, .alreadyKept)
            sheetRefusal = SheetRefusal(field: .restartDay, refusal: .alreadyKept)
            return .alreadyKept
        }

        guard let recordStore else {
            refusedChange = .restarting(commitment, .notKept)
            sheetRefusal = SheetRefusal(field: nil, refusal: .notKept)
            return .notKept
        }

        if let refusal = Self.refusalCarryingRecordsOnOrAfter(
            from: commitment, to: restarted, onOrAfter: day, in: recordStore.history)
        {
            refusedChange = .restarting(commitment, refusal)
            sheetRefusal = SheetRefusal(field: .restartDay, refusal: refusal)
            return refusal
        }

        let carriesRecords = recordStore.history.datesRecorded(for: commitment).contains {
            day.days(until: $0) >= 0
        }
        if let refusal = Self.keepSaveInProgressIfCarrying(
            from: commitment, to: restarted, whenAnyRecorded: carriesRecords, at: recordPlace)
        {
            refusedChange = .restarting(commitment, refusal)
            sheetRefusal = SheetRefusal(field: nil, refusal: refusal)
            return refusal
        }

        do {
            guard try recordStore.carryOver(commitment, to: restarted, onOrAfter: day) else {
                refusedChange = .restarting(commitment, .wouldLeaveARecordedDayNotDue)
                sheetRefusal = SheetRefusal(field: .restartDay, refusal: .wouldLeaveARecordedDayNotDue)
                return .wouldLeaveARecordedDayNotDue
            }
        } catch {
            refusedChange = .restarting(commitment, .notKept)
            sheetRefusal = SheetRefusal(field: nil, refusal: .notKept)
            return .notKept
        }

        let supersedeKeptUntil = Self.dayBefore(day)
        do {
            _ = try rosterStore.supersede(
                commitment, with: restarted, keptUntil: supersedeKeptUntil, under: entry.category)
        } catch {
            undoTornSaveMadeDuringThisChange()
            refusedChange = .restarting(commitment, .notKept)
            sheetRefusal = SheetRefusal(field: nil, refusal: .notKept)
            return .notKept
        }

        // Told the save finished by the roster it just wrote, not by the file — `design.md` §
        // *A save finished is told by the roster, not by the file*. Where that undo itself cannot
        // be completed, this screen now holds a torn save it cannot undo — `rosterStore` above is
        // the `self.rosterStore` this just cleared, not a fresh read, so drawing the lists from it
        // here would redraw exactly what the screen can no longer answer for.
        guard undoTornSaveMadeDuringThisChange() else {
            refusedChange = nil
            return nil
        }

        refusedChange = nil
        refreshLists(from: rosterStore)
        return nil
    }

    /// Puts `commitment` up for confirmation, replacing whatever was there, and leaves nothing
    /// awaiting removal — a screen has at most one change of any kind awaiting confirmation.
    /// Does nothing when `kept` does not hold it.
    public func askToStopKeeping(_ commitment: Commitment) {
        guard kept.contains(commitment) else {
            return
        }
        awaitingConfirmation = commitment
        awaitingRemoval = nil
        nameTypedBack = ""
    }

    /// Leaves nothing awaiting confirmation and changes nothing else.
    public func cancelStopKeeping() {
        awaitingConfirmation = nil
    }

    /// Stops keeping whatever is awaiting confirmation, as of the day before the one this screen
    /// holds — `design.md` § *The day before*, settled answer 3: the day the screen was handed
    /// answers with nothing afterwards, and only the day before it still does. Falls back to the
    /// day this screen holds itself where the calendar has no day before it (1 January 1583),
    /// rather than refusing something a person has no remedy for. Answers `nil` and does nothing
    /// when nothing is awaiting confirmation.
    @discardableResult public func confirmStopKeeping() -> Refusal? {
        guard let commitment = awaitingConfirmation else {
            return nil
        }
        awaitingConfirmation = nil

        guard let rosterStore else {
            refusedChange = .stopping(commitment, .notKept)
            return .notKept
        }

        do {
            try rosterStore.retire(commitment, keptUntil: Self.dayBefore(dayToKeepFrom))
        } catch {
            refusedChange = .stopping(commitment, .notKept)
            return .notKept
        }

        refusedChange = nil
        refreshLists(from: rosterStore)
        return nil
    }

    /// The day before `date`, or `date` itself where the calendar has no day before it (1 January
    /// 1583) — the one helper every day-before change goes through, so a stop and a removal made
    /// through this screen agree on it. `design.md` § *The day before, and the one date that has
    /// no day before it*.
    private static func dayBefore(_ date: CalendarDate) -> CalendarDate {
        date.adding(days: -1) ?? date
    }

    /// Puts `commitment` up for removal, replacing whatever was there, and leaves nothing
    /// awaiting a stop — a screen has at most one change of any kind awaiting confirmation. Does
    /// nothing when neither `kept` nor `stopped` holds it.
    public func askToRemove(_ commitment: Commitment) {
        guard kept.contains(commitment) || stopped.contains(commitment) else {
            return
        }
        awaitingRemoval = commitment
        nameTypedBack = ""
        awaitingConfirmation = nil
    }

    /// Leaves nothing awaiting removal and nothing typed back, and changes nothing else.
    public func cancelRemoving() {
        awaitingRemoval = nil
        nameTypedBack = ""
    }

    /// Removes whatever is awaiting removal, as of the day before the one this screen holds where
    /// the roster is still keeping it — the same day-before rule and the same fallback
    /// `confirmStopKeeping` uses — or the day it was already kept until where the roster had
    /// already stopped keeping it, which `Roster.remove` enforces on its own by ignoring the date
    /// it is handed there. Answers `nil` and does nothing when nothing is awaiting removal, and
    /// when what has been typed back does not match: no refusal, because a name still being typed
    /// is not a change anyone has asked for yet.
    @discardableResult public func confirmRemoving() -> Refusal? {
        guard let commitment = awaitingRemoval else {
            return nil
        }
        guard nameTypedBackMatches else {
            return nil
        }
        awaitingRemoval = nil
        nameTypedBack = ""

        guard let rosterStore else {
            refusedChange = .removing(commitment, .notKept)
            return .notKept
        }

        do {
            try rosterStore.remove(commitment, keptUntil: Self.dayBefore(dayToKeepFrom))
        } catch {
            refusedChange = .removing(commitment, .notKept)
            return .notKept
        }

        refusedChange = nil
        refreshLists(from: rosterStore)
        return nil
    }

    /// Takes `commitment` up again, in the place it has. Answers `nil` and does
    /// nothing when `stopped` does not hold it.
    @discardableResult public func keepAgain(_ commitment: Commitment) -> Refusal? {
        guard stopped.contains(commitment) else {
            return nil
        }
        guard let rosterStore else {
            refusedChange = .keepingAgain(commitment, .notKept)
            return .notKept
        }

        do {
            try rosterStore.add(commitment)
        } catch {
            refusedChange = .keepingAgain(commitment, .notKept)
            return .notKept
        }

        refusedChange = nil
        refreshLists(from: rosterStore)
        return nil
    }

    /// The roster's own offset a drop of `commitment` at `offset` — counted over the entries
    /// `group` draws — lands at. `design.md` § *The offset a screen takes is over the group it
    /// was dropped in*: the entry `group` draws at `offset`, or the last entry `group` draws
    /// where `offset` is the number it draws — except on the two offsets that leave `commitment`
    /// where it is drawn (the one it is drawn at in `group`, and the one just after, both only
    /// where `group` is the group `commitment` is already in), which answer with the place
    /// `commitment` already has, because a drop that has moved nothing has not recategorised
    /// anything either. `nil` when `offset` is outside what `group` draws, or there is no roster
    /// to place it in.
    private func rosterOffset(for commitment: Commitment, droppedAt offset: Int, in group: Roster.Group)
        -> Int?
    {
        guard (0...group.commitments.count).contains(offset) else {
            return nil
        }

        let ownIndex = group.commitments.firstIndex(of: commitment)
        if let ownIndex, offset == ownIndex || offset == ownIndex + 1 {
            return rosterStore?.roster.commitments.firstIndex(of: commitment)
        }

        // `offset == group.commitments.count` names the place immediately after the last entry
        // *this group* draws — not after the roster's own last kept commitment, which may sit in
        // a different group entirely.
        if offset == group.commitments.count {
            guard let last = group.commitments.last,
                let lastRosterOffset = rosterStore?.roster.commitments.firstIndex(of: last)
            else {
                return nil
            }
            return lastRosterOffset + 1
        }

        return rosterStore?.roster.commitments.firstIndex(of: group.commitments[offset])
    }

    /// Moves `commitment` to `offset`, counted over the entries drawn in the group named by
    /// `category` as they stand before the move — not over `kept`, `design.md` § *The offset a
    /// screen takes is over the group it was dropped in* — and puts it under `category`. Does
    /// nothing and says nothing, neither refusing nor changing anything, when `commitment` is
    /// not in what this screen keeps — stopped or on neither list — when `category` names a
    /// group nothing this screen keeps is under, or when `offset` is outside what that group
    /// draws, each a place that is not there rather than a move the roster refuses. Answers
    /// `nil` on the change being kept, including a move that leaves what is kept exactly where
    /// it was. Neither `awaitingConfirmation` nor `awaitingRemoval` is touched: a move takes
    /// neither slot.
    @discardableResult public func move(
        _ commitment: Commitment, toOffset offset: Int, under category: String?
    ) -> Refusal? {
        guard kept.contains(commitment) else {
            return nil
        }
        guard let group = keptGroups.first(where: { $0.category == category }) else {
            return nil
        }
        guard let rosterOffset = rosterOffset(for: commitment, droppedAt: offset, in: group) else {
            return nil
        }
        guard let rosterStore else {
            refusedChange = .moving(commitment, .notKept)
            return .notKept
        }

        let rosterBeforeMove = rosterStore.roster
        do {
            try rosterStore.move(commitment, toOffset: rosterOffset, under: category)
        } catch {
            refusedChange = .moving(commitment, .notKept)
            return .notKept
        }

        // Settled answer 13: a call that reaches the place with no change to make does not end a
        // standing refused-change notice. `design.md` § *A store writes what a change made* is
        // why the comparison is against the roster itself rather than the boolean `move` answers.
        if rosterStore.roster != rosterBeforeMove {
            refusedChange = nil
        }
        refreshLists(from: rosterStore)
        return nil
    }

    /// Moves the **group** named by `category` to `offset`, counted over the groups this screen
    /// draws that are under a category, as they stand before the move — the same count and the
    /// same order the roster's own answers, so this screen converts nothing. Does nothing and
    /// says nothing, neither refusing nor changing anything, when `category` names a group this
    /// screen draws none of — including the group of the commitments under no category, which
    /// this act never takes — or when `offset` is outside what the groups under a category draw.
    /// Answers `nil` on the change being kept, including a move that leaves what is drawn exactly
    /// where it was. `design.md` § *The seam*.
    @discardableResult public func move(group category: String?, toOffset offset: Int) -> Refusal? {
        guard let category, categoriesInUse.contains(category) else {
            return nil
        }
        guard (0...categoriesInUse.count).contains(offset) else {
            return nil
        }
        guard let rosterStore else {
            refusedChange = .movingGroup(category, .notKept)
            return .notKept
        }

        let rosterBeforeMove = rosterStore.roster
        do {
            try rosterStore.move(group: category, toOffset: offset)
        } catch {
            refusedChange = .movingGroup(category, .notKept)
            return .notKept
        }

        // Settled answer 13, read the same way `move` and `put` read it: a call that reaches the
        // place with no change to make does not end a standing refused-change notice.
        if rosterStore.roster != rosterBeforeMove {
            refusedChange = nil
        }
        refreshLists(from: rosterStore)
        return nil
    }

    /// The place `makeACopy` writes into when it is not told another: the platform's temporary
    /// directory, which the platform may clear on its own schedule — nothing holds a copy's URL
    /// past the share sheet. This is **not** the **copy place** `#269` adds, which a person picks
    /// once for the app to write a copy at on its own. `openspec/changes/make-a-copy/design.md`
    /// § *The file is written where the platform may clear it, and the screen answers where*.
    public static var copyDirectory: URL {
        FileManager.default.temporaryDirectory
    }

    /// What reading the three stores for a copy comes back as — a plain enum rather than
    /// `Swift.Result`, which `Copy.Store` need not conform to `Error` merely to be handed back
    /// alongside a success, on the same footing as `Reading<Value>` above.
    private enum StoresForCopy {
        case opened(record: RecordStore, roster: RosterStore, oneOffs: OneOffStore)
        case unreadable(Copy.Store)
    }

    /// Opens the record, the roster and the one-off store at `recordPlace`, `rosterPlace` and
    /// `oneOffPlace`, undoing a save in progress first — the same `undoTornSave` path
    /// `readPlaces` takes, so a torn save is undone and an earlier-form store yields a
    /// current-form copy. Unlike `readPlaces`, this never carries an orphaned record back: a copy
    /// SHALL leave the three places exactly as it found them, apart from a save in progress
    /// undone — `openspec/specs/restore/spec.md` § *A copy is what the three places hold, read
    /// when it is asked for*. `.failure` names the first of the three, checked in that order,
    /// that could not be read; a save in progress that could not itself be undone is told as the
    /// record, the place it stands beside.
    private static func readStoresForCopy(
        recordPlace: URL, rosterPlace: URL, oneOffPlace: URL
    ) -> StoresForCopy {
        guard SaveInProgress.undoTornSave(recordAt: recordPlace, rosterAt: rosterPlace) else {
            return .unreadable(.record)
        }
        guard let recordStore = try? RecordStore(at: recordPlace) else {
            return .unreadable(.record)
        }
        guard let rosterStore = try? RosterStore(at: rosterPlace) else {
            return .unreadable(.roster)
        }
        guard let oneOffStore = try? OneOffStore(at: oneOffPlace) else {
            return .unreadable(.oneOffs)
        }
        return .opened(record: recordStore, roster: rosterStore, oneOffs: oneOffStore)
    }

    /// The file name a copy asked for at `moment` is written under: the app's name, the day as
    /// `yyyy-MM-dd`, and the hour and the minute as `HH.mm`, each padded to two digits, with a
    /// single space between the three parts and the extension `daybyday`.
    /// `openspec/specs/restore/spec.md` § *A copy is a file named for the minute it was made, of
    /// the app's own kind*.
    private static func fileName(for moment: Moment) -> String {
        String(
            format: "DayByDay %04d-%02d-%02d %02d.%02d.daybyday",
            moment.day.year, moment.day.month, moment.day.day, moment.hour, moment.minute)
    }

    /// Writes `copy` into `directory`, creating it first where it does not yet exist, and answers
    /// where it was written. Replaces a file of the same name already there — the same minute's
    /// copy, asked for twice. Throws where the directory could not be created or the file could
    /// not be written.
    private static func writeCopy(_ copy: Copy, into directory: URL) throws -> URL {
        let document = CopyDocument(copy)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let data = try encoder.encode(document)

        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let url = directory.appendingPathComponent(Self.fileName(for: copy.moment))
        try data.write(to: url, options: .atomic)
        return url
    }

    /// Forms a copy of the record, the roster and the one-offs as of `moment`, and writes it as a
    /// single file into `directory`, answering where. Reads the three places fresh — never what
    /// this screen already holds, `openspec/specs/restore/spec.md` § *A copy is what the three
    /// places hold, read when it is asked for* — so a copy is exactly what those places hold at
    /// the moment it is asked for, whether or not this screen can read its own roster.
    ///
    /// A store that cannot be read refuses the whole copy as `.storeCouldNotBeRead`, holding
    /// which store against `.makingACopy`; a directory that cannot be written to refuses as
    /// `.notKept`, naming no store. Either replaces whatever refused change this screen already
    /// held, exactly as every other refusal does. A copy made does **not** end a refused change
    /// already held — `refusedChange` is left untouched on success:
    /// `openspec/specs/commitment/spec.md` § *What a commitments screen holds about a refused
    /// change lasts until the app is shown again or a change is kept* — "Nor SHALL a copy made
    /// end it: the file a copy is written at is not a place this screen keeps a change at."
    public func makeACopy(
        asOf moment: Moment, writingInto directory: URL = CommitmentsScreen.copyDirectory
    ) -> Result<URL, Refusal> {
        switch Self.readStoresForCopy(
            recordPlace: recordPlace, rosterPlace: place, oneOffPlace: oneOffPlace)
        {
        case .unreadable(let store):
            refusedChange = .makingACopy(store, .storeCouldNotBeRead)
            return .failure(.storeCouldNotBeRead)
        case .opened(let record, let roster, let oneOffs):
            let copy = Copy(
                moment: moment, history: record.history, roster: roster.roster,
                oneOffs: oneOffs.oneOffs)
            do {
                let url = try Self.writeCopy(copy, into: directory)
                return .success(url)
            } catch {
                refusedChange = .makingACopy(nil, .notKept)
                return .failure(.notKept)
            }
        }
    }

    /// The app has been shown on `today`: the day this screen holds is replaced and the roster is
    /// read again.
    public func shown(asOf today: CalendarDate) {
        dayToKeepFrom = today
        refusedChange = nil
        awaitingRemoval = nil
        nameTypedBack = ""

        let opened = Self.readPlaces(place: place, recordPlace: recordPlace)
        rosterStore = opened.rosterStore
        rosterState = opened.rosterState
        recordStore = opened.recordStore
        recordsBelongToNoCommitment = opened.recordsBelongToNoCommitment
        refreshLists(from: opened.rosterStore)
    }
}
