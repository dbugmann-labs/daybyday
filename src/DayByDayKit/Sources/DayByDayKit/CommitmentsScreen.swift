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

    private let place: URL
    private var rosterStore: RosterStore?

    /// Opens on `today`, reading the roster kept at `place`.
    public init(asOf today: CalendarDate, keepingRosterAt place: URL = CommitmentsScreen.rosterPlace) {
        self.place = place
        self.dayToKeepFrom = today

        let opened = Self.open(at: place)
        self.rosterStore = opened.store
        self.rosterState = opened.state
        refreshLists(from: opened.store)
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

    /// The day to offer as the day a commitment is kept from: the day this screen was handed.
    public private(set) var dayToKeepFrom: CalendarDate

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
    /// is carried on the four changes that are asked about a commitment already on a list, so that
    /// a person is told beside the row they tapped rather than in one place for all five.
    public enum RefusedChange: Equatable, Sendable {
        case defining(Refusal)
        case stopping(Commitment, Refusal)
        case keepingAgain(Commitment, Refusal)
        case removing(Commitment, Refusal)
        case moving(Commitment, Refusal)
        case categorising(Commitment, Refusal)
        case movingGroup(String, Refusal)
    }

    /// Why a change was refused. `nil` from any of the five below means it was kept at the place
    /// before that call returned.
    public enum Refusal: Equatable, Sendable {
        /// A name that is empty or made only of blank space.
        case namesNothing
        /// A weekday set with no days in it — the one refusal the rule engine does not make.
        case dueOnNoDay
        /// A day of the month, an interval or a weekly quota outside what that rhythm allows.
        /// One case for all three: the person changes the number in the field they are on.
        case rhythmOutOfRange
        /// The roster is already keeping this commitment.
        case alreadyKept
        /// The roster could not be written, or this screen is not keeping one.
        case notKept
    }

    /// Forms a commitment from `name`, the schedule `rhythm` names when kept from `keptFrom`, and
    /// `keptFrom`, and takes it on. Takes a commitment the roster has stopped up again.
    public func define(name: String, on rhythm: Rhythm, keptFrom: CalendarDate, under category: String?)
        -> Refusal?
    {
        if case .weekdays(let weekdays) = rhythm, weekdays.isEmpty {
            refusedChange = .defining(.dueOnNoDay)
            return .dueOnNoDay
        }

        guard let schedule = rhythm.schedule(keptFrom: keptFrom) else {
            refusedChange = .defining(.rhythmOutOfRange)
            return .rhythmOutOfRange
        }

        guard let commitment = Commitment(name: name, schedule: schedule, keptFrom: keptFrom) else {
            refusedChange = .defining(.namesNothing)
            return .namesNothing
        }

        guard let rosterStore else {
            refusedChange = .defining(.notKept)
            return .notKept
        }

        do {
            guard try rosterStore.add(commitment, under: category) else {
                refusedChange = .defining(.alreadyKept)
                return .alreadyKept
            }
        } catch {
            refusedChange = .defining(.notKept)
            return .notKept
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

    /// Puts `commitment`, which this screen keeps, under `category`, or under none where
    /// `category` is `nil`. Does nothing and says nothing, neither refusing nor changing
    /// anything, when `commitment` is not in what this screen keeps — the guard is
    /// `kept.contains(commitment)` alone, exactly as `move`'s is, and for the same reason: a
    /// stopped commitment is not on the list a person is filing things on.
    @discardableResult public func put(_ commitment: Commitment, under category: String?)
        -> Refusal?
    {
        guard kept.contains(commitment) else {
            return nil
        }
        guard let rosterStore else {
            refusedChange = .categorising(commitment, .notKept)
            return .notKept
        }

        let rosterBeforePut = rosterStore.roster
        do {
            try rosterStore.put(commitment, under: category)
        } catch {
            refusedChange = .categorising(commitment, .notKept)
            return .notKept
        }

        // Settled answer 13, read the same way `move` reads it: a call that reaches the place
        // with no change to make does not end a standing refused-change notice.
        if rosterStore.roster != rosterBeforePut {
            refusedChange = nil
        }
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

    /// The app has been shown on `today`: the day this screen holds is replaced and the roster is
    /// read again.
    public func shown(asOf today: CalendarDate) {
        dayToKeepFrom = today
        refusedChange = nil
        awaitingRemoval = nil
        nameTypedBack = ""

        let opened = Self.open(at: place)
        rosterStore = opened.store
        rosterState = opened.state
        refreshLists(from: opened.store)
    }
}
