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

@MainActor
@Test("a Birthdays screen takes a new today only when it is shown again")
func aBirthdaysScreenTakesANewTodayOnlyWhenItIsShownAgain() async {
    let fake = FakeCalendar(handing: [
        birthday("anna", "Anna Haro's Birthday", date(2026, 10, 12)),
        birthday("john", "John Appleseed's 40th Birthday", date(2026, 10, 13)),
    ])
    let screen = BirthdaysScreen(
        asOf: date(2026, 10, 12), readingBirthdaysFrom: calendar(fake), whileOn: await onSwitch())

    #expect(
        screen.lines == [
            .init(words: "Anna Haro's Birthday", dayInWords: "Today"),
            .init(words: "John Appleseed's 40th Birthday", dayInWords: "Tue 13 October"),
        ])

    screen.shown(asOf: date(2026, 10, 13))
    #expect(fake.asks.count == 2)
    #expect(fake.asks[0].first == date(2026, 10, 12) && fake.asks[0].last == date(2027, 10, 11))
    #expect(fake.asks[1].first == date(2026, 10, 13) && fake.asks[1].last == date(2027, 10, 12))
    #expect(screen.lines == [.init(words: "John Appleseed's 40th Birthday", dayInWords: "Today")])
}

@MainActor
@Test("a Birthdays screen lists the soonest birthday first, whatever order the calendar hands them in")
func aBirthdaysScreenListsTheSoonestBirthdayFirstWhateverOrderTheCalendarHandsThemIn() async {
    let handed = [
        birthday("john", "John Appleseed's 40th Birthday", date(2027, 3, 1)),
        birthday("zoe", "Zoe Adams's Birthday", date(2027, 1, 1)),
        birthday("kate", "Kate Bell's 48th Birthday", date(2026, 11, 14)),
        birthday("anna", "Anna Haro's Birthday", date(2026, 10, 12)),
    ]
    let expected = [
        "Anna Haro's Birthday", "Kate Bell's 48th Birthday", "Zoe Adams's Birthday",
        "John Appleseed's 40th Birthday",
    ]
    let forward = BirthdaysScreen(
        asOf: date(2026, 10, 12), readingBirthdaysFrom: calendar(FakeCalendar(handing: handed)),
        whileOn: await onSwitch())
    #expect(forward.lines.map(\.words) == expected)

    let reverse = BirthdaysScreen(
        asOf: date(2026, 10, 12),
        readingBirthdaysFrom: calendar(FakeCalendar(handing: handed.reversed())),
        whileOn: await onSwitch())
    #expect(reverse.lines.map(\.words) == expected)
}

@MainActor
@Test("a Birthdays screen lists one day's birthdays in the order their words are collated in")
func aBirthdaysScreenListsOneDaysBirthdaysInTheOrderTheirWordsAreCollatedIn() async {
    let handed = [
        birthday("aaron", "Aaron Appleseed's Birthday", date(2026, 11, 15)),
        birthday("zoe", "Zoe Adams's Birthday", date(2026, 11, 14)),
        birthday("kate", "Kate Bell's 48th Birthday", date(2026, 11, 14)),
        birthday("anna", "anna Haro's Birthday", date(2026, 11, 14)),
    ]
    let alphabetical = BirthdaysScreen(
        asOf: date(2026, 10, 12),
        readingBirthdaysFrom: calendar(
            FakeCalendar(handing: handed), collatingWith: { $0.lowercased() < $1.lowercased() }),
        whileOn: await onSwitch())
    #expect(
        alphabetical.lines.map(\.words) == [
            "anna Haro's Birthday", "Kate Bell's 48th Birthday", "Zoe Adams's Birthday",
            "Aaron Appleseed's Birthday",
        ])

    let reversed = BirthdaysScreen(
        asOf: date(2026, 10, 12),
        readingBirthdaysFrom: calendar(
            FakeCalendar(handing: handed), collatingWith: { $0.lowercased() > $1.lowercased() }),
        whileOn: await onSwitch())
    #expect(
        reversed.lines.map(\.words) == [
            "Zoe Adams's Birthday", "Kate Bell's 48th Birthday", "anna Haro's Birthday",
            "Aaron Appleseed's Birthday",
        ])
}

@MainActor
@Test(
    "a Birthdays screen line says the calendar's words exactly, and its day as weekday, day and month"
)
func aBirthdaysScreenLineSaysTheCalendarsWordsExactlyAndItsDayAsWeekdayDayAndMonth() async {
    func line(_ words: String, on day: CalendarDate) async -> [BirthdaysScreen.Line] {
        BirthdaysScreen(
            asOf: date(2026, 10, 12),
            readingBirthdaysFrom: calendar(
                FakeCalendar(handing: [birthday("kate", words, day)])),
            whileOn: await onSwitch()
        ).lines
    }

    #expect(
        await line("Kate Bell's 48th Birthday", on: date(2026, 11, 14)) == [
            .init(words: "Kate Bell's 48th Birthday", dayInWords: "Sat 14 November")
        ])
    #expect(
        await line("John Appleseed's 40th Birthday", on: date(2027, 6, 5)) == [
            .init(words: "John Appleseed's 40th Birthday", dayInWords: "Sat 5 June")
        ])
    #expect(
        await line(" Kate Bell's 48th Birthday ", on: date(2026, 11, 14)) == [
            .init(words: " Kate Bell's 48th Birthday ", dayInWords: "Sat 14 November")
        ])
    #expect(
        await line("", on: date(2026, 11, 14)) == [.init(words: "", dayInWords: "Sat 14 November")])
}

@MainActor
@Test(
    "a Birthdays screen line says Today for a birthday falling on its today, and the date for any other"
)
func aBirthdaysScreenLineSaysTodayForABirthdayFallingOnItsTodayAndTheDateForAnyOther() async {
    let screen = BirthdaysScreen(
        asOf: date(2026, 10, 12),
        readingBirthdaysFrom: calendar(
            FakeCalendar(handing: [
                birthday("anna", "Anna Haro's Birthday", date(2026, 10, 12)),
                birthday("john", "John Appleseed's 40th Birthday", date(2026, 10, 13)),
                birthday("kate", "Kate Bell's 48th Birthday", date(2027, 10, 11)),
            ])),
        whileOn: await onSwitch())
    #expect(screen.lines.map(\.dayInWords) == ["Today", "Tue 13 October", "Mon 11 October"])
}

@MainActor
@Test("a Birthdays screen says each month by its own name")
func aBirthdaysScreenSaysEachMonthByItsOwnName() async {
    let firsts = [
        date(2026, 11, 1), date(2026, 12, 1), date(2027, 1, 1), date(2027, 2, 1),
        date(2027, 3, 1), date(2027, 4, 1), date(2027, 5, 1), date(2027, 6, 1),
        date(2027, 7, 1), date(2027, 8, 1), date(2027, 9, 1), date(2027, 10, 1),
    ]
    let screen = BirthdaysScreen(
        asOf: date(2026, 10, 12),
        readingBirthdaysFrom: calendar(
            FakeCalendar(
                handing: firsts.enumerated().map { birthday("contact-\($0.offset)", "Words", $0.element) })),
        whileOn: await onSwitch())
    #expect(
        screen.lines.map(\.dayInWords) == [
            "Sun 1 November", "Tue 1 December", "Fri 1 January", "Mon 1 February", "Mon 1 March",
            "Thu 1 April", "Sat 1 May", "Tue 1 June", "Thu 1 July", "Sun 1 August",
            "Wed 1 September", "Fri 1 October",
        ])
}

@MainActor
@Test(
    "a Birthdays screen opened with birthdays off lists nothing, says they are off and asks the calendar nothing"
)
func aBirthdaysScreenOpenedWithBirthdaysOffListsNothingSaysTheyAreOffAndAsksTheCalendarNothing()
{
    let phone = FakePhone(access: .full)
    let fake = FakeCalendar(handing: [birthday("kate", "Kate Bell's 48th Birthday", date(2026, 11, 14))])
    let screen = BirthdaysScreen(
        asOf: date(2026, 10, 12), readingBirthdaysFrom: calendar(fake),
        whileOn: birthdaySwitch(on: phone))
    let readsBefore = phone.asks

    #expect(screen.lines.isEmpty)
    #expect(screen.birthdayState == .off)
    #expect(fake.asks.isEmpty)
    #expect(phone.asks == readsBefore && phone.prompts == 0)

    screen.shown(asOf: date(2026, 10, 12))
    #expect(screen.lines.isEmpty)
    #expect(screen.birthdayState == .off)
    #expect(fake.asks.isEmpty)
}

@MainActor
@Test(
    "a Birthdays screen shown again after the phone withdraws calendar access lists nothing and says birthdays are off"
)
func aBirthdaysScreenShownAgainAfterThePhoneWithdrawsCalendarAccessListsNothingAndSaysBirthdaysAreOff()
    async
{
    let phone = FakePhone(access: .full)
    let switchUnderTest = await onSwitch(on: phone)
    let fake = FakeCalendar(handing: [birthday("kate", "Kate Bell's 48th Birthday", date(2026, 11, 14))])
    let screen = BirthdaysScreen(
        asOf: date(2026, 10, 12), readingBirthdaysFrom: calendar(fake), whileOn: switchUnderTest)
    #expect(screen.lines.count == 1)

    phone.access = .denied
    screen.shown(asOf: date(2026, 10, 12))
    #expect(screen.lines.isEmpty)
    #expect(screen.birthdayState == .off)
    #expect(!switchUnderTest.isOn)
    #expect(fake.asks.count == 1)

    let otherSwitch = await onSwitch()
    let other = BirthdaysScreen(
        asOf: date(2026, 10, 12), readingBirthdaysFrom: calendar(FakeCalendar(handing: [
            birthday("kate", "Kate Bell's 48th Birthday", date(2026, 11, 14))])),
        whileOn: otherSwitch)
    otherSwitch.turnOff()
    other.shown(asOf: date(2026, 10, 12))
    #expect(other.lines.isEmpty)
    #expect(other.birthdayState == .off)
}

@MainActor
@Test(
    "a Birthdays screen with birthdays on and nobody handed in its span lists nothing and says birthdays are on"
)
func aBirthdaysScreenWithBirthdaysOnAndNobodyHandedInItsSpanListsNothingAndSaysBirthdaysAreOn()
    async
{
    let empty = BirthdaysScreen(
        asOf: date(2026, 10, 12), readingBirthdaysFrom: calendar(FakeCalendar()),
        whileOn: await onSwitch())
    #expect(empty.lines.isEmpty)
    #expect(empty.birthdayState == .on)

    let outside = BirthdaysScreen(
        asOf: date(2026, 10, 12),
        readingBirthdaysFrom: calendar(
            FakeCalendar(handing: [birthday("kate", "Kate Bell's 48th Birthday", date(2027, 10, 12))])),
        whileOn: await onSwitch())
    #expect(outside.lines.isEmpty)
    #expect(outside.birthdayState == .on)
}

@MainActor
@Test(
    "a Birthdays screen whose calendar cannot be read lists nothing and says birthdays could not be read"
)
func aBirthdaysScreenWhoseCalendarCannotBeReadListsNothingAndSaysBirthdaysCouldNotBeRead() async {
    let fake = FakeCalendar(shouldThrow: true)
    let screen = BirthdaysScreen(
        asOf: date(2026, 10, 12), readingBirthdaysFrom: calendar(fake), whileOn: await onSwitch())
    #expect(screen.lines.isEmpty)
    #expect(screen.birthdayState == .calendarUnreadable)

    fake.shouldThrow = false
    fake.handed = [birthday("kate", "Kate Bell's 48th Birthday", date(2026, 11, 14))]
    screen.shown(asOf: date(2026, 10, 12))
    #expect(
        screen.lines == [.init(words: "Kate Bell's 48th Birthday", dayInWords: "Sat 14 November")])
    #expect(screen.birthdayState == .on)
}
