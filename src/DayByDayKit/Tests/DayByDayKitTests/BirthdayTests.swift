import Foundation
import Testing
import DayByDayKit

@Test("two birthdays alike in contact, words and day are the same birthday")
func twoBirthdaysAlikeInContactWordsAndDayAreTheSameBirthday() {
    let first = Birthday(
        contact: "kate", words: "Kate Bell's 48th Birthday",
        day: CalendarDate(year: 2026, month: 9, day: 25)!)!
    let second = Birthday(
        contact: "kate", words: "Kate Bell's 48th Birthday",
        day: CalendarDate(year: 2026, month: 9, day: 25)!)!

    #expect(first == second)

    let john = Birthday(
        contact: "john", words: "Kate Bell's 48th Birthday",
        day: CalendarDate(year: 2026, month: 9, day: 25)!)!
    #expect(first != john)

    let differentWords = Birthday(
        contact: "kate", words: "Kate Smith's 48th Birthday",
        day: CalendarDate(year: 2026, month: 9, day: 25)!)!
    #expect(first != differentWords)

    let differentDay = Birthday(
        contact: "kate", words: "Kate Bell's 48th Birthday",
        day: CalendarDate(year: 2027, month: 9, day: 25)!)!
    #expect(first != differentDay)
}

@Test("a birthday's words are kept exactly as they were handed")
func aBirthdaysWordsAreKeptExactlyAsTheyWereHanded() {
    let padded = Birthday(
        contact: "kate", words: " Kate Bell's 48th Birthday ",
        day: CalendarDate(year: 2026, month: 9, day: 25)!)!
    #expect(padded.words == " Kate Bell's 48th Birthday ")

    let noAge = Birthday(
        contact: "kate", words: "Kate Bell's Birthday",
        day: CalendarDate(year: 2026, month: 9, day: 25)!)!
    #expect(noAge.words == "Kate Bell's Birthday")

    let empty = Birthday(
        contact: "kate", words: "", day: CalendarDate(year: 2026, month: 9, day: 25)!)
    #expect(empty != nil)
    #expect(empty?.words == "")
}

@Test("a birthday whose contact says nothing is refused and makes no birthday")
func aBirthdayWhoseContactSaysNothingIsRefusedAndMakesNoBirthday() {
    let day = CalendarDate(year: 2026, month: 9, day: 25)!

    #expect(Birthday(contact: "", words: "Kate Bell's 48th Birthday", day: day) == nil)
    #expect(Birthday(contact: "   ", words: "Kate Bell's 48th Birthday", day: day) == nil)
    #expect(Birthday(contact: "a", words: "Kate Bell's 48th Birthday", day: day) != nil)
}

@Test("the birthdays on a day are the ones handed that fall on it, in the order they were handed")
func theBirthdaysOnADayAreTheOnesHandedThatFallOnItInTheOrderTheyWereHanded() {
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!
    let september26 = CalendarDate(year: 2026, month: 9, day: 26)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: september25)!
    let john = Birthday(contact: "john", words: "John Appleseed's 40th Birthday", day: september26)!
    let anna = Birthday(contact: "anna", words: "Anna Haro's Birthday", day: september25)!

    #expect(Birthday.falling(on: september25, among: [kate, john, anna]) == [kate, anna])
    #expect(Birthday.falling(on: september25, among: [anna, john, kate]) == [anna, kate])
    #expect(Birthday.falling(on: september25, among: [kate, john, anna, kate]) == [kate, anna, kate])
}

@Test("a day on which no birthday handed falls holds no birthdays")
func aDayOnWhichNoBirthdayHandedFallsHoldsNoBirthdays() {
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!
    let september26 = CalendarDate(year: 2026, month: 9, day: 26)!
    let september27 = CalendarDate(year: 2026, month: 9, day: 27)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: september25)!
    let john = Birthday(contact: "john", words: "John Appleseed's 40th Birthday", day: september26)!
    let anna = Birthday(contact: "anna", words: "Anna Haro's Birthday", day: september25)!

    #expect(Birthday.falling(on: september27, among: [kate, john, anna]).isEmpty)
    #expect(Birthday.falling(on: september25, among: []).isEmpty)
}

@Test("a birthday ticked is ticked, and no other birthday is")
func aBirthdayTickedIsTickedAndNoOtherBirthdayIs() {
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!
    let september25NextYear = CalendarDate(year: 2027, month: 9, day: 25)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: september25)!

    var ticks = BirthdayTicks()
    let ticked = ticks.tick(kate)

    #expect(ticked)
    #expect(ticks.isTicked(kate))

    let john = Birthday(
        contact: "john", words: "John Appleseed's 40th Birthday", day: september25)!
    #expect(!ticks.isTicked(john))

    let kateNextYear = Birthday(
        contact: "kate", words: "Kate Bell's 49th Birthday", day: september25NextYear)!
    #expect(!ticks.isTicked(kateNextYear))
}

@Test("a tick follows its birthday when the calendar's words for it change")
func aTickFollowsItsBirthdayWhenTheCalendarsWordsForItChange() {
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: september25)!
    let kateRenamed = Birthday(
        contact: "kate", words: "Kate Smith's 48th Birthday", day: september25)!

    var ticks = BirthdayTicks()
    _ = ticks.tick(kate)

    #expect(ticks.isTicked(kateRenamed))
}

@Test("ticking a birthday already ticked is refused and changes nothing")
func tickingABirthdayAlreadyTickedIsRefusedAndChangesNothing() {
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: september25)!
    let kateRenamed = Birthday(
        contact: "kate", words: "Kate Smith's 48th Birthday", day: september25)!

    var onceTicked = BirthdayTicks()
    _ = onceTicked.tick(kate)
    var ticks = onceTicked
    let tickedAgain = ticks.tick(kate)

    #expect(!tickedAgain)
    #expect(ticks == onceTicked)

    var second = onceTicked
    let tickedUnderNewWords = second.tick(kateRenamed)

    #expect(!tickedUnderNewWords)
    #expect(second == onceTicked)
}

@Test("a tick taken back leaves the birthday not ticked")
func aTickTakenBackLeavesTheBirthdayNotTicked() {
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: september25)!
    let kateRenamed = Birthday(
        contact: "kate", words: "Kate Smith's 48th Birthday", day: september25)!

    var ticks = BirthdayTicks()
    _ = ticks.tick(kate)
    let takenBack = ticks.takeBack(kate)

    #expect(takenBack)
    #expect(!ticks.isTicked(kate))
    #expect(ticks == BirthdayTicks())

    var second = BirthdayTicks()
    _ = second.tick(kate)
    let takenBackByRenamed = second.takeBack(kateRenamed)

    #expect(takenBackByRenamed)
    #expect(second == BirthdayTicks())
}

@Test("taking back the tick of a birthday that is not ticked is refused")
func takingBackTheTickOfABirthdayThatIsNotTickedIsRefused() {
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!
    let september25NextYear = CalendarDate(year: 2027, month: 9, day: 25)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: september25)!
    let kateNextYear = Birthday(
        contact: "kate", words: "Kate Bell's 49th Birthday", day: september25NextYear)!

    var empty = BirthdayTicks()
    let takenBack = empty.takeBack(kate)

    #expect(!takenBack)
    #expect(empty == BirthdayTicks())

    var onlyKateTicked = BirthdayTicks()
    _ = onlyKateTicked.tick(kate)
    var ticks = onlyKateTicked
    let takenBackNextYear = ticks.takeBack(kateNextYear)

    #expect(!takenBackNextYear)
    #expect(ticks == onlyKateTicked)
    #expect(ticks.isTicked(kate))
}

@Test(
    "a tick whose birthday the calendar no longer hands is kept, and ticks it again when it is handed again"
)
func aTickWhoseBirthdayTheCalendarNoLongerHandsIsKeptAndTicksItAgainWhenItIsHandedAgain() {
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!
    let kate = Birthday(contact: "kate", words: "Kate Bell's 48th Birthday", day: september25)!
    let john = Birthday(
        contact: "john", words: "John Appleseed's 40th Birthday", day: september25)!

    var ticks = BirthdayTicks()
    _ = ticks.tick(kate)
    let onlyJohnHanded = [john]

    #expect(Birthday.falling(on: september25, among: onlyJohnHanded) == [john])
    #expect(ticks == {
        var expected = BirthdayTicks()
        _ = expected.tick(kate)
        return expected
    }())
    #expect(ticks.isTicked(kate))
}
