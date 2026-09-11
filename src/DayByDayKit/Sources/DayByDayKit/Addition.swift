import Foundation

/// An addition recorded for a total commitment on a calendar date it is due on. See
/// `openspec/specs/record/spec.md` § *An addition is of a total commitment on a calendar date it
/// is due on, and holds one amount* for the behaviour contract and this change's `design.md` for
/// why the seam is shaped this way.
public struct Addition: Hashable, Sendable {
    let commitment: Commitment
    let date: CalendarDate
    let amount: Decimal

    /// `nil` when the commitment is not due on `date`, when its kind is not a total, or when
    /// `amount` is not above zero — a value that is not a number among them.
    public init?(_ amount: Decimal, for commitment: Commitment, on date: CalendarDate) {
        guard commitment.isDue(on: date) else {
            return nil
        }

        guard case .total = commitment.kind else {
            return nil
        }

        guard amount > 0 else {
            return nil
        }

        self.commitment = commitment
        self.date = date
        self.amount = amount
    }
}
