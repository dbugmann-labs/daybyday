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

    /// The copy place this screen writes to after every change it keeps — `nil` where none was
    /// handed in, which is the whole of "no copying": every call site that reaches a place
    /// compiles and behaves unchanged. `design.md` § *One copy place, handed to both screens*. A
    /// plain stored property, set once at `init` and never reassigned: a leading-underscore
    /// stored property beside a same-named computed one sits in the `@Observable` macro's own
    /// generated namespace, which this avoids by not needing the second name at all.
    public private(set) var copyPlace: CopyPlace?

    /// Opens on `today`, reading the roster kept at `place` and, for the record place a change
    /// carries over at, the record kept at `keepingRecordAt`. Defaults to exactly the place a day
    /// screen keeps its record, `design.md` § *The seam*: `CommitmentsScreen.init` gains this
    /// parameter and nothing else changes shape, so every existing call site compiles unchanged.
    /// `keepingOneOffsAt` defaults to the place a day screen keeps its one-offs, on the same
    /// footing — `openspec/changes/make-a-copy/design.md` § *The seam*. `copyingTo` is the copy
    /// place a kept change writes to, `nil` by default so every existing call site still compiles
    /// unchanged — `openspec/changes/copy-on-every-change/design.md` § *The seam*.
    public init(
        asOf today: CalendarDate, keepingRosterAt place: URL = CommitmentsScreen.rosterPlace,
        keepingRecordAt recordPlace: URL = DayScreen.recordPlace,
        keepingOneOffsAt oneOffPlace: URL = DayScreen.oneOffPlace,
        copyingTo copyPlace: CopyPlace? = nil
    ) {
        self.place = place
        self.recordPlace = recordPlace
        self.oneOffPlace = oneOffPlace
        self.dayToKeepFrom = today
        self.copyPlace = copyPlace

        let opened = Self.readPlaces(place: place, recordPlace: recordPlace, oneOffPlace: oneOffPlace)
        self.rosterStore = opened.rosterStore
        self.rosterState = opened.rosterState
        self.recordStore = opened.recordStore
        self.recordsBelongToNoCommitment = opened.recordsBelongToNoCommitment
        self.storesNotRead = opened.storesNotRead
        refreshLists(from: opened.rosterStore)
    }

    /// What reading the places produces: a restore in progress undone first, then a save in
    /// progress — `openspec/changes/restore-from-a-copy/design.md` § *Whole or nothing, across a
    /// stop* (ADR-1056) and `openspec/specs/commitment/spec.md` § *Reading the places undoes a
    /// torn save as it was* — then the roster, the record and the one-offs opened, and any
    /// orphaned record carried back to its one possible source before this screen says whether any
    /// remain. Shared by `init`, `shown(asOf:)` and `confirmRestoring`, which all read all three
    /// places afresh. Runs through `CopyPlace.readStores`, the one place the cause per store is
    /// told apart, so the offer, a refused copy and the copy place's own stop all read off the
    /// same answer — `design.md` § *One reading of the three places, carrying the cause*. Where
    /// the restore in progress or the save in progress cannot be undone, this answers as a roster
    /// that cannot be read and a record that is not kept, without opening any of the three for
    /// real — `openspec/changes/save-change-whole/design.md` § *A torn save that cannot be undone
    /// reuses two existing states*.
    private static func readPlaces(
        place: URL, recordPlace: URL, oneOffPlace: URL
    ) -> (
        rosterStore: RosterStore?, rosterState: RosterState, recordStore: RecordStore?,
        recordsBelongToNoCommitment: Bool, storesNotRead: [StoreNotRead]
    ) {
        let read = CopyPlace.readStores(
            recordAt: recordPlace, rosterAt: place, oneOffsAt: oneOffPlace)

        let rosterState: RosterState
        switch read.notRead.first(where: { $0.store == .roster })?.cause {
        case .writtenByALaterVersion: rosterState = .writtenByALaterVersion
        case .couldNotBeRead: rosterState = .notKept
        case nil: rosterState = .kept
        }

        guard let rosterStore = read.roster, let recordStore = read.record else {
            return (read.roster, rosterState, read.record, false, read.notRead)
        }

        _ = try? recordStore.settle(rosterStore.fold)
        let recordsBelongToNoCommitment = SaveInProgress.carryBackOrphanedRecords(
            in: recordStore, against: rosterStore.roster)
        return (rosterStore, rosterState, recordStore, recordsBelongToNoCommitment, read.notRead)
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
    /// commitment is in neither this list nor `kept`, and neither is an earlier era of one this
    /// screen keeps or has stopped — `design.md` § *The seam*: removal is a third state, not a
    /// second way to be stopped, and `Roster.stopped`, which this defers to, already keeps an
    /// earlier era off this list.
    private static func stopped(in roster: Roster) -> [Commitment] {
        roster.stopped
    }

    /// Sets `keptGroups`, `kept` and `stopped` from `store`, or empties all three when `store`
    /// is `nil`. The one site every read of the roster funnels through, so that no list is ever
    /// ahead of what is at the place.
    private func refreshLists(from store: RosterStore?) {
        keptGroups = store?.roster.groups ?? []
        kept = keptGroups.flatMap(\.commitments)
        stopped = store.map { Self.stopped(in: $0.roster) } ?? []
    }

    /// Ends `refusedChange`, `stoppedRefusal` and `copyRestored`, which last alike: until the
    /// app is shown again or a change reaches a place — `openspec/specs/commitment/spec.md` §
    /// *What a commitments screen holds about a refused change lasts until the app is shown
    /// again or a change is kept* and `openspec/changes/restore-from-a-copy/specs/restore/
    /// spec.md` § *A restore confirmed makes the three places what the copy holds, and nothing
    /// of what was there* — "hold the moment of
    /// the copy it restored until the app is shown again or a change is kept." Every call site
    /// that used to clear `refusedChange` alone calls this instead; every one already sits
    /// exactly where a change reached a place or the app was shown, guarded against a no-op the
    /// same way `refusedChange` always was. `stoppedRefusal` gets no rule of its own — `keepAgain`
    /// is the one place that sets it, and it is read only against a name still standing in
    /// `stopped`, so it is cleared here rather than answering a change or a rename that leaves it
    /// stale, the way a renamed kept commitment otherwise would.
    private func endedByAChangeOrByBeingShown() {
        refusedChange = nil
        stoppedRefusal = nil
        copyRestored = nil
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

    /// Which of the record place, the roster place and the one-off place cannot be read, in the
    /// order record, roster, one-offs, and why — read when this screen is opened, when the app is
    /// shown again and when a restore is confirmed, and never because this screen is drawn.
    /// `openspec/specs/restore/spec.md` § *A commitments screen offers a take-out only while a
    /// store cannot be read, and says which*.
    public private(set) var storesNotRead: [StoreNotRead] = []

    /// Whether a take-out may be asked for: exactly while `storesNotRead` names at least one
    /// place.
    public var offersATakeOut: Bool { !storesNotRead.isEmpty }

    /// The day to offer as the day a commitment is kept from: the day this screen was handed.
    public private(set) var dayToKeepFrom: CalendarDate

    /// How many commitments a roster keeps and has stopped, and how many one-offs a one-off place
    /// holds — `nil` for a count a place that cannot be read would otherwise give.
    /// `openspec/changes/restore-from-a-copy/design.md` § *The seam*.
    public struct Counts: Hashable, Sendable {
        public let kept: Int?
        public let stopped: Int?
        public let oneOffs: Int?
    }

    /// Which of the three places cannot be read, and which of the two things is so — `design.md`
    /// § *One reading of the three places, carrying the cause*: the one answer the offer, a
    /// refused copy and the copy place's own stop all read off.
    public struct StoreNotRead: Hashable, Sendable {
        public let store: Copy.Store
        public let cause: Cause

        public enum Cause: Hashable, Sendable {
            case couldNotBeRead
            case writtenByALaterVersion
        }

        public init(store: Copy.Store, cause: Cause) {
            self.store = store
            self.cause = cause
        }
    }

    /// A restore asked for and not yet confirmed, cancelled or replaced by another ask: the
    /// moment the copy was made, what it and the phone each keep, have stopped and hold as
    /// one-offs, and which of the phone's three places, if any, could not be read.
    /// `openspec/changes/restore-from-a-copy/design.md` § *The seam*.
    public struct AwaitingRestore: Hashable, Sendable {
        public let moment: Moment
        public let copy: Counts
        public let phone: Counts
        public let unreadable: [Copy.Store]
    }

    /// A restore asked for and not yet confirmed, cancelled or replaced by another ask. `nil`
    /// once it has been.
    public private(set) var awaitingRestore: AwaitingRestore?

    /// The copy `awaitingRestore` was read from, held so `confirmRestoring` writes exactly what
    /// `askToRestore` read rather than reading the file a second time — `design.md` § *What is
    /// said first, read once*.
    private var pendingRestore: Copy?

    /// The folder `awaitingRestore` was asked for through `givenAsCopyPlace`, so confirming or
    /// replacing it also makes that folder the copy place — `nil` for a restore asked through
    /// `askToRestore(from:)`, which never touches the copy place.
    /// `openspec/changes/copy-on-every-change/design.md` § *The seam*.
    private var pendingCopyPlaceFolder: URL?

    /// The moment of the copy this screen last restored, until the app is shown again or a
    /// change reaches a place. `nil` where this screen has restored no copy since it was opened,
    /// or once one of those two things has happened.
    public private(set) var copyRestored: Moment?

    /// Whether this screen has restored a copy since it was opened — never cleared, unlike
    /// `copyRestored`, so a day screen returned to after a kept change still reads all three
    /// places afresh. `design.md` § *The day screen is told by the commitments screen it returns
    /// from*. Internal rather than `private`, so `DayScreen.returnedTo(from:)` can read it.
    private(set) var hasRestoredACopy = false

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

    /// A folder given as the copy place that does not hold a readable copy — refused for its own
    /// reason, held apart from `refusedChange` and from the change it holds refused rather than
    /// inside it. At most one at a time; ends when the app is shown again or another folder is
    /// given. `openspec/specs/restore/spec.md` § *A folder holding a copy that cannot be read is
    /// refused as a copy place*.
    public private(set) var refusedCopyPlace: Refusal?

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
        /// rather than the one it would have produced —
        /// `openspec/changes/add-commitment-editing/design.md` § *The two new refusals*.
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
        /// A restore asked for or confirmed and refused — the tenth kind of refused change. Names
        /// neither a commitment nor a store: a refused restore is refused whole.
        /// `openspec/changes/restore-from-a-copy/design.md` § *The seam*.
        case restoring(Refusal)
        /// A take-out asked for and refused — the eleventh kind of refused change. Names which
        /// store could not be taken out — a save in progress or a restore in progress named as the
        /// record, the place it stands beside — or `nil` where the directory it was to be written
        /// into could not be written instead. `design.md` § *A refused take-out reuses the refused
        /// change, with a case of its own*.
        case takingOut(Copy.Store?, Refusal)

        /// The `Refusal` every case above carries — always the last value alongside whatever the
        /// case names about what was refused. Internal rather than `public`: `refuse(_:on:)` is
        /// its only reader, and holding it here makes a call naming the wrong refusal for its
        /// case unwritable, rather than merely unlikely.
        var refusal: Refusal {
            switch self {
            case .defining(let refusal): return refusal
            case .stopping(_, let refusal): return refusal
            case .keepingAgain(_, let refusal): return refusal
            case .removing(_, let refusal): return refusal
            case .moving(_, let refusal): return refusal
            case .movingGroup(_, let refusal): return refusal
            case .changing(_, let refusal): return refusal
            case .restarting(_, let refusal): return refusal
            case .makingACopy(_, let refusal): return refusal
            case .restoring(let refusal): return refusal
            case .takingOut(_, let refusal): return refusal
            }
        }
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
        /// The roster could not be written, the record place could not be written, or this
        /// screen is not keeping either.
        case notKept
        /// A change a stopped commitment does not take: its rhythm, its kept-from day, its range
        /// and its target have no days left to decide about. The act is to take the commitment
        /// up again first. `openspec/changes/change-range-and-target/design.md` § *Two members
        /// renamed*.
        case stoppedCommitmentDoesNotTakeThisChange
        /// A day already recorded on that the change would leave not due — moving the kept-from
        /// day later on any rhythm, or moving an interval rhythm's kept-from day off a whole
        /// number of intervals in either direction. `design.md` § *An interval rhythm's grid
        /// moves with the day it is kept from*.
        case wouldLeaveARecordedDayNotDue
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
        /// A store that was written by a later version of DayByDay while forming a copy — told
        /// apart from `storeCouldNotBeRead` rather than folded into it, so a refused copy and a
        /// stopped copy each say so rather than that the store could not be read. Which store is
        /// named on the `RefusedChange` this leaves, not here — `design.md` § *The later-version
        /// cause is said wherever the store is named*.
        case storeWrittenByALaterVersion
        /// A file that could not be read at all, or whose content does not read as a copy's own
        /// form and a moment. `openspec/changes/restore-from-a-copy/design.md` § *Reading a
        /// copy: the envelope decides, and a later version outranks damage*.
        case notACopy
        /// A file that reads as a copy's form and moment, but holds a store that is missing, or
        /// that does not read as the shape its form has.
        case damagedCopy
        /// A file whose own form, or the form of a store it holds, is later than this app reads.
        case copyFromALaterVersion
        /// A name a commitment this screen's roster keeps or has stopped keeping already has,
        /// carrying that commitment's name exactly as the roster holds it. `design.md` § *The
        /// seam*. Declared for § 1.5; § 10 gives it its behaviour.
        case nameAlreadyInUse(String)
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

    /// A refusal told in a stopped row's footer — a resume refused for a name a commitment this
    /// screen keeps already has, or for a roster place that could not be read or could not be
    /// written — or `nil` when there is nothing to tell. `design.md` § *The seam*. Declared for
    /// § 1.5; § 10 gives it its behaviour.
    public private(set) var stoppedRefusal: SheetRefusal?

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

    /// Sets `refusedChange` and `sheetRefusal` together — the one place every refusal in
    /// `define`, `change` and `restart` sets both, so a refusal cannot set one without the
    /// other. `refusal` was once hand-paired beside `change` at every call site — the two lines
    /// set at some sites and not others, so a call could compile with `sheetRefusal` naming a
    /// different refusal than `refusedChange` did. Reading it back out of `change` instead makes
    /// that mismatch unwritable.
    private func refuse(_ change: RefusedChange, on field: SheetField?) {
        refusedChange = change
        sheetRefusal = SheetRefusal(field: field, refusal: change.refusal)
    }

    /// The weekday set a form starts its chips from where it has nothing behind them: always all
    /// seven, whatever the roster holds. `design.md` § *The weekdays offered are their own
    /// requirement*.
    public var weekdaysToOffer: Set<Weekday> {
        [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
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
        /// rhythm, a kept-from day, a range or a target to decide about, so the only change it
        /// takes is to its name and its category. `openspec/changes/change-range-and-target
        /// /design.md` § *Two members renamed*.
        public let canChangeMoreThanNameAndCategory: Bool
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
            refuse(.defining(.dueOnNoDay), on: .rhythm)
            return .dueOnNoDay
        }

        guard let schedule = rhythm.schedule(keptFrom: keptFrom) else {
            refuse(.defining(.rhythmOutOfRange), on: .rhythm)
            return .rhythmOutOfRange
        }

        guard !Blank.saysNothing(name) else {
            refuse(.defining(.namesNothing), on: .name)
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
                refuse(.defining(refusal), on: .range)
                return refusal
            }
        case .note:
            formedKind = .note
        case .total:
            switch Self.target(target) {
            case .success(let target):
                formedKind = .total(target: target)
            case .failure(let refusal):
                refuse(.defining(refusal), on: .target)
                return refusal
            }
        }

        let commitment = Commitment(name: name, schedule: schedule, keptFrom: keptFrom, kind: formedKind)!

        guard let rosterStore else {
            refuse(.defining(.notKept), on: nil)
            return .notKept
        }

        do {
            guard try rosterStore.add(commitment, under: category) else {
                let refusal = Refusal.nameAlreadyInUse(Self.nameAlreadyHeld(name, among: kept + stopped))
                refuse(.defining(refusal), on: .name)
                return refusal
            }
        } catch {
            refuse(.defining(.notKept), on: nil)
            return .notKept
        }

        endedByAChangeOrByBeingShown()
        sheetRefusal = nil
        refreshLists(from: rosterStore)
        copyPlace?.keptAChange()
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

    /// The kind `commitment` should carry after a change asking for `lowest`, `highest` and
    /// `target` — read exactly as `define` reads them, and only for the kind that has room for
    /// them: a range for the number kind, a target for the total kind, nothing for a tick or a
    /// note. `lowest` and `highest` both `nil`, or `target` `nil`, is the range or the target
    /// `commitment` already carries — a value the seam already allows and never a fourth state,
    /// exactly what the sheet prefills and hands straight back on a change it asks nothing new
    /// of. `openspec/changes/change-range-and-target/design.md` § *Three more strings, and `nil`
    /// is the value it already carries*.
    private static func changedKind(
        of commitment: Commitment, lowest: String?, highest: String?, target: String?
    ) -> Reading<Commitment.Kind> {
        switch commitment.kind {
        case .tick, .note:
            return .success(commitment.kind)
        case .number:
            guard lowest != nil || highest != nil else {
                return .success(commitment.kind)
            }
            switch Self.range(lowest: lowest ?? "", highest: highest ?? "") {
            case .success(let range):
                return .success(.number(range: range))
            case .failure(let refusal):
                return .failure(refusal)
            }
        case .total:
            guard let target else {
                return .success(commitment.kind)
            }
            switch Self.target(target) {
            case .success(let target):
                return .success(.total(target: target))
            case .failure(let refusal):
                return .failure(refusal)
            }
        }
    }

    /// What `commitment` is made of, so a form opened to change it starts from what that
    /// commitment is rather than from what a new one would be. `nil` for a commitment on neither
    /// of this screen's lists — kept or stopped are the only two a change can reach. The day it
    /// is kept from is that commitment's earliest era's, and the rhythm, the kind and what that
    /// kind carries are its newest era's — `openspec/changes/give-a-commitment-an-identity/
    /// specs/commitment/spec.md` § *A commitments screen says what a commitment it is asked to
    /// change is made of*: "The day it is kept from SHALL be that commitment's earliest era's,
    /// and the rhythm and the range or the target SHALL be its newest era's."
    public func whatItIsMadeOf(_ commitment: Commitment) -> Change? {
        guard let rosterStore,
            let entry = rosterStore.roster.entries.first(where: { $0.commitment == commitment }),
            !entry.isRemoved
        else {
            return nil
        }

        let newest = entry.commitment
        let keptFrom = rosterStore.roster.keptFrom(of: commitment) ?? newest.keptFrom

        return Change(
            name: newest.name, rhythm: Rhythm(newest.schedule), keptFrom: keptFrom,
            category: entry.category, canChangeMoreThanNameAndCategory: entry.keptUntil == nil,
            kind: newest.kind,
            canRestart: entry.keptUntil == nil && Self.isIntervalSchedule(newest.schedule))
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

    /// Whether `lhs` and `rhs` are one name for the name refusal: the same but for the case of a
    /// letter, or for blank space at the start or the end of either — mirrors `Roster`'s own,
    /// private, `sameName(_:_:)`, which this screen cannot reach across files. `openspec/specs/
    /// commitment/spec.md` § *A roster refuses a commitment whose name one it keeps or has
    /// stopped already has*.
    private static func sameName(_ lhs: String, _ rhs: String) -> Bool {
        Blank.trimmed(lhs).lowercased() == Blank.trimmed(rhs).lowercased()
    }

    /// The name `name` collided with, exactly as `commitments` holds it — the commitment the
    /// name refusal names. Falls back to `name` itself only where none of `commitments` actually
    /// collides, which `Roster.add`'s own refusal never leaves true.
    private static func nameAlreadyHeld(_ name: String, among commitments: [Commitment]) -> String {
        commitments.first { sameName($0.name, name) }?.name ?? name
    }

    /// Which field a refusal that could be about the rhythm, the day kept from, the range or the
    /// target is about: whichever one of the four `currentRhythm`/`currentKeptFrom`/`currentKind`
    /// (what the commitment is currently made of) differs from what was asked, and `nil` — the
    /// whole change — where more than one differs. Takes the current values explicitly, rather
    /// than reading them off a single `Commitment`, because a multi-era commitment's day kept
    /// from is its earliest era's while its rhythm and kind are its newest era's — `design.md` §
    /// *The screen decides which field, not the sheet* and `openspec/changes/
    /// change-range-and-target/design.md` § *One comparison over four things, not two*.
    private static func ambiguousField(
        askedRhythm: Rhythm, askedKeptFrom: CalendarDate, askedKind: Commitment.Kind,
        currentRhythm: Rhythm, currentKeptFrom: CalendarDate, currentKind: Commitment.Kind
    ) -> SheetField? {
        let rhythmDiffers = currentRhythm != askedRhythm
        let keptFromDiffers = currentKeptFrom != askedKeptFrom
        let kindDiffers = askedKind != currentKind

        guard [rhythmDiffers, keptFromDiffers, kindDiffers].filter({ $0 }).count == 1 else {
            return nil
        }

        if rhythmDiffers {
            return .rhythm
        }
        if keptFromDiffers {
            return .keptFrom
        }
        switch askedKind {
        case .number: return .range
        case .total: return .target
        case .tick, .note: return nil
        }
    }

    /// `roster`, with the eras of `identity` moved onto `newKeptFrom`: the earliest surviving
    /// era's schedule rebuilt from that day, on the rhythm it already runs on, and every era
    /// `newKeptFrom` would leave holding no day dropped. `design.md` § *The seam* and
    /// `openspec/changes/give-a-commitment-an-identity/specs/commitment/spec.md` § *A commitments
    /// screen changes a commitment by renaming it, moving the day it is kept from, or putting a
    /// new era on it*: "A day kept from moved forward past the day an era gives way SHALL drop
    /// every era it would leave holding no day, and the earliest surviving era SHALL be kept from
    /// that day." Moving `newKeptFrom` earlier drops nothing — widening the window only ever
    /// leaves every era holding at least the days it already held.
    private static func movingDayKeptFrom(
        _ identity: Commitment.Identity, to newKeptFrom: CalendarDate, in roster: Roster
    ) -> Roster {
        var roster = roster
        let ownIndices = roster.entries.indices.filter { roster.entries[$0].commitment.identity == identity }
        guard !ownIndices.isEmpty else {
            return roster
        }

        let toDrop = ownIndices.dropFirst().filter { index in
            guard let keptUntil = roster.entries[index].keptUntil else { return false }
            return newKeptFrom.days(until: keptUntil) < 0
        }
        let survivingIndices = ownIndices.filter { !toDrop.contains($0) }

        guard let earliestSurvivingIndex = survivingIndices.last else {
            return roster
        }
        let earliestEntry = roster.entries[earliestSurvivingIndex]
        let earliestCommitment = earliestEntry.commitment
        let rebuiltSchedule =
            Rhythm(earliestCommitment.schedule).schedule(keptFrom: newKeptFrom) ?? earliestCommitment.schedule
        let rebuilt = Commitment(
            era: earliestCommitment, schedule: rebuiltSchedule, keptFrom: newKeptFrom,
            kind: earliestCommitment.kind)!
        roster.entries[earliestSurvivingIndex] = Roster.Entry(
            commitment: rebuilt, keptUntil: earliestEntry.keptUntil, isRemoved: earliestEntry.isRemoved,
            category: earliestEntry.category)

        for index in toDrop.sorted(by: >) {
            roster.entries.remove(at: index)
        }
        return roster
    }

    /// Why the change that would leave `roster` as it stands should be refused, reading `history`
    /// rather than writing it — `nil` where it may proceed. `openspec/changes/
    /// give-a-commitment-an-identity/specs/commitment/spec.md` § *A commitments screen refuses a
    /// change it cannot make, and tells each refusal apart*: "A change SHALL be refused as a day
    /// already recorded on that the change would leave not due where any day the commitment has
    /// a record on is a day it would not be due on after the change." Every date `commitment`'s
    /// identity holds a record on, wherever it was made, is asked against `roster` as the change
    /// would leave it: due when some era of that identity holds the date within its own span and
    /// is itself due on it.
    private static func refusalLeavingARecordedDayNotDue(
        for commitment: Commitment, in roster: Roster, history: History
    ) -> Refusal? {
        let dueAfterChange = history.datesRecorded(for: commitment).allSatisfy { date in
            roster.entries.contains { entry in
                entry.commitment.identity == commitment.identity
                    && entry.commitment.keptFrom.days(until: date) >= 0
                    && (entry.keptUntil.map { date.days(until: $0) >= 0 } ?? true)
                    && entry.commitment.isDue(on: date)
            }
        }
        return dueAfterChange ? nil : .wouldLeaveARecordedDayNotDue
    }

    /// Changes `commitment`, on either of this screen's lists, for the commitment `name`,
    /// `rhythm`, `keptFrom` and, where its kind has room for one, `lowest`/`highest` or `target`
    /// name, under `category`. Works out from those which of three acts the change needs, doing
    /// each it needs and no other, at the roster place alone: a different name renames the
    /// commitment through every era of it; a different day kept from changes its earliest era
    /// for one kept from that day; a different rhythm, range or target puts a new era on it, kept
    /// from the day this screen was handed. One save renames first, moves the day second and puts
    /// the era on third, so the day-move and the new era both see the name already written.
    /// `lowest`, `highest` and `target` are read exactly as `define` reads them; `nil` for a
    /// range or a target is the one `commitment` already carries, `design.md` § *Three more
    /// strings, and `nil` is the value it already carries*. No record moves and nothing is
    /// written at the record place by any of them. See `openspec/changes/
    /// give-a-commitment-an-identity/specs/commitment/spec.md` § *A commitments screen changes a
    /// commitment by renaming it, moving the day it is kept from, or putting a new era on it* and
    /// § *A commitments screen refuses a change it cannot make, and tells each refusal apart*.
    public func change(
        _ commitment: Commitment, toName name: String, on rhythm: Rhythm, keptFrom: CalendarDate,
        under category: String?, lowest: String? = nil, highest: String? = nil, target: String? = nil
    ) -> Refusal? {
        guard kept.contains(commitment) || stopped.contains(commitment) else {
            return nil
        }

        guard let rosterStore,
            let entry = rosterStore.roster.entries.first(where: { $0.commitment == commitment })
        else {
            refuse(.changing(commitment, .notKept), on: nil)
            return .notKept
        }

        let isStopped = stopped.contains(commitment)
        let currentCommitment = entry.commitment
        let sameRhythm = Rhythm(currentCommitment.schedule) == rhythm
        let currentKeptFrom = rosterStore.roster.keptFrom(of: commitment) ?? currentCommitment.keptFrom
        let keptFromChanged = keptFrom != currentKeptFrom
        let nameChanged = name != currentCommitment.name

        guard !Blank.saysNothing(name) else {
            refuse(.changing(commitment, .namesNothing), on: .name)
            return .namesNothing
        }

        if case .weekdays(let weekdays) = rhythm, weekdays.isEmpty {
            refuse(.changing(commitment, .dueOnNoDay), on: .rhythm)
            return .dueOnNoDay
        }

        guard rhythm.schedule(keptFrom: keptFrom) != nil else {
            refuse(.changing(commitment, .rhythmOutOfRange), on: .rhythm)
            return .rhythmOutOfRange
        }

        // The reading comes before the stopped guard: what was asked cannot be compared with
        // what the commitment is made of until it has been read. `design.md` § *The reading
        // comes before the stopped guard*.
        let newKind: Commitment.Kind
        switch Self.changedKind(of: currentCommitment, lowest: lowest, highest: highest, target: target) {
        case .success(let kind):
            newKind = kind
        case .failure(let refusal):
            let field: SheetField = refusal == .rangeIsNotARange ? .range : .target
            refuse(.changing(commitment, refusal), on: field)
            return refusal
        }
        let sameKind = newKind == currentCommitment.kind
        let ambiguousField = Self.ambiguousField(
            askedRhythm: rhythm, askedKeptFrom: keptFrom, askedKind: newKind,
            currentRhythm: Rhythm(currentCommitment.schedule), currentKeptFrom: currentKeptFrom,
            currentKind: currentCommitment.kind)

        guard !isStopped || (sameRhythm && !keptFromChanged && sameKind) else {
            refuse(
                .changing(commitment, .stoppedCommitmentDoesNotTakeThisChange), on: ambiguousField)
            return .stoppedCommitmentDoesNotTakeThisChange
        }

        let normalizedCategory = Self.normalizedCategory(category)
        let putsNewEra = !sameRhythm || !sameKind

        guard nameChanged || keptFromChanged || putsNewEra || normalizedCategory != entry.category
        else {
            // The five things name what is already there, and the category it is already
            // under: change nothing, write nothing, refuse nothing.
            return nil
        }

        var nextRoster = rosterStore.roster

        if nameChanged {
            guard nextRoster.rename(commitment, to: name) else {
                let refusal = Refusal.nameAlreadyInUse(
                    Self.nameAlreadyHeld(name, among: kept + stopped))
                refuse(.changing(commitment, refusal), on: .name)
                return refusal
            }
        }

        if keptFromChanged {
            nextRoster = Self.movingDayKeptFrom(commitment.identity, to: keptFrom, in: nextRoster)
        }

        if putsNewEra {
            let onValue = nameChanged ? Commitment(renaming: commitment, to: name) : commitment
            let eraSchedule = rhythm.schedule(keptFrom: dayToKeepFrom)!
            let era = Commitment(era: onValue, schedule: eraSchedule, keptFrom: dayToKeepFrom, kind: newKind)!
            guard
                nextRoster.put(
                    era: era, on: onValue, keptUntil: Self.dayBefore(dayToKeepFrom), under: category)
            else {
                refuse(.changing(commitment, .notKept), on: nil)
                return .notKept
            }
        } else if let index = nextRoster.entries.firstIndex(where: {
            $0.commitment.identity == commitment.identity
        }) {
            // A different category, and none of the three acts runs to carry it: put where none
            // does. `design.md`: "A different category SHALL be written by whichever act runs,
            // and by a put where none does." Written by hand, rather than through
            // `Roster.put(_:under:)`, because that member requires the roster to be currently
            // keeping the commitment, which a stopped one — name and category the only things it
            // can change — is not.
            let existing = nextRoster.entries[index]
            nextRoster.entries[index] = Roster.Entry(
                commitment: existing.commitment, keptUntil: existing.keptUntil,
                isRemoved: existing.isRemoved, category: normalizedCategory)
        }

        if let recordStore,
            let refusal = Self.refusalLeavingARecordedDayNotDue(
                for: commitment, in: nextRoster, history: recordStore.history)
        {
            refuse(.changing(commitment, refusal), on: ambiguousField)
            return refusal
        }

        do {
            _ = try rosterStore.replace(with: nextRoster)
        } catch {
            refuse(.changing(commitment, .notKept), on: nil)
            return .notKept
        }

        endedByAChangeOrByBeingShown()
        sheetRefusal = nil
        refreshLists(from: rosterStore)
        copyPlace?.keptAChange()
        return nil
    }

    /// Restarts `commitment`'s count from `day`: puts a new era on it as of the day before `day`
    /// — an era alike in name, interval and kind whose schedule starts on `day` and which is kept
    /// from `day` — under the category `commitment` is under. Moves no record and writes nothing
    /// at the record place: every record already made stays a record of that commitment, on the
    /// day it was made for, whichever era now holds that day. See `openspec/changes/
    /// give-a-commitment-an-identity/specs/commitment/spec.md` §§ *A commitments screen restarts
    /// an interval commitment it keeps by putting a new era on it* and *A commitments screen
    /// refuses a restart it cannot make, and tells each refusal apart*.
    ///
    /// Does nothing and says nothing when `commitment` cannot be restarted: not on `kept`, or not
    /// on an interval schedule. Otherwise refuses, in order: a day later than `dayToKeepFrom`; a
    /// day earlier than `commitment`'s own `keptFrom`; a day `commitment` is already due on; a
    /// day already recorded on that the restart would leave not due; and a place that could not
    /// be written.
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

        let currentKeptFrom = rosterStore.roster.keptFrom(of: commitment) ?? commitment.keptFrom

        guard day.days(until: dayToKeepFrom) >= 0 else {
            refuse(.restarting(commitment, .restartDayIsAfterToday), on: .restartDay)
            return .restartDayIsAfterToday
        }

        guard currentKeptFrom.days(until: day) >= 0 else {
            refuse(.restarting(commitment, .restartDayIsBeforeKeptFrom), on: .restartDay)
            return .restartDayIsBeforeKeptFrom
        }

        guard !commitment.isDue(on: day) else {
            refuse(.restarting(commitment, .alreadyDueOnRestartDay), on: .restartDay)
            return .alreadyDueOnRestartDay
        }

        let restartedSchedule = Schedule.everyNDays(interval, from: day)
        let restarted = Commitment(
            era: commitment, schedule: restartedSchedule, keptFrom: day, kind: commitment.kind)!

        var nextRoster = rosterStore.roster
        if currentKeptFrom == day {
            // Restarting exactly on the day the commitment is already kept from leaves no era
            // behind it: the one it would otherwise give way to would be kept from that same day
            // and hold no day at all, which two eras of one identity may never both say
            // (`RosterDocument.formRoster()`'s own guard against one identity kept from one day
            // twice). The restarted era simply replaces the one already there.
            guard nextRoster.change(commitment, to: restarted, under: entry.category) else {
                refuse(.restarting(commitment, .notKept), on: nil)
                return .notKept
            }
        } else {
            guard
                nextRoster.put(
                    era: restarted, on: commitment, keptUntil: Self.dayBefore(day),
                    under: entry.category)
            else {
                refuse(.restarting(commitment, .notKept), on: nil)
                return .notKept
            }
        }

        if let recordStore,
            let refusal = Self.refusalLeavingARecordedDayNotDue(
                for: commitment, in: nextRoster, history: recordStore.history)
        {
            refuse(.restarting(commitment, refusal), on: .restartDay)
            return refusal
        }

        do {
            _ = try rosterStore.replace(with: nextRoster)
        } catch {
            refuse(.restarting(commitment, .notKept), on: nil)
            return .notKept
        }

        endedByAChangeOrByBeingShown()
        sheetRefusal = nil
        refreshLists(from: rosterStore)
        copyPlace?.keptAChange()
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

        endedByAChangeOrByBeingShown()
        refreshLists(from: rosterStore)
        copyPlace?.keptAChange()
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

        endedByAChangeOrByBeingShown()
        refreshLists(from: rosterStore)
        copyPlace?.keptAChange()
        return nil
    }

    /// Takes `commitment` up again, in the place it has. Answers `nil` and does
    /// nothing when `stopped` does not hold it.
    @discardableResult public func keepAgain(_ commitment: Commitment) -> Refusal? {
        guard stopped.contains(commitment) else {
            return nil
        }
        guard let rosterStore else {
            stoppedRefusal = SheetRefusal(field: nil, refusal: .notKept)
            refusedChange = .keepingAgain(commitment, .notKept)
            return .notKept
        }

        do {
            guard try rosterStore.add(commitment) else {
                let refusal = Refusal.nameAlreadyInUse(Self.nameAlreadyHeld(commitment.name, among: kept))
                stoppedRefusal = SheetRefusal(field: nil, refusal: refusal)
                refusedChange = .keepingAgain(commitment, refusal)
                return refusal
            }
        } catch {
            stoppedRefusal = SheetRefusal(field: nil, refusal: .notKept)
            refusedChange = .keepingAgain(commitment, .notKept)
            return .notKept
        }

        endedByAChangeOrByBeingShown()
        refreshLists(from: rosterStore)
        copyPlace?.keptAChange()
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
            endedByAChangeOrByBeingShown()
            copyPlace?.keptAChange()
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
            endedByAChangeOrByBeingShown()
            copyPlace?.keptAChange()
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

    /// Writes `copy` into `directory` under the name `Self.fileName(for:)` gives, creating the
    /// directory first where it does not yet exist, and answers where it was written. Replaces a
    /// file of the same name already there — the same minute's copy, asked for twice. Throws
    /// where the directory could not be created or the file could not be written. Calls
    /// `CopyPlace.write(_:into:named:)`, the one write path this screen and the copy place both
    /// use — `proposal.md`'s own "the copy forming shared out of the commitments screen".
    private static func writeCopy(_ copy: Copy, into directory: URL) throws -> URL {
        try CopyPlace.write(copy, into: directory, named: Self.fileName(for: copy.moment))
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
        let formed = CopyPlace.form(
            recordAt: recordPlace, rosterAt: place, oneOffsAt: oneOffPlace, asOf: moment)
        switch formed.result {
        case .failure(let refusal):
            refusedChange = .makingACopy(formed.notRead.first?.store, refusal)
            return .failure(refusal)
        case .success(let copy):
            do {
                let url = try Self.writeCopy(copy, into: directory)
                return .success(url)
            } catch {
                refusedChange = .makingACopy(nil, .notKept)
                return .failure(.notKept)
            }
        }
    }

    /// The place a save in progress and a restore in progress each stand at, beside the record
    /// place — the two files a take-out hands out beside the three stores where they stand.
    private static func saveInProgressPlace(besideRecordAt recordPlace: URL) -> URL {
        SaveInProgress.place(besideRecordAt: recordPlace)
    }

    private static func restoreInProgressPlace(besideRecordAt recordPlace: URL) -> URL {
        RestoreInProgress.place(besideRecordAt: recordPlace)
    }

    /// One file a take-out reaches for: where it lies today, and which store it is named as on a
    /// refusal — a save in progress and a restore in progress are each named as the record, the
    /// place they stand beside. `design.md` § *A refused take-out reuses the refused change, with
    /// a case of its own*.
    private struct TakeOutCandidate {
        let source: URL
        let namedAs: Copy.Store?
    }

    /// The five files a take-out reaches for, in the fixed order this screen answers a take-out in:
    /// the record, the roster, the one-offs, a save in progress and a restore in progress, the last
    /// two each named as the record. `openspec/specs/restore/spec.md` § *A take-out is the files at
    /// the three places exactly as they lie*.
    private var takeOutCandidates: [TakeOutCandidate] {
        [
            TakeOutCandidate(source: recordPlace, namedAs: .record),
            TakeOutCandidate(source: place, namedAs: .roster),
            TakeOutCandidate(source: oneOffPlace, namedAs: .oneOffs),
            TakeOutCandidate(
                source: Self.saveInProgressPlace(besideRecordAt: recordPlace), namedAs: .record),
            TakeOutCandidate(
                source: Self.restoreInProgressPlace(besideRecordAt: recordPlace), namedAs: .record),
        ]
    }

    /// Hands out the file standing at the record place, the roster place, the one-off place, and a
    /// save in progress and a restore in progress still standing beside them, each byte-for-byte
    /// under the name it lies under, into a fresh directory of its own under `directory` — never
    /// the same one twice, so a take-out asked for twice never collides. Reads no store as a value
    /// and undoes no save in progress and no restore in progress: every file is copied exactly as
    /// it lies. `design.md` § *The take-out copies bytes into a directory of its own, and never
    /// reads a store*.
    ///
    /// Answers no place and writes nothing, without refusing, where this screen offers no
    /// take-out. Where a file that stands cannot be handed over as it lies, or the directory it is
    /// to be written into cannot be written, hands out no file at all: the store that could not be
    /// taken out is refused as `.storeCouldNotBeRead`, naming it; the directory is refused as
    /// `.notKept`, naming none. Either way this screen holds the refusal exactly as it holds every
    /// other, and writes no file of its own where it was to write.
    public func takeOut(writingInto directory: URL = CommitmentsScreen.copyDirectory) -> Result<
        [URL], Refusal
    > {
        guard offersATakeOut else {
            return .success([])
        }

        let destination = directory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        do {
            try FileManager.default.createDirectory(
                at: destination, withIntermediateDirectories: true)
        } catch {
            // A refused take-out is not asked through the sheet — `refusedChange` alone, never
            // `refuse(_:on:)`, which would also leave `sheetRefusal` naming this refusal at the
            // foot of whatever sheet is next opened.
            refusedChange = .takingOut(nil, .notKept)
            return .failure(.notKept)
        }

        var written: [URL] = []
        for candidate in takeOutCandidates {
            guard FileManager.default.fileExists(atPath: candidate.source.path) else {
                continue
            }
            let data: Data
            do {
                data = try Data(contentsOf: candidate.source)
            } catch {
                try? FileManager.default.removeItem(at: destination)
                refusedChange = .takingOut(candidate.namedAs, .storeCouldNotBeRead)
                return .failure(.storeCouldNotBeRead)
            }
            let destinationURL = destination.appendingPathComponent(candidate.source.lastPathComponent)
            do {
                try data.write(to: destinationURL, options: .atomic)
                written.append(destinationURL)
            } catch {
                try? FileManager.default.removeItem(at: destination)
                refusedChange = .takingOut(nil, .notKept)
                return .failure(.notKept)
            }
        }

        return .success(written)
    }

    /// Counts what `roster` keeps and has stopped, and how many one-offs `oneOffs` holds —
    /// `design.md` § *What is said first, read once*: "*Kept* and *stopped* count the screen's
    /// two lists, a removed commitment in neither; *one-offs* counts all (settled 12)." A
    /// removed commitment is counted as neither kept nor stopped, matching
    /// `stopped(in:)` and `Roster.commitments` above.
    private static func counts(roster: Roster, oneOffs: OneOffs) -> Counts {
        Counts(
            kept: roster.commitments.count, stopped: Self.stopped(in: roster).count,
            oneOffs: oneOffs.entries.count)
    }

    /// Reads `file` whole and, where it reads as a copy, holds a restore awaiting confirmation
    /// that says the copy's moment and what the copy and the phone each keep, have stopped and
    /// hold as one-offs — writing nothing anywhere. A file that cannot be read this way is
    /// refused, held against restoring a copy and naming no store, and leaves no restore
    /// awaiting confirmation; it does **not** touch `refusedChange` on success, and does not
    /// touch `copyRestored` either way — neither asking nor being refused reaches a place.
    /// `openspec/changes/restore-from-a-copy/specs/restore/spec.md` §§ *A copy is read whole,
    /// and a file that cannot be restored is refused for its own reason* and *A commitments
    /// screen says what a restore takes away and brings before anything is restored*.
    @discardableResult
    public func askToRestore(from file: URL) -> Refusal? {
        pendingCopyPlaceFolder = nil

        guard let data = try? Data(contentsOf: file) else {
            awaitingRestore = nil
            pendingRestore = nil
            refusedChange = .restoring(.notACopy)
            return .notACopy
        }

        switch CopyDocument.read(data) {
        case .failure(let refusal):
            awaitingRestore = nil
            pendingRestore = nil
            refusedChange = .restoring(refusal)
            return refusal
        case .success(let copy):
            pendingRestore = copy
            awaitingRestore = formAwaitingRestore(for: copy)
            return nil
        }
    }

    /// What a restore awaiting confirmation for `copy` says: the copy's own moment and counts,
    /// and what the phone itself currently keeps, has stopped and holds as one-offs — shared by
    /// `askToRestore(from:)` and `givenAsCopyPlace`, which read a file the same way whether it was
    /// picked directly or found already standing in a folder given as the copy place.
    private func formAwaitingRestore(for copy: Copy) -> AwaitingRestore {
        let phoneRead = CopyPlace.readStores(
            recordAt: recordPlace, rosterAt: place, oneOffsAt: oneOffPlace)
        let phoneCounts = Counts(
            kept: phoneRead.roster.map { $0.roster.commitments.count },
            stopped: phoneRead.roster.map { Self.stopped(in: $0.roster).count },
            oneOffs: phoneRead.oneOffs.map { $0.oneOffs.entries.count })

        return AwaitingRestore(
            moment: copy.moment, copy: Self.counts(roster: copy.roster, oneOffs: copy.oneOffs),
            phone: phoneCounts, unreadable: phoneRead.unreadable)
    }

    /// Gives `folder` to this screen as its copy place — `openspec/specs/restore/spec.md` §§ *A
    /// folder given to a commitments screen becomes the copy place, and a copy is written there
    /// at once*, *A folder that already holds a copy asks to restore it before it becomes the
    /// copy place* and *A folder holding a copy that cannot be read is refused as a copy place*.
    /// Where `folder` holds no file named `DayByDay.daybyday`, it becomes the copy place at once.
    /// Where it holds one that reads as a copy, this instead holds a restore awaiting
    /// confirmation for it, exactly as one asked for from any file, and sets no copy place until
    /// that restore is confirmed or `replaceTheCopyAtTheFolderGiven` is called. Where it holds
    /// one that does not read as a copy, `folder` is refused into `refusedCopyPlace` and nothing
    /// is written. Does nothing, answering `nil`, where this screen has no copy place to give one
    /// to.
    @discardableResult
    public func givenAsCopyPlace(_ folder: URL) -> Refusal? {
        guard let copyPlace else {
            return nil
        }
        refusedCopyPlace = nil
        pendingCopyPlaceFolder = nil

        switch copyPlace.copyHeldIn(folder) {
        case nil:
            copyPlace.set(to: folder)
            return nil
        case .success(let copy):
            pendingRestore = copy
            pendingCopyPlaceFolder = folder
            awaitingRestore = formAwaitingRestore(for: copy)
            return nil
        case .failure(let refusal):
            refusedCopyPlace = refusal
            return refusal
        }
    }

    /// Replaces the copy standing at the folder `givenAsCopyPlace` most recently held a restore
    /// awaiting confirmation for with this phone's: restores nothing, leaves nothing awaiting a
    /// restore, and makes that folder the copy place, as any folder given becomes one.
    /// `openspec/specs/restore/spec.md` § *A folder that already holds a copy asks to restore it
    /// before it becomes the copy place*. Does nothing where nothing is awaiting a restore from a
    /// folder given as the copy place.
    public func replaceTheCopyAtTheFolderGiven() {
        guard let copyPlace, let folder = pendingCopyPlaceFolder else {
            return
        }
        awaitingRestore = nil
        pendingRestore = nil
        pendingCopyPlaceFolder = nil
        copyPlace.set(to: folder)
    }

    /// Forgets this screen's copy place. Does nothing where this screen has none.
    /// `openspec/specs/restore/spec.md` § *A commitments screen forgets its copy place*.
    public func forgetTheCopyPlace() {
        copyPlace?.forget()
    }

    /// Leaves nothing awaiting a restore and changes nothing else — the picked file and the
    /// three places are left exactly as they were, and whatever `refusedChange` held stands. A
    /// restore awaiting confirmation from a folder given as the copy place sets no copy place —
    /// `openspec/specs/restore/spec.md` § *A folder given as the copy place whose restore is
    /// cancelled becomes no copy place and is left as it was*.
    public func cancelRestoring() {
        awaitingRestore = nil
        pendingRestore = nil
        pendingCopyPlaceFolder = nil
    }

    /// Writes the copy `askToRestore` read at the record, the roster and the one-off places,
    /// each in the form that store writes now, whole or nothing — `openspec/changes
    /// /restore-from-a-copy/design.md` § *Whole or nothing, across a stop* (ADR-1056). Answers
    /// `nil` and does nothing when nothing is awaiting confirmation. On success, reads the three
    /// places back exactly as they are read when the app is shown, holds no restore, commitment
    /// or removal awaiting confirmation and no name typed back, holds the copy's moment until the
    /// app is shown again or a change is kept, and marks that this screen has restored a copy.
    /// On failure, the three places are exactly as they were, this screen's lists are left
    /// untouched, `refusedChange` names the failure, and `copyRestored` is cleared — a copy
    /// restored earlier SHALL NOT stand alongside a later restore's refusal.
    @discardableResult
    public func confirmRestoring() -> Refusal? {
        guard let copy = pendingRestore else {
            return nil
        }
        awaitingRestore = nil
        pendingRestore = nil
        let copyPlaceFolder = pendingCopyPlaceFolder
        pendingCopyPlaceFolder = nil

        do {
            try RestoreInProgress.restore(
                copy, recordAt: recordPlace, rosterAt: place, oneOffsAt: oneOffPlace)
        } catch {
            refusedChange = .restoring(.notKept)
            copyRestored = nil
            return .notKept
        }

        let opened = Self.readPlaces(place: place, recordPlace: recordPlace, oneOffPlace: oneOffPlace)
        rosterStore = opened.rosterStore
        rosterState = opened.rosterState
        recordStore = opened.recordStore
        recordsBelongToNoCommitment = opened.recordsBelongToNoCommitment
        storesNotRead = opened.storesNotRead
        refreshLists(from: opened.rosterStore)

        refusedChange = nil
        awaitingConfirmation = nil
        awaitingRemoval = nil
        nameTypedBack = ""
        copyRestored = copy.moment
        hasRestoredACopy = true

        // A restore confirmed from a folder given as the copy place makes that folder the copy
        // place, which writes the one copy this change owes on its own — `keptAChange()` would
        // write a second, redundant copy at whatever place already stood. Every other confirmed
        // restore, from a plain file or from the copy place already set, writes through
        // `keptAChange()` as any other kept change does.
        // `openspec/specs/restore/spec.md` §§ *A folder that already holds a copy asks to restore
        // it before it becomes the copy place* and *A copy is written at the copy place after
        // every change a person keeps*.
        if let copyPlaceFolder {
            copyPlace?.set(to: copyPlaceFolder)
        } else {
            copyPlace?.keptAChange()
        }

        return nil
    }

    /// The look-back at `commitment` — one commitment seen on its own, over everything since the
    /// day it is kept from. `nil` where `commitment` is on neither this screen's kept list nor its
    /// stopped list, or where this screen cannot read its roster or its record.
    /// `openspec/changes/look-back-at-a-tick/design.md` § *The screen answers it, rather than a
    /// second screen opening the same places*.
    public func lookBack(at commitment: Commitment) -> LookBack? {
        guard let rosterStore, let recordStore,
            let entry = rosterStore.roster.entries.first(where: { $0.commitment == commitment }),
            !entry.isRemoved
        else {
            return nil
        }

        return LookBack.form(
            for: commitment, keptUntil: entry.keptUntil, entries: rosterStore.roster.entries,
            today: dayToKeepFrom, history: recordStore.history)
    }

    /// The app has been shown on `today`: the day this screen holds is replaced and the roster is
    /// read again.
    public func shown(asOf today: CalendarDate) {
        dayToKeepFrom = today
        endedByAChangeOrByBeingShown()
        sheetRefusal = nil
        awaitingRemoval = nil
        nameTypedBack = ""
        refusedCopyPlace = nil

        let opened = Self.readPlaces(place: place, recordPlace: recordPlace, oneOffPlace: oneOffPlace)
        rosterStore = opened.rosterStore
        rosterState = opened.rosterState
        recordStore = opened.recordStore
        recordsBelongToNoCommitment = opened.recordsBelongToNoCommitment
        storesNotRead = opened.storesNotRead
        refreshLists(from: opened.rosterStore)
    }
}
