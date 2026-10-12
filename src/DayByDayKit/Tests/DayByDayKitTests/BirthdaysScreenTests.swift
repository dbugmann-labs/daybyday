import Foundation
import Testing

@testable import DayByDayKit

/// A fake calendar: `handed` is what `reading` answers, `shouldThrow` makes every ask fail, and
/// `asks` records each span it was asked for. Built as `DayScreenBirthdayTests.swift` builds it.
@MainActor
private final class FakeCalendar {
    var handed: [Birthday]
    var shouldThrow: Bool

    private(set) var asks: [(first: CalendarDate, last: CalendarDate)] = []

    init(handing handed: [Birthday] = [], shouldThrow: Bool = false) {
        self.handed = handed
        self.shouldThrow = shouldThrow
    }

    func read(first: CalendarDate, last: CalendarDate) throws -> [Birthday] {
        asks.append((first, last))
        guard !shouldThrow else {
            throw Failure.cannotRead
        }
        return handed
    }

    enum Failure: Error, Equatable {
        case cannotRead
    }
}

@MainActor
private func calendar(
    _ fake: FakeCalendar, collatingWith collate: @escaping (String, String) -> Bool = { $0 < $1 }
) -> BirthdayCalendar {
    BirthdayCalendar(
        reading: { first, last in try fake.read(first: first, last: last) }, collating: collate)
}

/// A phone whose access a test changes, and which counts how often it was asked.
@MainActor
private final class FakePhone {
    var access: CalendarAccess
    private(set) var asks = 0
    private(set) var prompts = 0
    init(access: CalendarAccess) { self.access = access }
    func read() -> CalendarAccess {
        asks += 1
        return access
    }
    func prompt() {
        prompts += 1
    }
}

private func freshSwitchPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("birthday-switch.json")
}

@MainActor
private func birthdaySwitch(on phone: FakePhone) -> BirthdaySwitch {
    BirthdaySwitch(
        at: freshSwitchPlace(), readingAccess: { phone.read() },
        askingForAccess: { phone.prompt() })
}

@MainActor
private func onSwitch(on phone: FakePhone = FakePhone(access: .full)) async -> BirthdaySwitch {
    let result = birthdaySwitch(on: phone)
    await result.turnOn()
    return result
}

@MainActor
private func offSwitch() -> BirthdaySwitch {
    birthdaySwitch(on: FakePhone(access: .notAsked))
}

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private func birthday(_ contact: String, _ words: String, _ day: CalendarDate) -> Birthday {
    Birthday(contact: contact, words: words, day: day)!
}

@MainActor
@Test(
    "a Birthdays screen asks the calendar once, for the days from its today through the day before the same date a year later"
)
func aBirthdaysScreenAsksTheCalendarOnceForTheDaysFromItsTodayThroughTheDayBeforeTheSameDateAYearLater() async {
    func asks(openedAsOf today: CalendarDate, reading: Bool = false) async -> [(
        first: CalendarDate, last: CalendarDate
    )] {
        let fake = FakeCalendar(handing: [
            birthday("kate", "Kate Bell's 48th Birthday", date(2026, 11, 14))
        ])
        let screen = BirthdaysScreen(
            asOf: today, readingBirthdaysFrom: calendar(fake), whileOn: await onSwitch())
        _ = screen.lines
        _ = screen.lines
        return fake.asks
    }

    let first = await asks(openedAsOf: date(2026, 10, 12))
    #expect(first.count == 1)
    #expect(first.first?.first == date(2026, 10, 12))
    #expect(first.first?.last == date(2027, 10, 11))

    let march = await asks(openedAsOf: date(2027, 3, 1))
    #expect(march.count == 1)
    #expect(march.first?.first == date(2027, 3, 1))
    #expect(march.first?.last == date(2028, 2, 29))

    let leapDay = await asks(openedAsOf: date(2028, 2, 29))
    #expect(leapDay.count == 1)
    #expect(leapDay.first?.first == date(2028, 2, 29))
    #expect(leapDay.first?.last == date(2029, 2, 28))

    let end = await asks(openedAsOf: date(9999, 10, 12))
    #expect(end.count == 1)
    #expect(end.first?.first == date(9999, 10, 12))
    #expect(end.first?.last == date(9999, 12, 31))
}

@MainActor
@Test(
    "a Birthdays screen lists each birthday handed in its span as often as it is handed, and none handed outside it"
)
func aBirthdaysScreenListsEachBirthdayHandedInItsSpanAsOftenAsItIsHandedAndNoneHandedOutsideIt()
    async
{
    let kate = birthday("kate", "Kate Bell's 48th Birthday", date(2026, 11, 14))
    let handed = [
        birthday("anna", "Anna Haro's Birthday", date(2026, 10, 11)),
        kate,
        birthday("john", "John Appleseed's 40th Birthday", date(2027, 10, 11)),
        birthday("zoe", "Zoe Adams's Birthday", date(2027, 10, 12)),
    ]
    func screen(handing handed: [Birthday]) async -> BirthdaysScreen {
        BirthdaysScreen(
            asOf: date(2026, 10, 12), readingBirthdaysFrom: calendar(FakeCalendar(handing: handed)),
            whileOn: await onSwitch())
    }

    let once = await screen(handing: handed)
    #expect(once.lines.map(\.words) == ["Kate Bell's 48th Birthday", "John Appleseed's 40th Birthday"])

    let twice = await screen(handing: handed + [kate])
    #expect(twice.lines.count == 3)
    let kates = twice.lines.filter { $0.words == "Kate Bell's 48th Birthday" }
    #expect(kates.count == 2)
    #expect(kates[0] == kates[1])

    let another = await screen(
        handing: handed + [birthday("kate-2", "Kate Bell's 48th Birthday", date(2026, 11, 14))])
    #expect(another.lines.count == 3)
    #expect(Set(another.lines.filter { $0.words == "Kate Bell's 48th Birthday" }).count == 1)
}
