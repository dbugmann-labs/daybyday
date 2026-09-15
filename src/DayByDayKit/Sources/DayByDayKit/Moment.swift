import Foundation

/// When something happened, said to the minute: a **calendar date**, an hour of that day and a
/// minute of that hour, in the reckoning of the phone it was formed on. A `Moment` is the only
/// thing in this package that knows a time of day — no store holds one and none will — and it
/// exists because a `Copy` carries one. Like `today()` at `ContentView`'s edge, a moment is read
/// from a clock outside the kit and handed in, never read inside the engine, so the rule engine
/// still speaks calendar dates alone (ADR-1004). See `CONTEXT.md` § *Moment* and
/// `openspec/changes/make-a-copy/design.md` § *The moment is formed at the edge, like `today()`*.
public struct Moment: Hashable, Sendable {
    public let day: CalendarDate
    public let hour: Int
    public let minute: Int

    /// `nil` where `hour` is not one of the twenty-four or `minute` is not one of the sixty —
    /// exactly as an impossible date forms no `CalendarDate`.
    public init?(on day: CalendarDate, hour: Int, minute: Int) {
        guard (0...23).contains(hour), (0...59).contains(minute) else {
            return nil
        }
        self.day = day
        self.hour = hour
        self.minute = minute
    }
}
