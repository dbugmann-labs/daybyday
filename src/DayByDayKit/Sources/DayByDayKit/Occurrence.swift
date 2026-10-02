/// A time of day, an hour of the twenty-four and a minute of the sixty, with no date. It exists
/// because the shell sets a time with no day in hand; a `Moment` stays a date with a time.
public struct TimeOfDay: Hashable, Comparable, Sendable {
    public let hour: Int
    public let minute: Int

    public init?(hour: Int, minute: Int) {
        guard (0...23).contains(hour), (0...59).contains(minute) else {
            return nil
        }
        self.hour = hour
        self.minute = minute
    }

    public static func < (lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
        (lhs.hour, lhs.minute) < (rhs.hour, rhs.minute)
    }
}

/// One time a happening came: the happening by identity, a day, a time of that day or none, and
/// a note or none. Alike exactly when all four are alike.
public struct Occurrence: Hashable, Sendable {
    public let happening: Happening.Identity
    public let day: CalendarDate
    public let time: TimeOfDay?
    public let note: String?

    public init(of happening: Happening, on day: CalendarDate, at time: TimeOfDay?, saying note: String?) {
        self.init(ofIdentity: happening.identity, on: day, at: time, saying: note)
    }

    init(ofIdentity happening: Happening.Identity, on day: CalendarDate, at time: TimeOfDay?, saying note: String?) {
        self.happening = happening
        self.day = day
        self.time = time
        self.note = note.flatMap { Blank.saysNothing($0) ? nil : $0 }
    }
}
