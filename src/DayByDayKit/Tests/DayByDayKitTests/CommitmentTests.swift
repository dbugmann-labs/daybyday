import Testing
import DayByDayKit

@Test("a commitment reads back the name it was given")
func aCommitmentReadsBackTheNameItWasGiven() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let commitment = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)

    #expect(commitment?.name == "Gym")
}

@Test("two commitments alike in name, schedule and kept-from day are the same commitment")
func twoCommitmentsAlikeInNameScheduleAndKeptFromDayAreTheSameCommitment() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let first = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)
    let second = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)

    #expect(first == second)
}

@Test("two commitments differing only in name are different commitments")
func twoCommitmentsDifferingOnlyInNameAreDifferentCommitments() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let gym = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)
    let run = Commitment(name: "Run", schedule: schedule, keptFrom: keptFrom)

    #expect(gym != run)
}

@Test("two commitments differing only in schedule are different commitments")
func twoCommitmentsDifferingOnlyInScheduleAreDifferentCommitments() {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let onMonday = Commitment(name: "Gym", schedule: .weekdays([.monday]), keptFrom: keptFrom)
    let onTuesday = Commitment(name: "Gym", schedule: .weekdays([.tuesday]), keptFrom: keptFrom)

    #expect(onMonday != onTuesday)
}

@Test("two commitments differing only in the day they are kept from are different commitments")
func twoCommitmentsDifferingOnlyInTheDayTheyAreKeptFromAreDifferentCommitments() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])

    let keptFromFirst = Commitment(
        name: "Gym", schedule: schedule, keptFrom: CalendarDate(year: 2026, month: 1, day: 1)!)
    let keptFromSecond = Commitment(
        name: "Gym", schedule: schedule, keptFrom: CalendarDate(year: 2026, month: 1, day: 2)!)

    #expect(keptFromFirst != keptFromSecond)
}

@Test("an empty name is not a commitment")
func anEmptyNameIsNotACommitment() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let commitment = Commitment(name: "", schedule: schedule, keptFrom: keptFrom)

    #expect(commitment == nil)
}

@Test("a name of only whitespace is not a commitment")
func aNameOfOnlyWhitespaceIsNotACommitment() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let threeSpaces = Commitment(name: "   ", schedule: schedule, keptFrom: keptFrom)
    let tabThenNewline = Commitment(name: "\t\n", schedule: schedule, keptFrom: keptFrom)

    #expect(threeSpaces == nil)
    #expect(tabThenNewline == nil)
}

@Test("a name with a space at each end is stored exactly as given")
func aNameWithASpaceAtEachEndIsStoredExactlyAsGiven() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let padded = Commitment(name: " Gym ", schedule: schedule, keptFrom: keptFrom)
    let unpadded = Commitment(name: "Gym", schedule: schedule, keptFrom: keptFrom)

    #expect(padded?.name == " Gym ")
    #expect(padded != unpadded)
}

@Test("a name of a single emoji is a commitment")
func aNameOfASingleEmojiIsACommitment() {
    let schedule = Schedule.weekdays([.monday, .wednesday, .saturday])
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!

    let commitment = Commitment(name: "🏋️", schedule: schedule, keptFrom: keptFrom)

    #expect(commitment?.name == "🏋️")
}
