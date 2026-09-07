import Foundation

/// A number recorded for a number commitment on a calendar date it is due on. See
/// `openspec/specs/record/spec.md` § *A number is of a number commitment on a calendar date it is
/// due on* for the behaviour contract and this change's `design.md` for why the seam is shaped
/// this way.
public struct Number: Hashable, Sendable {
    let commitment: Commitment
    let date: CalendarDate
    let number: Decimal

    public init?(_ number: Decimal, for commitment: Commitment, on date: CalendarDate) {
        guard commitment.isDue(on: date) else {
            return nil
        }

        guard case .number(let range) = commitment.kind else {
            return nil
        }

        guard !number.isNaN else {
            return nil
        }

        if let range {
            guard range.lowest <= number, number <= range.highest else {
                return nil
            }
        }

        self.commitment = commitment
        self.date = date
        self.number = number
    }
}

/// A commitment on a day. Internal: it is how a history and a store each hold at most one number
/// per commitment per day, without either of them enforcing it.
struct RecordedDay: Hashable, Sendable {
    let commitment: Commitment
    let date: CalendarDate
}
