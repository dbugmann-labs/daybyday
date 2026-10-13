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

/// A phone whose access a test changes. `reads` counts looks at its access, `asks` the prompts
/// shown for it, as `BirthdaySwitchTests.swift` counts them.
@MainActor
private final class FakePhone {
    var access: CalendarAccess
    private(set) var reads = 0
    private(set) var asks = 0
    init(access: CalendarAccess) { self.access = access }
    func read() -> CalendarAccess {
        reads += 1
        return access
    }
    func prompt() {
        asks += 1
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

private func freshIdeaPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("present-ideas.json")
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
    func asks(openedAsOf today: CalendarDate) async -> [(
        first: CalendarDate, last: CalendarDate
    )] {
        let fake = FakeCalendar(handing: [
            birthday("kate", "Kate Bell's 48th Birthday", date(2026, 11, 14))
        ])
        let screen = BirthdaysScreen(
            asOf: today, readingBirthdaysFrom: calendar(fake), whileOn: await onSwitch(), keepingPresentIdeasAt: freshIdeaPlace())
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
            whileOn: await onSwitch(), keepingPresentIdeasAt: freshIdeaPlace())
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
    let sameWords = another.lines.filter { $0.words == "Kate Bell's 48th Birthday" }
    #expect(sameWords.count == 2)
    #expect(sameWords[0] != sameWords[1])
}

@MainActor
@Test("a Birthdays screen takes a new today only when it is shown again")
func aBirthdaysScreenTakesANewTodayOnlyWhenItIsShownAgain() async {
    let fake = FakeCalendar(handing: [
        birthday("anna", "Anna Haro's Birthday", date(2026, 10, 12)),
        birthday("john", "John Appleseed's 40th Birthday", date(2026, 10, 13)),
    ])
    let screen = BirthdaysScreen(
        asOf: date(2026, 10, 12), readingBirthdaysFrom: calendar(fake), whileOn: await onSwitch(), keepingPresentIdeasAt: freshIdeaPlace())

    #expect(
        screen.lines == [
            .init(contact: "anna", words: "Anna Haro's Birthday", dayInWords: "Today", ideasInWords: nil),
            .init(contact: "john", words: "John Appleseed's 40th Birthday", dayInWords: "Tue 13 October", ideasInWords: nil),
        ])

    screen.shown(asOf: date(2026, 10, 13))
    #expect(fake.asks.count == 2)
    #expect(fake.asks[0].first == date(2026, 10, 12) && fake.asks[0].last == date(2027, 10, 11))
    #expect(fake.asks[1].first == date(2026, 10, 13) && fake.asks[1].last == date(2027, 10, 12))
    #expect(screen.lines == [.init(contact: "john", words: "John Appleseed's 40th Birthday", dayInWords: "Today", ideasInWords: nil)])
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
        whileOn: await onSwitch(), keepingPresentIdeasAt: freshIdeaPlace())
    #expect(forward.lines.map(\.words) == expected)

    let reverse = BirthdaysScreen(
        asOf: date(2026, 10, 12),
        readingBirthdaysFrom: calendar(FakeCalendar(handing: handed.reversed())),
        whileOn: await onSwitch(), keepingPresentIdeasAt: freshIdeaPlace())
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
        whileOn: await onSwitch(), keepingPresentIdeasAt: freshIdeaPlace())
    #expect(
        alphabetical.lines.map(\.words) == [
            "anna Haro's Birthday", "Kate Bell's 48th Birthday", "Zoe Adams's Birthday",
            "Aaron Appleseed's Birthday",
        ])

    let reversed = BirthdaysScreen(
        asOf: date(2026, 10, 12),
        readingBirthdaysFrom: calendar(
            FakeCalendar(handing: handed), collatingWith: { $0.lowercased() > $1.lowercased() }),
        whileOn: await onSwitch(), keepingPresentIdeasAt: freshIdeaPlace())
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
            whileOn: await onSwitch(), keepingPresentIdeasAt: freshIdeaPlace()
        ).lines
    }

    #expect(
        await line("Kate Bell's 48th Birthday", on: date(2026, 11, 14)) == [
            .init(contact: "kate", words: "Kate Bell's 48th Birthday", dayInWords: "Sat 14 November", ideasInWords: nil)
        ])
    #expect(
        await line("John Appleseed's 40th Birthday", on: date(2027, 6, 5)) == [
            .init(contact: "kate", words: "John Appleseed's 40th Birthday", dayInWords: "Sat 5 June", ideasInWords: nil)
        ])
    #expect(
        await line(" Kate Bell's 48th Birthday ", on: date(2026, 11, 14)) == [
            .init(contact: "kate", words: " Kate Bell's 48th Birthday ", dayInWords: "Sat 14 November", ideasInWords: nil)
        ])
    #expect(
        await line("", on: date(2026, 11, 14)) == [.init(contact: "kate", words: "", dayInWords: "Sat 14 November", ideasInWords: nil)])
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
        whileOn: await onSwitch(), keepingPresentIdeasAt: freshIdeaPlace())
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
        whileOn: await onSwitch(), keepingPresentIdeasAt: freshIdeaPlace())
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
    let switchUnderTest = birthdaySwitch(on: phone)
    let readsBefore = phone.reads
    let screen = BirthdaysScreen(
        asOf: date(2026, 10, 12), readingBirthdaysFrom: calendar(fake),
        whileOn: switchUnderTest, keepingPresentIdeasAt: freshIdeaPlace())

    #expect(screen.lines.isEmpty)
    #expect(screen.birthdayState == .off)
    #expect(fake.asks.isEmpty)
    #expect(phone.reads == readsBefore && phone.asks == 0)

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
        asOf: date(2026, 10, 12), readingBirthdaysFrom: calendar(fake), whileOn: switchUnderTest, keepingPresentIdeasAt: freshIdeaPlace())
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
        whileOn: otherSwitch, keepingPresentIdeasAt: freshIdeaPlace())
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
        whileOn: await onSwitch(), keepingPresentIdeasAt: freshIdeaPlace())
    #expect(empty.lines.isEmpty)
    #expect(empty.birthdayState == .on)

    let outside = BirthdaysScreen(
        asOf: date(2026, 10, 12),
        readingBirthdaysFrom: calendar(
            FakeCalendar(handing: [birthday("kate", "Kate Bell's 48th Birthday", date(2027, 10, 12))])),
        whileOn: await onSwitch(), keepingPresentIdeasAt: freshIdeaPlace())
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
        asOf: date(2026, 10, 12), readingBirthdaysFrom: calendar(fake), whileOn: await onSwitch(), keepingPresentIdeasAt: freshIdeaPlace())
    #expect(screen.lines.isEmpty)
    #expect(screen.birthdayState == .calendarUnreadable)

    fake.shouldThrow = false
    fake.handed = [birthday("kate", "Kate Bell's 48th Birthday", date(2026, 11, 14))]
    screen.shown(asOf: date(2026, 10, 12))
    #expect(
        screen.lines == [.init(contact: "kate", words: "Kate Bell's 48th Birthday", dayInWords: "Sat 14 November", ideasInWords: nil)])
    #expect(screen.birthdayState == .on)
}

/// A commitments screen opened as of Monday 12 October 2026 at places where nothing has been kept.
@MainActor
private func commitmentsScreen(whileOn birthdaySwitch: BirthdaySwitch?) -> CommitmentsScreen {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    return CommitmentsScreen(
        asOf: date(2026, 10, 12),
        keepingRosterAt: directory.appendingPathComponent("roster.json"),
        keepingRecordAt: directory.appendingPathComponent("record.json"),
        keepingOneOffsAt: directory.appendingPathComponent("one-offs.json"),
        whileOn: birthdaySwitch)
}

@MainActor
@Test(
    "a commitments screen offers the way to the Birthdays screen while birthdays are on, and none while they are off"
)
func aCommitmentsScreenOffersTheWayToTheBirthdaysScreenWhileBirthdaysAreOnAndNoneWhileTheyAreOff()
    async
{
    let phone = FakePhone(access: .full)
    let switchUnderTest = await onSwitch(on: phone)
    let readsBefore = phone.reads
    let screen = commitmentsScreen(whileOn: switchUnderTest)
    #expect(screen.offersGoingToBirthdays)

    switchUnderTest.turnOff()
    #expect(!screen.offersGoingToBirthdays)

    #expect(!commitmentsScreen(whileOn: nil).offersGoingToBirthdays)
    #expect(phone.reads == readsBefore && phone.asks == 0)
}

@MainActor
@Test(
    "a commitments screen shown again after the phone withdraws calendar access offers no way to the Birthdays screen"
)
func aCommitmentsScreenShownAgainAfterThePhoneWithdrawsCalendarAccessOffersNoWayToTheBirthdaysScreen()
    async
{
    let phone = FakePhone(access: .full)
    let switchUnderTest = await onSwitch(on: phone)
    let screen = commitmentsScreen(whileOn: switchUnderTest)
    #expect(screen.offersGoingToBirthdays)

    phone.access = .denied
    screen.shown(asOf: date(2026, 10, 12))
    #expect(!screen.offersGoingToBirthdays)
    #expect(!switchUnderTest.isOn)

    phone.access = .full
    screen.shown(asOf: date(2026, 10, 12))
    #expect(!screen.offersGoingToBirthdays)
}

@MainActor
@Test(
    "the present-idea place is a file of the app's own under Application Support, the same every time"
)
func thePresentIdeaPlaceIsAFileOfTheAppsOwnUnderApplicationSupportTheSameEveryTime() {
    let first = BirthdaysScreen.presentIdeaPlace
    #expect(first == BirthdaysScreen.presentIdeaPlace)

    let applicationSupport = FileManager.default.urls(
        for: .applicationSupportDirectory, in: .userDomainMask)[0]
    let directory = first.deletingLastPathComponent()
    #expect(directory != applicationSupport)
    #expect(directory.path.hasPrefix(applicationSupport.path))

    let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    #expect(!first.path.hasPrefix(caches.path))
    #expect(!first.path.hasPrefix(FileManager.default.temporaryDirectory.path))

    let others: [URL] = [
        DayScreen.recordPlace, DayScreen.rosterPlace, DayScreen.oneOffPlace,
        DayScreen.birthdayPlace, DayScreen.happeningPlace, BirthdaySwitch.place,
    ]
    #expect(!others.contains(first))
}

private func idea(_ text: String, _ link: String = "") -> PresentIdea {
    try! PresentIdea(text: text, link: link)
}

@MainActor
@Test("a Birthdays screen line says how many present ideas its contact has, and nothing for none")
func aBirthdaysScreenLineSaysHowManyPresentIdeasItsContactHasAndNothingForNone() async throws {
    let place = try ideaPlace(holding: [
        ("kate", idea("One")), ("kate", idea("Two")), ("kate", idea("Three")),
        ("john", idea("Four")),
    ])
    let kate = birthday("kate", "Kate Bell's 48th Birthday", date(2026, 11, 14))
    let screen = BirthdaysScreen(
        asOf: date(2026, 10, 13),
        readingBirthdaysFrom: calendar(
            FakeCalendar(handing: [
                birthday("anna", "Anna Haro's Birthday", date(2026, 10, 13)), kate, kate,
                birthday("john", "John Appleseed's 40th Birthday", date(2027, 6, 5)),
            ])),
        whileOn: await onSwitch(), keepingPresentIdeasAt: place)

    #expect(screen.lines.map(\.ideasInWords) == [nil, "3 ideas", "3 ideas", "1 idea"])
}

@MainActor
@Test(
    "ideas against a contact the calendar does not hand are kept, and said once it hands that contact"
)
func ideasAgainstAContactTheCalendarDoesNotHandAreKeptAndSaidOnceItHandsThatContact() async throws {
    let place = try ideaPlace(holding: [("anna", idea("One")), ("anna", idea("Two"))])
    let before = try Data(contentsOf: place)
    let fake = FakeCalendar(handing: [
        birthday("kate", "Kate Bell's 48th Birthday", date(2026, 11, 14))
    ])
    let screen = BirthdaysScreen(
        asOf: date(2026, 10, 13), readingBirthdaysFrom: calendar(fake),
        whileOn: await onSwitch(), keepingPresentIdeasAt: place)

    #expect(screen.lines.map(\.ideasInWords) == [nil])
    #expect(try Data(contentsOf: place) == before)

    fake.handed.append(birthday("anna", "Anna Haro's Birthday", date(2027, 3, 1)))
    screen.shown(asOf: date(2026, 10, 13))
    #expect(screen.lines.map(\.ideasInWords) == [nil, "2 ideas"])
    #expect(try Data(contentsOf: place) == before)

    let off = BirthdaysScreen(
        asOf: date(2026, 10, 13), readingBirthdaysFrom: calendar(fake),
        whileOn: offSwitch(), keepingPresentIdeasAt: place)
    #expect(off.lines.isEmpty)
    #expect(try Data(contentsOf: place) == before)
}

@MainActor
@Test(
    "an idea added through a Birthdays screen is kept against its line's contact, last, and its count says so at once"
)
func anIdeaAddedThroughABirthdaysScreenIsKeptAgainstItsLinesContactLastAndItsCountSaysSoAtOnce()
    async throws
{
    let place = try ideaPlace(holding: [("kate", idea("Ceramics class voucher"))])
    let fake = FakeCalendar(handing: [
        birthday("kate", "Kate Bell's 48th Birthday", date(2026, 11, 14)),
        birthday("john", "John Appleseed's 40th Birthday", date(2027, 6, 5)),
    ])
    let screen = BirthdaysScreen(
        asOf: date(2026, 10, 13), readingBirthdaysFrom: calendar(fake),
        whileOn: await onSwitch(), keepingPresentIdeasAt: place)
    let kateBefore = try #require(screen.lines.first)
    let john = try #require(screen.lines.dropFirst().first)

    #expect(screen.addIdea(text: "Hiking socks, size 38", link: "bergzeit.ch/socks", to: kateBefore) == nil)
    let kate = try #require(screen.lines.first)
    let two = [
        idea("Ceramics class voucher"), idea("Hiking socks, size 38", "https://bergzeit.ch/socks"),
    ]
    #expect(screen.ideas(of: kate) == two)
    #expect(kate.ideasInWords == "2 ideas")
    #expect(screen.ideas(of: kateBefore) == two)
    #expect(fake.asks.count == 1)

    #expect(screen.addIdea(text: "", link: "amazon.de/xyz", to: john) == nil)
    let johnAfter = try #require(screen.lines.dropFirst().first)
    #expect(johnAfter.ideasInWords == "1 idea")

    let reopened = BirthdaysScreen(
        asOf: date(2026, 10, 13), readingBirthdaysFrom: calendar(fake),
        whileOn: await onSwitch(), keepingPresentIdeasAt: place)
    #expect(reopened.lines.map { reopened.ideas(of: $0) } == [two, [idea("", "amazon.de/xyz")]])
}

private let kateBirthday = birthday("kate", "Kate Bell's 48th Birthday", date(2026, 11, 14))

@MainActor
@Test(
    "an add whose text and link both say nothing, or whose link is not a web address, is refused and writes nothing"
)
func anAddWhoseTextAndLinkBothSayNothingOrWhoseLinkIsNotAWebAddressIsRefusedAndWritesNothing()
    async throws
{
    let place = try ideaPlace(holding: [("kate", idea("Ceramics class voucher"))])
    let before = try Data(contentsOf: place)
    let screen = BirthdaysScreen(
        asOf: date(2026, 10, 13),
        readingBirthdaysFrom: calendar(FakeCalendar(handing: [kateBirthday])),
        whileOn: await onSwitch(), keepingPresentIdeasAt: place)
    let kate = try #require(screen.lines.first)

    #expect(screen.addIdea(text: "   ", link: "", to: kate) == .saysNothing)
    #expect(screen.addIdea(text: "Book voucher", link: "ask Anna", to: kate) == .linkIsNotAWebAddress)
    #expect(try Data(contentsOf: place) == before)
    let keptKate = try #require(screen.lines.first)
    #expect(keptKate.ideasInWords == "1 idea")
}

@MainActor
@Test("an idea a Birthdays screen cannot keep is refused as not kept and not held")
func anIdeaABirthdaysScreenCannotKeepIsRefusedAsNotKeptAndNotHeld() async throws {
    let blocker = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try Data("not a directory".utf8).write(to: blocker)
    let place = blocker.appendingPathComponent("present-ideas.json")
    let screen = BirthdaysScreen(
        asOf: date(2026, 10, 13),
        readingBirthdaysFrom: calendar(FakeCalendar(handing: [kateBirthday])),
        whileOn: await onSwitch(), keepingPresentIdeasAt: place)
    let kate = try #require(screen.lines.first)

    #expect(screen.addIdea(text: "Book voucher", link: "", to: kate) == .notKept)
    let heldKate = try #require(screen.lines.first)
    #expect(screen.ideas(of: heldKate).isEmpty)
    #expect(heldKate.ideasInWords == nil)

    let reopened = BirthdaysScreen(
        asOf: date(2026, 10, 13),
        readingBirthdaysFrom: calendar(FakeCalendar(handing: [kateBirthday])),
        whileOn: await onSwitch(), keepingPresentIdeasAt: place)
    let reopenedKate = try #require(reopened.lines.first)
    #expect(reopened.ideas(of: reopenedKate).isEmpty)
}

@MainActor
@Test(
    "what a Birthdays screen tells about a present idea ends when a field is edited, the sheet closes or the screen is shown again"
)
func whatABirthdaysScreenTellsAboutAPresentIdeaEndsWhenAFieldIsEditedTheSheetClosesOrTheScreenIsShownAgain()
    async throws
{
    func refusedScreen() async throws -> (BirthdaysScreen, BirthdaysScreen.Line) {
        let screen = BirthdaysScreen(
            asOf: date(2026, 10, 13),
            readingBirthdaysFrom: calendar(FakeCalendar(handing: [kateBirthday])),
            whileOn: await onSwitch(), keepingPresentIdeasAt: freshIdeaPlace())
        let kate = try #require(screen.lines.first)
        screen.addIdea(text: "", link: "", to: kate)
        return (screen, kate)
    }

    let (edited, kate) = try await refusedScreen()
    _ = edited.ideas(of: kate)
    #expect(edited.ideaRefusal == .saysNothing)
    edited.ideaFieldEdited()
    #expect(edited.ideaRefusal == nil)

    let (closed, _) = try await refusedScreen()
    closed.ideaSheetClosed()
    #expect(closed.ideaRefusal == nil)

    let (shown, _) = try await refusedScreen()
    shown.shown(asOf: date(2026, 10, 13))
    #expect(shown.ideaRefusal == nil)

    let (replaced, replacedKate) = try await refusedScreen()
    replaced.addIdea(text: "Book voucher", link: "ask Anna", to: replacedKate)
    #expect(replaced.ideaRefusal == .linkIsNotAWebAddress)
    replaced.addIdea(text: "Book voucher", link: "", to: replacedKate)
    #expect(replaced.ideaRefusal == nil)
}

@MainActor
@Test(
    "a Birthdays screen that cannot read its present-idea place lists every birthday with no count and leaves the place as it was"
)
func aBirthdaysScreenThatCannotReadItsPresentIdeaPlaceListsEveryBirthdayWithNoCountAndLeavesThePlaceAsItWas()
    async throws
{
    let place = freshIdeaPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a store".utf8).write(to: place)
    let before = try Data(contentsOf: place)
    let screen = BirthdaysScreen(
        asOf: date(2026, 10, 13),
        readingBirthdaysFrom: calendar(FakeCalendar(handing: [kateBirthday])),
        whileOn: await onSwitch(), keepingPresentIdeasAt: place)

    #expect(
        screen.lines == [
            .init(
                contact: "kate", words: "Kate Bell's 48th Birthday", dayInWords: "Sat 14 November",
                ideasInWords: nil)
        ])
    let listedKate = try #require(screen.lines.first)
    #expect(screen.ideas(of: listedKate).isEmpty)
    #expect(screen.presentIdeaState == .notKept)

    let off = BirthdaysScreen(
        asOf: date(2026, 10, 13),
        readingBirthdaysFrom: calendar(FakeCalendar(handing: [kateBirthday])),
        whileOn: offSwitch(), keepingPresentIdeasAt: place)
    #expect(off.presentIdeaState == .notKept)

    #expect(screen.addIdea(text: "Book voucher", link: "", to: listedKate) == .notKept)
    #expect(try Data(contentsOf: place) == before)
}

@MainActor
@Test("a present-idea place written by a later version makes a Birthdays screen that says so")
func aPresentIdeaPlaceWrittenByALaterVersionMakesABirthdaysScreenThatSaysSo() async throws {
    let place = freshIdeaPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(#"{"contacts":[],"version":3}"#.utf8).write(to: place)
    let before = try Data(contentsOf: place)
    let screen = BirthdaysScreen(
        asOf: date(2026, 10, 13),
        readingBirthdaysFrom: calendar(FakeCalendar(handing: [kateBirthday])),
        whileOn: await onSwitch(), keepingPresentIdeasAt: place)

    #expect(screen.lines.map(\.ideasInWords) == [nil])
    #expect(screen.presentIdeaState == .writtenByALaterVersion)
    #expect(try Data(contentsOf: place) == before)
}

@MainActor
@Test("a Birthdays screen that could not read its present-idea place reads it again when shown")
func aBirthdaysScreenThatCouldNotReadItsPresentIdeaPlaceReadsItAgainWhenShown() async throws {
    let place = freshIdeaPlace()
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a store".utf8).write(to: place)
    let screen = BirthdaysScreen(
        asOf: date(2026, 10, 13),
        readingBirthdaysFrom: calendar(FakeCalendar(handing: [kateBirthday])),
        whileOn: await onSwitch(), keepingPresentIdeasAt: place)
    #expect(screen.presentIdeaState == .notKept)

    try FileManager.default.removeItem(at: place)
    try PresentIdeaStore(at: place).add(idea("Book voucher"), to: "kate")
    screen.shown(asOf: date(2026, 10, 13))

    #expect(screen.lines.map(\.ideasInWords) == ["1 idea"])
    let keptKate = try #require(screen.lines.first)
    #expect(screen.ideas(of: keptKate) == [idea("Book voucher")])
    #expect(screen.presentIdeaState == .kept)
}

/// A present-idea place holding `ideas` against their contacts, those at the `given` offsets of
/// `ideas` marked given.
private func ideaPlace(
    holding ideas: [(contact: String, idea: PresentIdea)], given: Set<Int> = []
) throws -> URL {
    let place = freshIdeaPlace()
    let store = try PresentIdeaStore(at: place)
    var counts: [String: Int] = [:]
    for (offset, entry) in ideas.enumerated() {
        try store.add(entry.idea, to: entry.contact)
        if given.contains(offset) {
            try store.mark(counts[entry.contact, default: 0], of: entry.contact, given: true)
        }
        counts[entry.contact, default: 0] += 1
    }
    return place
}

@MainActor
private func kateScreen(
    at place: URL, calendarFake: FakeCalendar? = nil, today: CalendarDate = date(2026, 10, 13)
) async -> BirthdaysScreen {
    BirthdaysScreen(
        asOf: today,
        readingBirthdaysFrom: calendar(calendarFake ?? FakeCalendar(handing: [kateBirthday])),
        whileOn: await onSwitch(), keepingPresentIdeasAt: place)
}

@MainActor
@Test("an idea changed through a Birthdays screen is kept where it stands, its mark with it")
func anIdeaChangedThroughABirthdaysScreenIsKeptWhereItStandsItsMarkWithIt() async throws {
    let place = try ideaPlace(
        holding: [
            ("kate", idea("Book voucher")), ("kate", idea("Hiking socks")),
            ("kate", idea("Ceramics class voucher")),
        ], given: [0])
    let screen = await kateScreen(at: place)
    let kate = try #require(screen.lines.first)

    #expect(screen.changeIdea(0, of: kate, text: "Hiking socks, size 38", link: "bergzeit.ch/socks") == nil)
    let changed = screen.ideas(of: kate)
    #expect(changed.map(\.text) == ["Hiking socks, size 38", "Ceramics class voucher", "Book voucher"])
    #expect(changed[0].link == "https://bergzeit.ch/socks")
    #expect(changed.map(\.isGiven) == [false, false, true])

    #expect(screen.changeIdea(2, of: kate, text: "Book voucher, hardback", link: "") == nil)
    let again = try #require(screen.lines.first)
    #expect(screen.ideas(of: again).last?.text == "Book voucher, hardback")
    #expect(screen.ideas(of: again).last?.isGiven == true)
    #expect(again.ideasInWords == "2 ideas")

    let reopened = await kateScreen(at: place)
    let reopenedKate = try #require(reopened.lines.first)
    #expect(reopened.ideas(of: reopenedKate) == screen.ideas(of: again))
}

@MainActor
@Test(
    "a change whose text and link both say nothing, or whose link is not a web address, is refused and leaves the idea as it was"
)
func aChangeWhoseTextAndLinkBothSayNothingOrWhoseLinkIsNotAWebAddressIsRefusedAndLeavesTheIdeaAsItWas()
    async throws
{
    let place = try ideaPlace(
        holding: [("kate", idea("Ceramics class voucher", "https://amazon.de/xyz"))])
    let before = try Data(contentsOf: place)
    let screen = await kateScreen(at: place)
    let kate = try #require(screen.lines.first)

    #expect(screen.changeIdea(0, of: kate, text: "   ", link: "") == .saysNothing)
    #expect(
        screen.changeIdea(0, of: kate, text: "Ceramics class voucher", link: "ask Anna")
            == .linkIsNotAWebAddress)
    #expect(try Data(contentsOf: place) == before)
    #expect(
        screen.ideas(of: kate) == [idea("Ceramics class voucher", "https://amazon.de/xyz")])
}

@MainActor
@Test("asking to delete an idea changes nothing until it is confirmed, and a cancel changes nothing")
func askingToDeleteAnIdeaChangesNothingUntilItIsConfirmedAndACancelChangesNothing() async throws {
    let place = try ideaPlace(
        holding: [("kate", idea("Ceramics class voucher")), ("kate", idea("Book voucher"))])
    let screen = await kateScreen(at: place)
    let kate = try #require(screen.lines.first)
    let before = try Data(contentsOf: place)

    screen.askToDeleteIdea(1, of: kate)
    #expect(screen.ideaAwaitingDeletion == idea("Book voucher"))
    #expect(screen.ideas(of: kate).count == 2)
    #expect(kate.ideasInWords == "2 ideas")
    #expect(screen.lines.first?.ideasInWords == "2 ideas")

    screen.cancelDeletingIdea()
    #expect(screen.ideaAwaitingDeletion == nil)

    screen.askToDeleteIdea(1, of: kate)
    screen.shown(asOf: date(2026, 10, 13))
    #expect(screen.ideaAwaitingDeletion == nil)
    #expect(screen.confirmDeletingIdea() == nil)
    #expect(screen.ideas(of: kate).count == 2)

    screen.askToDeleteIdea(1, of: kate)
    screen.askToDeleteIdea(2, of: kate)
    #expect(screen.ideaAwaitingDeletion == nil)
    #expect(screen.confirmDeletingIdea() == nil)
    #expect(screen.ideas(of: kate).count == 2)
    #expect(try Data(contentsOf: place) == before)
}

@MainActor
@Test("a confirmed deletion removes the idea where it stood, and its line's count drops at once")
func aConfirmedDeletionRemovesTheIdeaWhereItStoodAndItsLinesCountDropsAtOnce() async throws {
    let place = try ideaPlace(
        holding: [
            ("kate", idea("Book voucher")), ("kate", idea("Ceramics class voucher")),
            ("kate", idea("Hiking socks, size 38")),
        ], given: [0])
    let fake = FakeCalendar(handing: [kateBirthday])
    let screen = await kateScreen(at: place, calendarFake: fake)
    let kate = try #require(screen.lines.first)

    screen.askToDeleteIdea(0, of: kate)
    #expect(screen.ideaAwaitingDeletion == idea("Ceramics class voucher"))
    #expect(screen.confirmDeletingIdea() == nil)
    #expect(screen.ideaAwaitingDeletion == nil)
    let after = try #require(screen.lines.first)
    #expect(screen.ideas(of: after).map(\.text) == ["Hiking socks, size 38", "Book voucher"])
    #expect(screen.ideas(of: after).map(\.isGiven) == [false, true])
    #expect(after.ideasInWords == "1 idea")
    #expect(fake.asks.count == 1)

    screen.askToDeleteIdea(1, of: after)
    #expect(screen.confirmDeletingIdea() == nil)
    let last = try #require(screen.lines.first)
    #expect(screen.ideas(of: last).map(\.text) == ["Hiking socks, size 38"])
    #expect(last.ideasInWords == "1 idea")

    let reopened = await kateScreen(at: place)
    let reopenedKate = try #require(reopened.lines.first)
    #expect(reopened.ideas(of: reopenedKate).map(\.text) == ["Hiking socks, size 38"])
}

@MainActor
@Test(
    "an idea marked given through a Birthdays screen is kept given past its contact's birthday, and its line's count drops at once"
)
func anIdeaMarkedGivenThroughABirthdaysScreenIsKeptGivenPastItsContactsBirthdayAndItsLinesCountDropsAtOnce()
    async throws
{
    let place = try ideaPlace(
        holding: [
            ("kate", idea("Ceramics class voucher")), ("kate", idea("Hiking socks, size 38")),
            ("kate", idea("Book voucher")),
        ])
    let fake = FakeCalendar(handing: [kateBirthday])
    let screen = await kateScreen(at: place, calendarFake: fake)
    let kate = try #require(screen.lines.first)

    #expect(screen.markIdea(0, of: kate, given: true) == nil)
    let marked = try #require(screen.lines.first)
    #expect(marked.ideasInWords == "2 ideas")
    #expect(screen.ideas(of: marked).last?.text == "Ceramics class voucher")
    #expect(screen.ideas(of: marked).last?.isGiven == true)
    #expect(fake.asks.count == 1)

    let nextYear = FakeCalendar(handing: [
        birthday("kate", "Kate Bell's 49th Birthday", date(2027, 11, 14))
    ])
    let later = await kateScreen(at: place, calendarFake: nextYear, today: date(2026, 11, 16))
    let laterKate = try #require(later.lines.first)
    #expect(later.ideas(of: laterKate).last?.text == "Ceramics class voucher")
    #expect(later.ideas(of: laterKate).last?.isGiven == true)
    #expect(laterKate.ideasInWords == "2 ideas")
}

@MainActor
@Test(
    "taking back an idea's mark through a Birthdays screen returns it where it was added, and its line's count rises at once"
)
func takingBackAnIdeasMarkThroughABirthdaysScreenReturnsItWhereItWasAddedAndItsLinesCountRisesAtOnce()
    async throws
{
    let place = try ideaPlace(
        holding: [("kate", idea("Ceramics class voucher")), ("kate", idea("Book voucher"))],
        given: [0])
    let screen = await kateScreen(at: place)
    let kate = try #require(screen.lines.first)

    #expect(screen.markIdea(1, of: kate, given: false) == nil)
    let back = try #require(screen.lines.first)
    #expect(back.ideasInWords == "2 ideas")
    #expect(screen.ideas(of: back).map(\.text) == ["Ceramics class voucher", "Book voucher"])
    #expect(screen.ideas(of: back).map(\.isGiven) == [false, false])

    #expect(screen.markIdea(1, of: back, given: true) == nil)
    let before = try Data(contentsOf: place)
    #expect(screen.markIdea(1, of: back, given: true) == nil)
    #expect(screen.markIdea(0, of: back, given: false) == nil)
    #expect(try Data(contentsOf: place) == before)

    let reopened = await kateScreen(at: place)
    let reopenedKate = try #require(reopened.lines.first)
    #expect(reopened.ideas(of: reopenedKate).map(\.text) == ["Ceramics class voucher", "Book voucher"])
    #expect(reopened.ideas(of: reopenedKate).map(\.isGiven) == [false, true])
}

@MainActor
@Test("a change, deletion or mark a Birthdays screen cannot keep is refused as not kept and not held")
func aChangeDeletionOrMarkABirthdaysScreenCannotKeepIsRefusedAsNotKeptAndNotHeld() async throws {
    let place = try ideaPlace(
        holding: [("kate", idea("Ceramics class voucher")), ("kate", idea("Book voucher"))],
        given: [1])
    let screen = await kateScreen(at: place)
    let kate = try #require(screen.lines.first)
    let folder = place.deletingLastPathComponent()
    try FileManager.default.setAttributes([.posixPermissions: 0o555], ofItemAtPath: folder.path)
    defer {
        try? FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: folder.path)
    }

    #expect(screen.changeIdea(0, of: kate, text: "Hiking socks", link: "") == .notKept)
    #expect(screen.markIdea(0, of: kate, given: true) == .notKept)
    #expect(screen.markIdea(1, of: kate, given: false) == .notKept)
    screen.askToDeleteIdea(0, of: kate)
    #expect(screen.confirmDeletingIdea() == .notKept)

    let held = try #require(screen.lines.first)
    #expect(screen.ideas(of: held).map(\.text) == ["Ceramics class voucher", "Book voucher"])
    #expect(screen.ideas(of: held).map(\.isGiven) == [false, true])
    #expect(held.ideasInWords == "1 idea")

    let reopened = await kateScreen(at: place)
    let reopenedKate = try #require(reopened.lines.first)
    #expect(reopened.ideas(of: reopenedKate) == screen.ideas(of: held))
}

@MainActor
@Test("a change or mark naming no idea of a line is refused as not kept and writes nothing")
func aChangeOrMarkNamingNoIdeaOfALineIsRefusedAsNotKeptAndWritesNothing() async throws {
    let place = try ideaPlace(holding: [("kate", idea("Book voucher"))])
    let before = try Data(contentsOf: place)
    let screen = await kateScreen(at: place)
    let kate = try #require(screen.lines.first)

    #expect(screen.changeIdea(1, of: kate, text: "Hiking socks", link: "") == .notKept)
    #expect(screen.markIdea(1, of: kate, given: true) == .notKept)
    #expect(try Data(contentsOf: place) == before)

    let unreadable = freshIdeaPlace()
    try FileManager.default.createDirectory(
        at: unreadable.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not a store".utf8).write(to: unreadable)
    let junk = try Data(contentsOf: unreadable)
    let blind = await kateScreen(at: unreadable)
    let blindKate = try #require(blind.lines.first)
    #expect(blind.changeIdea(0, of: blindKate, text: "Hiking socks", link: "") == .notKept)
    #expect(blind.markIdea(0, of: blindKate, given: true) == .notKept)
    blind.askToDeleteIdea(0, of: blindKate)
    #expect(blind.ideaAwaitingDeletion == nil)
    #expect(try Data(contentsOf: unreadable) == junk)
}

@MainActor
@Test("a Birthdays screen line counts only its contact's ideas not given")
func aBirthdaysScreenLineCountsOnlyItsContactsIdeasNotGiven() async throws {
    let place = try ideaPlace(
        holding: [
            ("kate", idea("Ceramics class voucher")), ("kate", idea("Hiking socks, size 38")),
            ("kate", idea("Book voucher")), ("john", idea("Scarf")),
        ], given: [1, 3])
    let screen = await kateScreen(
        at: place,
        calendarFake: FakeCalendar(handing: [
            kateBirthday, birthday("john", "John Appleseed's 40th Birthday", date(2027, 6, 5)),
        ]))
    #expect(screen.lines.map(\.ideasInWords) == ["2 ideas", nil])
}

@MainActor
@Test("a Birthdays screen gives back a line's ideas not given in the order added, then those given")
func aBirthdaysScreenGivesBackALinesIdeasNotGivenInTheOrderAddedThenThoseGiven() async throws {
    let place = try ideaPlace(
        holding: [
            ("kate", idea("Ceramics class voucher")), ("kate", idea("Hiking socks, size 38")),
            ("kate", idea("Book voucher")),
        ], given: [0])
    let screen = await kateScreen(at: place)
    let kate = try #require(screen.lines.first)
    #expect(
        screen.ideas(of: kate).map(\.text)
            == ["Hiking socks, size 38", "Book voucher", "Ceramics class voucher"])
    #expect(screen.ideas(of: kate).map(\.isGiven) == [false, false, true])

    screen.addIdea(text: "Scarf", link: "", to: kate)
    #expect(
        screen.ideas(of: kate).map(\.text)
            == ["Hiking socks, size 38", "Book voucher", "Scarf", "Ceramics class voucher"])

    screen.markIdea(3, of: kate, given: false)
    #expect(
        screen.ideas(of: kate).map(\.text)
            == ["Ceramics class voucher", "Hiking socks, size 38", "Book voucher", "Scarf"])
    #expect(screen.ideas(of: kate).map(\.isGiven) == [false, false, false, false])
}

@MainActor
@Test(
    "what a Birthdays screen tells about a refused change, deletion or mark ends with the next one not refused"
)
func whatABirthdaysScreenTellsAboutARefusedChangeDeletionOrMarkEndsWithTheNextOneNotRefused()
    async throws
{
    func refusedScreen() async throws -> (BirthdaysScreen, BirthdaysScreen.Line) {
        let place = try ideaPlace(
            holding: [("kate", idea("Ceramics class voucher")), ("kate", idea("Book voucher"))])
        let screen = await kateScreen(at: place)
        let kate = try #require(screen.lines.first)
        screen.changeIdea(0, of: kate, text: "", link: "")
        screen.askToDeleteIdea(0, of: kate)
        screen.cancelDeletingIdea()
        return (screen, kate)
    }

    let (screen, kate) = try await refusedScreen()
    #expect(screen.ideaRefusal == .saysNothing)
    #expect(screen.markIdea(1, of: kate, given: true) == nil)
    #expect(screen.ideaRefusal == nil)
    #expect(screen.markIdea(2, of: kate, given: true) == .notKept)
    #expect(screen.ideaRefusal == .notKept)
    screen.ideaFieldEdited()
    #expect(screen.ideaRefusal == nil)

    let (deleting, deletingKate) = try await refusedScreen()
    deleting.askToDeleteIdea(0, of: deletingKate)
    deleting.confirmDeletingIdea()
    #expect(deleting.ideaRefusal == nil)
}
