public struct Birthday: Hashable, Sendable {
    public let contact: String
    public let words: String
    public let day: CalendarDate

    public init?(contact: String, words: String, day: CalendarDate) {
        guard !Blank.saysNothing(contact) else {
            return nil
        }

        self.contact = contact
        self.words = words
        self.day = day
    }

    public static func falling(on day: CalendarDate, among handed: [Birthday]) -> [Birthday] {
        handed.filter { $0.day == day }
    }
}
