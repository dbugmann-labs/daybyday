import Foundation
import Testing
import DayByDayKit

@Test("two one-offs alike in name and date are the same one-off")
func twoOneOffsAlikeInNameAndDateAreTheSameOneOff() {
    let first = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    let second = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!

    #expect(first == second)

    let callDad = OneOff(name: "Call dad", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    #expect(first != callDad)

    let nextDay = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 26)!)!
    #expect(first != nextDay)
}

@Test("a one-off's name is kept exactly as it was given")
func aOneOffsNameIsKeptExactlyAsItWasGiven() {
    let oneOff = OneOff(name: " Call mum ", date: CalendarDate(year: 2026, month: 9, day: 25)!)!

    #expect(oneOff.name == " Call mum ")

    let trimmed = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    #expect(oneOff != trimmed)
}

@Test("a name that says nothing is refused and makes no one-off")
func aNameThatSaysNothingIsRefusedAndMakesNoOneOff() {
    let date = CalendarDate(year: 2026, month: 9, day: 25)!

    #expect(OneOff(name: "", date: date) == nil)
    #expect(OneOff(name: "   ", date: date) == nil)
    #expect(OneOff(name: "a", date: date) != nil)
}

@Test("a one-off that is not done stands on its date until that date has passed")
func aOneOffThatIsNotDoneStandsOnItsDateUntilThatDateHasPassed() {
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    var oneOffs = OneOffs()
    _ = oneOffs.add(callMum)

    let september21 = CalendarDate(year: 2026, month: 9, day: 21)!
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!

    #expect(oneOffs.standingDay(for: callMum, asOf: september21) == september25)
    #expect(oneOffs.standingDay(for: callMum, asOf: september25) == september25)
}

@Test("a one-off that is not done and whose date has passed stands on today")
func aOneOffThatIsNotDoneAndWhoseDateHasPassedStandsOnToday() {
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    var oneOffs = OneOffs()
    _ = oneOffs.add(callMum)

    let september28 = CalendarDate(year: 2026, month: 9, day: 28)!
    let october5 = CalendarDate(year: 2026, month: 10, day: 5)!

    #expect(oneOffs.standingDay(for: callMum, asOf: september28) == september28)
    #expect(oneOffs.standingDay(for: callMum, asOf: october5) == october5)
}

@Test("a one-off that is done stands on the day it was ticked, whatever today is")
func aOneOffThatIsDoneStandsOnTheDayItWasTickedWhateverTodayIs() {
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    var oneOffs = OneOffs()
    _ = oneOffs.add(callMum)
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!
    _ = oneOffs.tick(callMum, on: september25)

    let october5 = CalendarDate(year: 2026, month: 10, day: 5)!

    #expect(oneOffs.standingDay(for: callMum, asOf: october5) == september25)
    #expect(oneOffs.standingDay(for: callMum, asOf: september25) == september25)
}

@Test("a one-off ticked after its date stands on the day it was ticked and not on its date")
func aOneOffTickedAfterItsDateStandsOnTheDayItWasTickedAndNotOnItsDate() {
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    var oneOffs = OneOffs()
    _ = oneOffs.add(callMum)
    let september28 = CalendarDate(year: 2026, month: 9, day: 28)!
    _ = oneOffs.tick(callMum, on: september28)

    let october5 = CalendarDate(year: 2026, month: 10, day: 5)!

    #expect(oneOffs.standingDay(for: callMum, asOf: october5) == september28)
}

@Test("a one-off that is not held stands on no day")
func aOneOffThatIsNotHeldStandsOnNoDay() {
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    let callDad = OneOff(name: "Call dad", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    let september21 = CalendarDate(year: 2026, month: 9, day: 21)!

    let empty = OneOffs()
    #expect(empty.standingDay(for: callMum, asOf: september21) == nil)

    var holdingCallDad = OneOffs()
    _ = holdingCallDad.add(callDad)
    #expect(holdingCallDad.standingDay(for: callMum, asOf: september21) == nil)
}

@Test("adding a one-off already held is refused and changes nothing")
func addingAOneOffAlreadyHeldIsRefusedAndChangesNothing() {
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!

    var onceAdded = OneOffs()
    _ = onceAdded.add(callMum)
    var oneOffs = onceAdded
    let addedAgain = oneOffs.add(callMum)

    #expect(!addedAgain)
    #expect(oneOffs == onceAdded)

    var done = onceAdded
    let tickedDone = done.tick(callMum, on: CalendarDate(year: 2026, month: 9, day: 25)!)
    #expect(tickedDone)
    var doneCopy = done
    let addedWhileDone = doneCopy.add(callMum)

    #expect(!addedWhileDone)
    #expect(doneCopy == done)
}

@Test("a one-off differing in name or in date is held beside the one already there")
func aOneOffDifferingInNameOrInDateIsHeldBesideTheOneAlreadyThere() {
    let callMum25 = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    let callMum26 = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 26)!)!
    let callDad25 = OneOff(name: "Call dad", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    let september21 = CalendarDate(year: 2026, month: 9, day: 21)!

    var oneOffs = OneOffs()
    _ = oneOffs.add(callMum25)
    let addedDifferentDate = oneOffs.add(callMum26)

    #expect(addedDifferentDate)
    #expect(oneOffs.standingDay(for: callMum25, asOf: september21) == callMum25.date)
    #expect(oneOffs.standingDay(for: callMum26, asOf: september21) == callMum26.date)

    let addedDifferentName = oneOffs.add(callDad25)

    #expect(addedDifferentName)
    #expect(oneOffs.standingDay(for: callDad25, asOf: september21) == callDad25.date)
}

@Test("a one-off added already done stands on the day it was done")
func aOneOffAddedAlreadyDoneStandsOnTheDayItWasDone() {
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 20)!)!
    let september20 = CalendarDate(year: 2026, month: 9, day: 20)!
    let september28 = CalendarDate(year: 2026, month: 9, day: 28)!

    var oneOffs = OneOffs()
    let added = oneOffs.add(callMum, doneOn: september20)

    #expect(added)
    #expect(oneOffs.standingDay(for: callMum, asOf: september28) == september20)

    var expected = OneOffs()
    _ = expected.add(callMum)
    _ = expected.tick(callMum, on: september20)
    #expect(oneOffs == expected)
}

@Test("a one-off ticked on a day is done and stands there")
func aOneOffTickedOnADayIsDoneAndStandsThere() {
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!
    let october5 = CalendarDate(year: 2026, month: 10, day: 5)!

    var oneOffs = OneOffs()
    _ = oneOffs.add(callMum)
    let ticked = oneOffs.tick(callMum, on: september25)

    #expect(ticked)
    #expect(oneOffs.standingDay(for: callMum, asOf: october5) == september25)
}

@Test("making a one-off done on a day before its date is refused")
func makingAOneOffDoneOnADayBeforeItsDateIsRefused() {
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    let september24 = CalendarDate(year: 2026, month: 9, day: 24)!

    var oneOffs = OneOffs()
    _ = oneOffs.add(callMum)
    var beforeTick = oneOffs
    let ticked = beforeTick.tick(callMum, on: september24)

    #expect(!ticked)
    #expect(beforeTick == oneOffs)

    let callDad = OneOff(name: "Call dad", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    var addingDone = OneOffs()
    let added = addingDone.add(callDad, doneOn: september24)

    #expect(!added)
    #expect(addingDone == OneOffs())
}

@Test("ticking a one-off that is already done is refused and leaves the day it holds")
func tickingAOneOffThatIsAlreadyDoneIsRefusedAndLeavesTheDayItHolds() {
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!
    let september28 = CalendarDate(year: 2026, month: 9, day: 28)!
    let october5 = CalendarDate(year: 2026, month: 10, day: 5)!

    var oneOffs = OneOffs()
    _ = oneOffs.add(callMum)
    _ = oneOffs.tick(callMum, on: september25)
    let tickedAgain = oneOffs.tick(callMum, on: september28)

    #expect(!tickedAgain)
    #expect(oneOffs.standingDay(for: callMum, asOf: october5) == september25)
}

@Test("ticking a one-off that is not held is refused")
func tickingAOneOffThatIsNotHeldIsRefused() {
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!

    var oneOffs = OneOffs()
    let ticked = oneOffs.tick(callMum, on: september25)

    #expect(!ticked)
    #expect(oneOffs == OneOffs())
}

@Test("a tick taken back leaves the one-off held and standing by its date again")
func aTickTakenBackLeavesTheOneOffHeldAndStandingByItsDateAgain() {
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    let september21 = CalendarDate(year: 2026, month: 9, day: 21)!
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!
    let september28 = CalendarDate(year: 2026, month: 9, day: 28)!

    var oneOffs = OneOffs()
    _ = oneOffs.add(callMum)
    _ = oneOffs.tick(callMum, on: september25)
    let takenBack = oneOffs.takeBack(callMum)

    #expect(takenBack)
    #expect(oneOffs.standingDay(for: callMum, asOf: september21) == september25)
    #expect(oneOffs.standingDay(for: callMum, asOf: september28) == september28)
}

@Test("taking back the tick of a one-off that is not done is refused")
func takingBackTheTickOfAOneOffThatIsNotDoneIsRefused() {
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!

    var oneOffs = OneOffs()
    _ = oneOffs.add(callMum)
    var unchanged = oneOffs
    let takenBack = unchanged.takeBack(callMum)

    #expect(!takenBack)
    #expect(unchanged == oneOffs)

    var empty = OneOffs()
    let takenBackNotHeld = empty.takeBack(callMum)

    #expect(!takenBackNotHeld)
    #expect(empty == OneOffs())
}

@Test("a one-off removed is held no longer and stands on no day")
func aOneOffRemovedIsHeldNoLongerAndStandsOnNoDay() {
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    let september21 = CalendarDate(year: 2026, month: 9, day: 21)!

    var oneOffs = OneOffs()
    _ = oneOffs.add(callMum)
    let removed = oneOffs.remove(callMum)

    #expect(removed)
    #expect(oneOffs.standingDay(for: callMum, asOf: september21) == nil)
    #expect(oneOffs == OneOffs())
}

@Test("a one-off that is done is removed outright, tick and all")
func aOneOffThatIsDoneIsRemovedOutrightTickAndAll() {
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    let callDad = OneOff(name: "Call dad", date: CalendarDate(year: 2026, month: 9, day: 26)!)!
    let september25 = CalendarDate(year: 2026, month: 9, day: 25)!
    let september26 = CalendarDate(year: 2026, month: 9, day: 26)!
    let october5 = CalendarDate(year: 2026, month: 10, day: 5)!

    var oneOffs = OneOffs()
    _ = oneOffs.add(callMum)
    let ticked = oneOffs.tick(callMum, on: september25)
    #expect(ticked)
    _ = oneOffs.add(callDad)
    _ = oneOffs.tick(callDad, on: september26)
    let removed = oneOffs.remove(callMum)

    #expect(removed)
    #expect(oneOffs.standingDay(for: callMum, asOf: october5) == nil)
    #expect(oneOffs.standingDay(for: callDad, asOf: october5) == september26)
}

@Test("removing a one-off that is not held is refused")
func removingAOneOffThatIsNotHeldIsRefused() {
    let callMum = OneOff(name: "Call mum", date: CalendarDate(year: 2026, month: 9, day: 25)!)!
    let callDad = OneOff(name: "Call dad", date: CalendarDate(year: 2026, month: 9, day: 25)!)!

    var oneOffs = OneOffs()
    _ = oneOffs.add(callDad)
    var unchanged = oneOffs
    let removed = unchanged.remove(callMum)

    #expect(!removed)
    #expect(unchanged == oneOffs)
}
