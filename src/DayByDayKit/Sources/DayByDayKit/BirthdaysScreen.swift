import Foundation

/// The screen that lists the birthdays the phone's calendar hands over for the coming year,
/// soonest first. See this change's `design.md` § *The seam*. It takes the calendar and the switch
/// a day screen takes and nothing else: no place, so it reads no tick and writes nothing.
@MainActor
@Observable
public final class BirthdaysScreen {
    /// One birthday as this screen says it: the calendar's words, and its day in words.
    public struct Line: Hashable, Sendable {
        public let words: String
        public let dayInWords: String
    }

    /// What this screen says about birthdays when it lists none.
    public enum BirthdayState: Equatable, Sendable {
        case off, calendarUnreadable, on
    }

    private let calendar: BirthdayCalendar
    private let birthdaySwitch: BirthdaySwitch

    public private(set) var lines: [Line] = []
    public private(set) var birthdayState: BirthdayState = .off

    public init(
        asOf today: CalendarDate, readingBirthdaysFrom calendar: BirthdayCalendar,
        whileOn birthdaySwitch: BirthdaySwitch
    ) {
        self.calendar = calendar
        self.birthdaySwitch = birthdaySwitch
        form(asOf: today)
    }

    public func shown(asOf today: CalendarDate) {
        form(asOf: today)
    }

    /// Asks the calendar once, for the days from `today` through the day before the same date a
    /// year later — through 28 February where `today` is 29 February, and through the last
    /// supported date where that day would fall past it.
    private func form(asOf today: CalendarDate) {
        let last = Self.lastDay(ofTheYearFrom: today)
        let handed = (try? calendar.reading(today, last)) ?? []
        lines = handed
            .filter { today.days(until: $0.day) >= 0 && $0.day.days(until: last) >= 0 }
            .enumerated()
            .sorted { first, second in
                let firstDay = today.days(until: first.element.day)
                let secondDay = today.days(until: second.element.day)
                if firstDay != secondDay {
                    return firstDay < secondDay
                }
                if calendar.collating(first.element.words, second.element.words) {
                    return true
                }
                if calendar.collating(second.element.words, first.element.words) {
                    return false
                }
                return first.offset < second.offset
            }
            .map(\.element)
            .map {
                Line(
                    words: $0.words,
                    dayInWords: $0.day == today ? "Today" : DayTitle.birthdayDayInWords($0.day))
            }
    }

    private static func lastDay(ofTheYearFrom today: CalendarDate) -> CalendarDate {
        let leapDay = today.month == 2 && today.day == 29
        guard
            let sameDateAYearOn = CalendarDate(
                year: today.year + 1, month: today.month, day: leapDay ? 28 : today.day)
        else {
            return CalendarDate(year: 9999, month: 12, day: 31)!
        }
        return leapDay ? sameDateAYearOn : (sameDateAYearOn.adding(days: -1) ?? sameDateAYearOn)
    }
}
