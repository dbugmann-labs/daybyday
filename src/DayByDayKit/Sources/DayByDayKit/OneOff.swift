public struct OneOff: Hashable, Sendable {
    public let name: String
    public let date: CalendarDate

    public init?(name: String, date: CalendarDate) {
        guard !Blank.saysNothing(name) else {
            return nil
        }

        self.name = name
        self.date = date
    }
}
