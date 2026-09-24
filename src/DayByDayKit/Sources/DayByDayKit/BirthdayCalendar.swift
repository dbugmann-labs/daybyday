/// The phone's birthday calendar, as a day screen reads it: a reader of a span of days, and the
/// collation to order birthdays' words by. See this change's `design.md` § *The seam* and § *The
/// calendar is handed in, and the Kit orders by the collation it is handed* for why the surface
/// is shaped this way — the Kit reads no `EventKit` and consults no locale of its own; both are
/// handed in by whatever constructs this.
public struct BirthdayCalendar {
    /// Reads the birthdays falling from `first` through `last`, both included. Throws where the
    /// calendar cannot be read. `@MainActor` because the shell's own reader, `EKEventStore`,
    /// must run there.
    let reading: @MainActor (_ first: CalendarDate, _ last: CalendarDate) throws -> [Birthday]

    /// Whether `words` is collated before `before` — the phone's own collation, asked for every
    /// pair a day screen orders two birthdays' words by. Consulted by the Kit and nowhere else;
    /// the Kit reads no locale of its own.
    let collating: (_ words: String, _ before: String) -> Bool

    public init(
        reading: @escaping @MainActor (_ first: CalendarDate, _ last: CalendarDate) throws ->
            [Birthday],
        collating: @escaping (_ words: String, _ before: String) -> Bool
    ) {
        self.reading = reading
        self.collating = collating
    }
}
