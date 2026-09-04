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
        self.kept = opened.store?.roster.commitments ?? []
        self.stopped = opened.store.map { Self.stopped(in: $0.roster) } ?? []
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

    /// The commitments `roster` has stopped keeping, in the order they were taken on.
    private static func stopped(in roster: Roster) -> [Commitment] {
        roster.entries.compactMap { $0.keptUntil == nil ? nil : $0.commitment }
    }

    /// The commitments the roster is keeping, in the order they were taken on.
    public private(set) var kept: [Commitment] = []

    /// The commitments the roster has stopped keeping, in the order they were taken on.
    public private(set) var stopped: [Commitment] = []

    /// Anything but `.kept` means both lists are empty and nothing is taken on.
    public private(set) var rosterState: RosterState = .notKept

    /// The day to offer as the day a commitment is kept from: the day this screen was handed.
    public private(set) var dayToKeepFrom: CalendarDate

    /// The commitment a stop has been asked for and not yet confirmed or cancelled.
    public private(set) var awaitingConfirmation: Commitment?

    /// Why a change was refused. `nil` from any of the four below means it was kept at the place
    /// before that call returned.
    public enum Refusal: Equatable, Sendable {
        /// A name that is empty or made only of blank space.
        case namesNothing
        /// A weekday set with no days in it — the one refusal the rule engine does not make.
        case dueOnNoDay
        /// The roster is already keeping this commitment.
        case alreadyKept
        /// The roster could not be written, or this screen is not keeping one.
        case notKept
    }

    /// Forms a commitment from `name`, the schedule `rhythm` names when kept from `keptFrom`, and
    /// `keptFrom`, and takes it on. Takes a commitment the roster has stopped up again.
    public func define(name: String, on rhythm: Rhythm, keptFrom: CalendarDate) -> Refusal? {
        let schedule = rhythm.schedule(keptFrom: keptFrom)

        guard let commitment = Commitment(name: name, schedule: schedule, keptFrom: keptFrom) else {
            return .namesNothing
        }

        guard let rosterStore else {
            return .notKept
        }

        do {
            guard try rosterStore.add(commitment) else {
                return .alreadyKept
            }
        } catch {
            return .notKept
        }

        kept = rosterStore.roster.commitments
        stopped = Self.stopped(in: rosterStore.roster)
        return nil
    }

    /// Puts `commitment` up for confirmation, replacing whatever was there. Does nothing when
    /// `kept` does not hold it.
    public func askToStopKeeping(_ commitment: Commitment) {
        guard kept.contains(commitment) else {
            return
        }
        awaitingConfirmation = commitment
    }

    /// Leaves nothing awaiting confirmation and changes nothing else.
    public func cancelStopKeeping() {
        awaitingConfirmation = nil
    }

    /// Stops keeping whatever is awaiting confirmation, as of the day this screen holds. Answers
    /// `nil` and does nothing when nothing is awaiting confirmation.
    @discardableResult public func confirmStopKeeping() -> Refusal? {
        guard let commitment = awaitingConfirmation else {
            return nil
        }
        awaitingConfirmation = nil

        guard let rosterStore else {
            return .notKept
        }

        do {
            try rosterStore.retire(commitment, keptUntil: dayToKeepFrom)
        } catch {
            return .notKept
        }

        kept = rosterStore.roster.commitments
        stopped = Self.stopped(in: rosterStore.roster)
        return nil
    }

    /// Takes `commitment` up again, in the place it was taken on in. Answers `nil` and does
    /// nothing when `stopped` does not hold it.
    @discardableResult public func keepAgain(_ commitment: Commitment) -> Refusal? {
        fatalError("not implemented")
    }

    /// The app has been shown on `today`: the day this screen holds is replaced and the roster is
    /// read again.
    public func shown(asOf today: CalendarDate) {
        fatalError("not implemented")
    }
}
