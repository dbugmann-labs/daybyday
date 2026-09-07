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
        fatalError("not implemented")
    }
}

/// A commitment on a day. Internal: it is how a history and a store each hold at most one number
/// per commitment per day, without either of them enforcing it.
struct RecordedDay: Hashable, Sendable {
    let commitment: Commitment
    let date: CalendarDate
}
