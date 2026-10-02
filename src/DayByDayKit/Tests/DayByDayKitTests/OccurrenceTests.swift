import Foundation
import Testing

@testable import DayByDayKit

private let second = CalendarDate(year: 2026, month: 10, day: 2)!

@Test("an occurrence holds its happening, its day, its time and its note as given")
func anOccurrenceHoldsItsHappeningItsDayItsTimeAndItsNoteAsGiven() throws {
    let kopfweh = try #require(Happening(name: "Kopfweh"))
    let time = try #require(TimeOfDay(hour: 9, minute: 10))
    let note = " Hinter dem Auge\nlinks "

    let occurrence = Occurrence(of: kopfweh, on: second, at: time, saying: note)

    #expect(occurrence.happening == kopfweh.identity)
    #expect(occurrence.day == second)
    #expect(occurrence.time == time)
    #expect(occurrence.time?.hour == 9)
    #expect(occurrence.time?.minute == 10)
    #expect(occurrence.note == note)
    #expect(Occurrence(of: kopfweh, on: second, at: nil, saying: nil).time == nil)
}

@Test("a note that says nothing is no note, and a time outside the clock is no time")
func aNoteThatSaysNothingIsNoNoteAndATimeOutsideTheClockIsNoTime() throws {
    let kopfweh = try #require(Happening(name: "Kopfweh"))

    let blank = Occurrence(of: kopfweh, on: second, at: nil, saying: "  \n\t")
    #expect(blank.note == nil)
    #expect(Occurrence(of: kopfweh, on: second, at: nil, saying: "").note == nil)
    #expect(TimeOfDay(hour: 24, minute: 0) == nil)
    #expect(TimeOfDay(hour: 9, minute: 60) == nil)
    #expect(TimeOfDay(hour: 0, minute: 0) != nil)
    #expect(TimeOfDay(hour: 23, minute: 59) != nil)
}

@Test("occurrences are held in the order noted, and two alike are both held")
func occurrencesAreHeldInTheOrderNotedAndTwoAlikeAreBothHeld() throws {
    let augenmigraene = try #require(Happening(name: "Augenmigräne"))
    let kopfweh = try #require(Happening(name: "Kopfweh"))
    var happenings = Happenings()
    _ = happenings.add(augenmigraene)
    _ = happenings.add(kopfweh)
    let evening = TimeOfDay(hour: 18, minute: 40)
    let first = Occurrence(of: kopfweh, on: second, at: evening, saying: nil)
    let middle = Occurrence(
        of: augenmigraene, on: CalendarDate(year: 2026, month: 10, day: 1)!, at: nil, saying: nil)
    let third = Occurrence(of: kopfweh, on: second, at: evening, saying: nil)

    let noted = [happenings.note(first), happenings.note(middle), happenings.note(third)]

    #expect(noted == [true, true, true])

    #expect(happenings.occurrences == [first, middle, third])
    #expect(happenings.occurrences[0] == happenings.occurrences[2])
}

@Test("an occurrence of a happening not held is refused and changes nothing")
func anOccurrenceOfAHappeningNotHeldIsRefusedAndChangesNothing() throws {
    let kopfweh = try #require(Happening(name: "Kopfweh"))
    let stranger = try #require(Happening(name: "Schlecht geschlafen"))
    var happenings = Happenings()
    _ = happenings.add(kopfweh)
    let before = happenings

    let noted = happenings.note(
        Occurrence(of: stranger, on: second, at: TimeOfDay(hour: 7, minute: 0), saying: nil))

    #expect(noted == false)
    #expect(happenings == before)
    #expect(happenings.occurrences.isEmpty)
}

@Test("a happening renamed keeps its occurrences")
func aHappeningRenamedKeepsItsOccurrences() throws {
    let kopfweh = try #require(Happening(name: "Kopfweh"))
    let augenmigraene = try #require(Happening(name: "Augenmigräne"))
    var happenings = Happenings()
    _ = happenings.add(kopfweh)
    _ = happenings.note(
        Occurrence(of: kopfweh, on: second, at: TimeOfDay(hour: 9, minute: 10), saying: nil))

    let renamed = happenings.rename(kopfweh, to: "Spannungskopfweh")

    #expect(renamed)
    #expect(happenings.all.map(\.name) == ["Spannungskopfweh"])
    #expect(happenings.occurrences.map(\.happening) == [kopfweh.identity])
    #expect(happenings.occurrences[0].day == second)
    #expect(happenings.occurrences[0].time == TimeOfDay(hour: 9, minute: 10))

    let held = happenings.occurrences
    _ = happenings.add(augenmigraene)
    #expect(happenings.occurrences == held)
}
