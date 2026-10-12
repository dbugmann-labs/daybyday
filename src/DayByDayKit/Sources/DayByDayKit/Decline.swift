/// A due day a person chose not to keep and said so, with a reason or none. See
/// `openspec/changes/decline-a-due-day/specs/record/spec.md` § *A decline is of a commitment on a
/// calendar date it is due on, and carries a reason or none* and ADR-1068.
public struct Decline: Hashable, Sendable {
    let commitment: Commitment
    let date: CalendarDate

    /// The reason as it was given, character for character, or `nil` where none was.
    public let reason: String?

    public init?(for commitment: Commitment, on date: CalendarDate, reason: String?) {
        guard commitment.isDue(on: date) else {
            return nil
        }

        if case .weeklyQuota = commitment.schedule {
            return nil
        }

        if let reason, Blank.saysNothing(reason) {
            return nil
        }

        self.commitment = commitment
        self.date = date
        self.reason = reason
    }
}
