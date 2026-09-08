/// A note recorded for a note commitment on a calendar date it is due on. See
/// `openspec/specs/record/spec.md` § *A note is of a note commitment on a calendar date it is due
/// on* for the behaviour contract and this change's `design.md` for why the seam is shaped this
/// way.
public struct Note: Hashable, Sendable {
    let commitment: Commitment
    let date: CalendarDate
    let text: String

    /// `nil` when the commitment is not due on `date`, when its kind is not a note, or when
    /// `text` says nothing — `Blank.saysNothing(_:)`.
    public init?(_ text: String, for commitment: Commitment, on date: CalendarDate) {
        fatalError("not implemented")
    }
}
