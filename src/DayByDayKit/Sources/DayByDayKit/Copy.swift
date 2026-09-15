import Foundation

/// What the record, the roster and the one-offs hold, read at the moment it is asked for — the
/// whole of a history and never part of one. See `openspec/specs/restore/spec.md` for the
/// behaviour contract and `openspec/changes/make-a-copy/design.md` § *A copy is the values, not
/// the files* for why this holds the three values the app reads rather than the three files as
/// they lie.
public struct Copy: Hashable, Sendable {
    public let moment: Moment
    public let history: History
    public let roster: Roster
    public let oneOffs: OneOffs

    public init(moment: Moment, history: History, roster: Roster, oneOffs: OneOffs) {
        self.moment = moment
        self.history = history
        self.roster = roster
        self.oneOffs = oneOffs
    }

    /// Which of the three places a copy could not be read from — named on a refused copy so a
    /// person is told which store to look at rather than merely that one could not be read.
    /// `openspec/changes/make-a-copy/design.md` § *The refusal is the screen's existing one, with
    /// one new cause*.
    public enum Store: Hashable, Sendable, CaseIterable {
        case record, roster, oneOffs
    }
}
