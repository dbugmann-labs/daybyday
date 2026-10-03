import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private let saturday = date(2026, 10, 3)

private func freshDirectory() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
}

private func freshHappeningPlace() -> URL {
    freshDirectory().appendingPathComponent("happenings.json")
}

private func freshRosterAndRecordPlaces() -> (roster: URL, record: URL) {
    let directory = freshDirectory()
    return (
        directory.appendingPathComponent("roster.json"),
        directory.appendingPathComponent("record.json")
    )
}

/// Happenings made in order at `place`, answered in the order made.
@discardableResult
private func makeHappenings(_ names: [String], at place: URL) throws -> [Happening] {
    let store = try HappeningStore(at: place)
    return try names.map { name in
        let happening = try #require(Happening(name: name))
        try store.add(happening)
        return happening
    }
}

private func time(_ hour: Int, _ minute: Int) -> TimeOfDay {
    TimeOfDay(hour: hour, minute: minute)!
}

/// Occurrences noted in order at `place`.
private func note(
    _ happening: Happening, on day: CalendarDate, at time: TimeOfDay? = nil,
    saying note: String? = nil, at place: URL
) throws {
    let store = try HappeningStore(at: place)
    try store.note(Occurrence(of: happening, on: day, at: time, saying: note))
}

@MainActor
private func screen(asOf day: CalendarDate = saturday, at place: URL) -> CommitmentsScreen {
    let places = freshRosterAndRecordPlaces()
    return CommitmentsScreen(
        asOf: day, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: place)
}

/// A directory made so that it can be read from but not written to, and the place inside it.
private func unwritable(_ place: URL) throws -> () throws -> Void {
    let directory = place.deletingLastPathComponent()
    try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: directory.path)
    return {
        try FileManager.default.setAttributes(
            [.posixPermissions: 0o700], ofItemAtPath: directory.path)
    }
}

@MainActor
@Test("asking a commitments screen to stop a happening changes nothing until it is confirmed")
func askingACommitmentsScreenToStopAHappeningChangesNothingUntilItIsConfirmed() throws {
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Augenmigräne", "Kopfweh"], at: place)
    let commitments = screen(at: place)
    let before = try Data(contentsOf: place)

    commitments.askToStop(made[1])

    #expect(commitments.happeningAwaitingStop == made[1])
    #expect(!commitments.isStopped(made[0]))
    #expect(!commitments.isStopped(made[1]))
    #expect(try Data(contentsOf: place) == before)

    commitments.askToStop(made[0])
    #expect(commitments.happeningAwaitingStop == made[0])

    commitments.cancelStoppingHappening()
    #expect(commitments.happeningAwaitingStop == nil)
    #expect(try Data(contentsOf: place) == before)
}

@MainActor
@Test(
    "a happening stopped through a commitments screen is still listed in its place and said to be stopped"
)
func aHappeningStoppedThroughACommitmentsScreenIsStillListedInItsPlaceAndSaidToBeStopped() throws {
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Augenmigräne", "Kopfweh", "Schlecht geschlafen"], at: place)
    try note(made[1], on: date(2026, 10, 2), at: time(18, 40), at: place)
    let commitments = screen(at: place)

    commitments.askToStop(made[1])
    let refusal = commitments.confirmStoppingHappening()

    #expect(refusal == nil)
    #expect(commitments.happeningAwaitingStop == nil)
    #expect(commitments.happenings.map(\.name) == ["Augenmigräne", "Kopfweh", "Schlecht geschlafen"])
    #expect(commitments.happenings.filter(commitments.isStopped).map(\.name) == ["Kopfweh"])
    let reopened = try HappeningStore(at: place)
    #expect(reopened.happenings.isStopped(made[1]))
    #expect(reopened.happenings.occurrences
            == [Occurrence(of: made[1], on: date(2026, 10, 2), at: time(18, 40), saying: nil)])
    let lookBack = try #require(commitments.lookBack(at: made[1]))
    #expect(lookBack.occurrences.map(\.dayInWords) == ["2 October 2026"])
    #expect(lookBack.occurrences.map(\.timeInWords) == ["18:40"])
    #expect(commitments.makeHappening(named: "kopfweh") == .nameAlreadyInUse("Kopfweh"))
}

@MainActor
@Test(
    "a happening resumed through a commitments screen asks for no confirmation and is said to be stopped no longer"
)
func aHappeningResumedThroughACommitmentsScreenAsksForNoConfirmationAndIsSaidToBeStoppedNoLonger()
    throws
{
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Augenmigräne", "Kopfweh"], at: place)
    try HappeningStore(at: place).stop(made[1])
    let commitments = screen(at: place)
    #expect(commitments.isStopped(made[1]))

    let refusal = commitments.resume(made[1])

    #expect(refusal == nil)
    #expect(commitments.happeningAwaitingStop == nil)
    #expect(commitments.happenings.map(\.name) == ["Augenmigräne", "Kopfweh"])
    #expect(commitments.happenings.filter(commitments.isStopped).isEmpty)
    #expect(!(try HappeningStore(at: place)).happenings.isStopped(made[1]))
}

@MainActor
@Test(
    "asking to stop a stopped happening, or to resume one not stopped, does nothing and says nothing"
)
func askingToStopAStoppedHappeningOrToResumeOneNotStoppedDoesNothingAndSaysNothing() throws {
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Augenmigräne", "Kopfweh"], at: place)
    try HappeningStore(at: place).stop(made[1])
    let before = try Data(contentsOf: place)
    let commitments = screen(at: place)

    commitments.askToStop(made[1])
    #expect(commitments.happeningAwaitingStop == nil)

    #expect(commitments.resume(made[0]) == nil)
    #expect(commitments.happeningRefusal == nil)
    #expect(commitments.confirmStoppingHappening() == nil)

    let unlisted = try #require(Happening(name: "Schlecht geschlafen"))
    commitments.askToStop(unlisted)
    #expect(commitments.happeningAwaitingStop == nil)
    #expect(commitments.resume(unlisted) == nil)
    #expect(try Data(contentsOf: place) == before)
}

@MainActor
@Test("a happening stop or resume the happening place cannot take is refused as not kept")
func aHappeningStopOrResumeTheHappeningPlaceCannotTakeIsRefusedAsNotKept() throws {
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Augenmigräne", "Kopfweh"], at: place)
    try HappeningStore(at: place).stop(made[1])
    let commitments = screen(at: place)
    let before = try Data(contentsOf: place)
    let restore = try unwritable(place)
    defer { try? restore() }

    commitments.askToStop(made[0])
    let refusal = commitments.confirmStoppingHappening()

    #expect(refusal == .notKept)
    #expect(commitments.happeningRefusal == .notKept)
    #expect(commitments.resume(made[1]) == .notKept)
    #expect(commitments.happenings.filter(commitments.isStopped) == [made[1]])
    try restore()
    #expect(try Data(contentsOf: place) == before)
}

@MainActor
@Test("asking a commitments screen to delete a happening changes nothing until it is confirmed")
func askingACommitmentsScreenToDeleteAHappeningChangesNothingUntilItIsConfirmed() throws {
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Augenmigräne", "Kopfweh"], at: place)
    let commitments = screen(at: place)
    let before = try Data(contentsOf: place)

    commitments.askToDelete(made[1])

    #expect(commitments.happeningAwaitingDeletion == made[1])
    #expect(commitments.happeningNameTypedBack == "")
    #expect(!commitments.happeningNameTypedBackMatches)
    #expect(commitments.happenings.map(\.name) == ["Augenmigräne", "Kopfweh"])
    #expect(try Data(contentsOf: place) == before)

    commitments.happeningNameTypedBack = "Kopfweh"
    commitments.askToDelete(made[0])
    #expect(commitments.happeningAwaitingDeletion == made[0])
    #expect(commitments.happeningNameTypedBack == "")

    commitments.happeningNameTypedBack = "Augen"
    commitments.cancelDeletingHappening()
    #expect(commitments.happeningAwaitingDeletion == nil)
    #expect(commitments.happeningNameTypedBack == "")
}

@MainActor
@Test("a name typed back to delete a happening matches only when it is the happening's name")
func aNameTypedBackToDeleteAHappeningMatchesOnlyWhenItIsTheHappeningsName() throws {
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Kopfweh"], at: place)
    let commitments = screen(at: place)
    commitments.askToDelete(made[0])

    var matches: [Bool] = []
    for typed in ["Kopf", "Kopfweh", "Kopfwehh"] {
        commitments.happeningNameTypedBack = typed
        matches.append(commitments.happeningNameTypedBackMatches)
    }
    #expect(matches == [false, true, false])

    commitments.happeningNameTypedBack = "  Kopfweh  "
    #expect(commitments.happeningNameTypedBackMatches)
    commitments.happeningNameTypedBack = "kopfweh"
    #expect(!commitments.happeningNameTypedBackMatches)
    commitments.happeningNameTypedBack = "KOPFWEH"
    #expect(!commitments.happeningNameTypedBackMatches)
}

@MainActor
@Test(
    "a happening deleted through a commitments screen is listed no longer, and its occurrences are gone"
)
func aHappeningDeletedThroughACommitmentsScreenIsListedNoLongerAndItsOccurrencesAreGone() throws {
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Augenmigräne", "Kopfweh"], at: place)
    try note(made[1], on: date(2026, 10, 2), at: time(18, 40), at: place)
    try note(made[1], on: date(2026, 10, 1), at: nil, at: place)
    try note(made[0], on: date(2026, 10, 1), at: time(9, 0), at: place)
    try HappeningStore(at: place).stop(made[1])
    let commitments = screen(at: place)

    commitments.askToDelete(made[1])
    commitments.happeningNameTypedBack = "Kopfweh"
    let refusal = commitments.confirmDeletingHappening()

    #expect(refusal == nil)
    #expect(commitments.happeningAwaitingDeletion == nil)
    #expect(commitments.happeningNameTypedBack == "")
    #expect(commitments.happenings.map(\.name) == ["Augenmigräne"])
    let reopened = try HappeningStore(at: place)
    #expect(reopened.happenings.all == [made[0]])
    #expect(
        reopened.happenings.occurrences
            == [Occurrence(of: made[0], on: date(2026, 10, 1), at: time(9, 0), saying: nil)])
    #expect(commitments.lookBack(at: made[1]) == nil)
    #expect(commitments.makeHappening(named: "Kopfweh") == nil)
}

@MainActor
@Test(
    "a commitments screen says how many occurrences go with the happening awaiting deletion")
func aCommitmentsScreenSaysHowManyOccurrencesGoWithTheHappeningAwaitingDeletion() throws {
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Augenmigräne", "Kopfweh", "Schlecht geschlafen"], at: place)
    for _ in 0..<12 {
        try note(made[1], on: date(2026, 10, 2), at: nil, at: place)
    }
    try note(made[0], on: date(2026, 10, 2), at: nil, at: place)
    let commitments = screen(at: place)

    #expect(commitments.happeningDeletionInWords == nil)
    commitments.askToDelete(made[1])
    #expect(commitments.happeningDeletionInWords == "Its 12 occurrences go with it.")
    commitments.askToDelete(made[0])
    #expect(commitments.happeningDeletionInWords == "Its 1 occurrence goes with it.")
    commitments.askToDelete(made[2])
    #expect(commitments.happeningDeletionInWords == "It has no occurrences.")
    commitments.cancelDeletingHappening()
    #expect(commitments.happeningDeletionInWords == nil)
}

@MainActor
@Test(
    "a happening deletion confirmed on a name that does not match, or with nothing awaiting, changes nothing"
)
func aHappeningDeletionConfirmedOnANameThatDoesNotMatchOrWithNothingAwaitingChangesNothing() throws {
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Kopfweh"], at: place)
    let commitments = screen(at: place)
    let before = try Data(contentsOf: place)

    commitments.askToDelete(made[0])
    commitments.happeningNameTypedBack = "kopfweh"
    let refusal = commitments.confirmDeletingHappening()

    #expect(refusal == nil)
    #expect(commitments.happeningRefusal == nil)
    #expect(commitments.happeningAwaitingDeletion == made[0])
    #expect(commitments.happeningNameTypedBack == "kopfweh")

    commitments.shown(asOf: saturday)
    #expect(commitments.happeningAwaitingDeletion == nil)
    #expect(commitments.happeningNameTypedBack == "")
    #expect(commitments.confirmDeletingHappening() == nil)
    #expect(commitments.happenings.map(\.name) == ["Kopfweh"])
    #expect(try Data(contentsOf: place) == before)
}

@MainActor
@Test("a happening deletion the happening place cannot take is refused as not kept")
func aHappeningDeletionTheHappeningPlaceCannotTakeIsRefusedAsNotKept() throws {
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Kopfweh"], at: place)
    try note(made[0], on: date(2026, 10, 2), at: time(9, 10), at: place)
    let commitments = screen(at: place)
    let before = try Data(contentsOf: place)
    let restore = try unwritable(place)
    defer { try? restore() }

    commitments.askToDelete(made[0])
    commitments.happeningNameTypedBack = "Kopfweh"
    let refusal = commitments.confirmDeletingHappening()

    #expect(refusal == .notKept)
    #expect(commitments.happeningRefusal == .notKept)
    #expect(commitments.happeningAwaitingDeletion == nil)
    #expect(commitments.happenings.map(\.name) == ["Kopfweh"])
    try restore()
    #expect(try Data(contentsOf: place) == before)
}

private let allWeekdays: Schedule = .weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])

private func laterMinuteEachTime(from first: Moment) -> @Sendable () -> Moment? {
    final class Counter: @unchecked Sendable {
        var minutesAsked = 0
    }
    let counter = Counter()
    return {
        let moment = Moment(
            on: first.day, hour: first.hour, minute: first.minute + counter.minutesAsked)!
        counter.minutesAsked += 1
        return moment
    }
}

@MainActor
@Test(
    "asking about a happening leaves no commitment awaiting a stop or a deletion, and the reverse")
func askingAboutAHappeningLeavesNoCommitmentAwaitingAStopOrADeletionAndTheReverse() throws {
    let places = freshRosterAndRecordPlaces()
    let gym = try #require(
        Commitment(
            name: "Gym", schedule: allWeekdays, keptFrom: date(2026, 1, 1)))
    try RosterStore(at: places.roster).add(gym)
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Kopfweh"], at: place)
    let commitments = CommitmentsScreen(
        asOf: saturday, keepingRosterAt: places.roster, keepingRecordAt: places.record,
        keepingHappeningsAt: place)

    commitments.askToDelete(gym)
    commitments.nameTypedBack = "Gym"
    commitments.askToStop(made[0])

    #expect(commitments.awaitingConfirmation == nil)
    #expect(commitments.awaitingDeletion == nil)
    #expect(commitments.nameTypedBack == "")
    #expect(commitments.happeningAwaitingStop == made[0])

    commitments.askToDelete(made[0])
    #expect(commitments.happeningAwaitingDeletion == made[0])
    #expect(commitments.happeningAwaitingStop == nil)

    commitments.happeningNameTypedBack = "Kopfweh"
    commitments.askToStopKeeping(gym)
    #expect(commitments.awaitingConfirmation == gym)
    #expect(commitments.happeningAwaitingStop == nil)
    #expect(commitments.happeningAwaitingDeletion == nil)
    #expect(commitments.happeningNameTypedBack == "")
}

@MainActor
@Test("a commitments screen opened has no happening awaiting a stop or a deletion")
func aCommitmentsScreenOpenedHasNoHappeningAwaitingAStopOrADeletion() throws {
    let place = freshHappeningPlace()
    try makeHappenings(["Kopfweh"], at: place)

    let commitments = screen(at: place)

    #expect(commitments.happeningAwaitingStop == nil)
    #expect(commitments.happeningAwaitingDeletion == nil)
    #expect(commitments.happeningNameTypedBack == "")
    #expect(!commitments.happeningNameTypedBackMatches)
}

@MainActor
@Test(
    "stopping, resuming and deleting a happening writes no copy and leaves the other places as they were"
)
func stoppingResumingAndDeletingAHappeningWritesNoCopyAndLeavesTheOtherPlacesAsTheyWere() throws {
    let directory = freshDirectory()
    let rosterPlace = directory.appendingPathComponent("roster.json")
    let recordPlace = directory.appendingPathComponent("record.json")
    let oneOffPlace = directory.appendingPathComponent("one-offs.json")
    let birthdayPlace = directory.appendingPathComponent("birthday-ticks.json")
    let happeningPlace = directory.appendingPathComponent("happenings.json")
    let gym = try #require(
        Commitment(name: "Gym", schedule: allWeekdays, keptFrom: date(2026, 1, 1)))
    try RosterStore(at: rosterPlace).add(gym)
    let kopfweh = try makeHappenings(["Kopfweh"], at: happeningPlace)[0]
    try note(kopfweh, on: date(2026, 10, 2), at: time(9, 10), at: happeningPlace)

    let copyPlace = CopyPlace(
        at: freshDirectory().appendingPathComponent("copy-place.json"),
        keepingRecordAt: recordPlace, keepingRosterAt: rosterPlace, keepingOneOffsAt: oneOffPlace,
        keepingBirthdayTicksAt: birthdayPlace,
        asking: laterMinuteEachTime(from: Moment(on: saturday, hour: 14, minute: 32)!))
    let commitments = CommitmentsScreen(
        asOf: saturday, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace,
        keepingOneOffsAt: oneOffPlace, keepingBirthdayTicksAt: birthdayPlace,
        keepingHappeningsAt: happeningPlace, copyingTo: copyPlace)
    commitments.givenAsCopyPlace(freshDirectory())
    let rosterBytes = try Data(contentsOf: rosterPlace)
    #expect(copyPlace.lastCopy == Moment(on: saturday, hour: 14, minute: 32)!)

    commitments.askToStop(kopfweh)
    let stopped = commitments.confirmStoppingHappening()
    let resumed = commitments.resume(kopfweh)
    commitments.askToDelete(kopfweh)
    commitments.happeningNameTypedBack = "Kopfweh"
    let deleted = commitments.confirmDeletingHappening()

    #expect(stopped == nil && resumed == nil && deleted == nil)
    #expect(commitments.happenings.isEmpty)
    #expect(copyPlace.lastCopy == Moment(on: saturday, hour: 14, minute: 32)!)
    #expect(try Data(contentsOf: rosterPlace) == rosterBytes)
    #expect(!FileManager.default.fileExists(atPath: recordPlace.path))
    #expect(!FileManager.default.fileExists(atPath: oneOffPlace.path))
    #expect(!FileManager.default.fileExists(atPath: birthdayPlace.path))
}

@MainActor
@Test(
    "what a commitments screen tells about a happening ends when a stop, a resume or a deletion is kept"
)
func whatACommitmentsScreenTellsAboutAHappeningEndsWhenAStopAResumeOrADeletionIsKept() throws {
    let place = freshHappeningPlace()
    let made = try makeHappenings(["Augenmigräne", "Kopfweh"], at: place)
    let commitments = screen(at: place)

    #expect(commitments.makeHappening(named: "") == .namesNothing)
    commitments.askToStop(made[1])
    #expect(commitments.happeningRefusal == .namesNothing)
    commitments.confirmStoppingHappening()
    #expect(commitments.happeningRefusal == nil)

    #expect(commitments.makeHappening(named: "") == .namesNothing)
    commitments.resume(made[1])
    #expect(commitments.happeningRefusal == nil)

    #expect(commitments.makeHappening(named: "") == .namesNothing)
    commitments.askToDelete(made[0])
    commitments.happeningNameTypedBack = "Augenmigräne"
    #expect(commitments.happeningRefusal == .namesNothing)
    commitments.confirmDeletingHappening()
    #expect(commitments.happeningRefusal == nil)
}
