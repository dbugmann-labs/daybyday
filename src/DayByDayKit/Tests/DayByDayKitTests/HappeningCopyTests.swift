import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private func time(_ hour: Int, _ minute: Int) -> TimeOfDay {
    TimeOfDay(hour: hour, minute: minute)!
}

private let saturday = date(2026, 10, 3)

private func moment(_ hour: Int, _ minute: Int, on day: CalendarDate = saturday) -> Moment {
    Moment(on: day, hour: hour, minute: minute)!
}

/// A fresh roster, record, one-off, birthday and happening place, five sibling files under one
/// fresh temporary directory. Nothing is created until something writes to one of the five.
private struct Places {
    let roster: URL
    let record: URL
    let oneOffs: URL
    let birthday: URL
    let happenings: URL

    init() {
        let base = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        roster = base.appendingPathComponent("roster.json")
        record = base.appendingPathComponent("record.json")
        oneOffs = base.appendingPathComponent("one-offs.json")
        birthday = base.appendingPathComponent("birthday-ticks.json")
        happenings = base.appendingPathComponent("happenings.json")
    }

    @MainActor
    func commitmentsScreen(
        asOf day: CalendarDate = saturday, copyingTo copyPlace: CopyPlace? = nil
    ) -> CommitmentsScreen {
        CommitmentsScreen(
            asOf: day, keepingRosterAt: roster, keepingRecordAt: record, keepingOneOffsAt: oneOffs,
            keepingBirthdayTicksAt: birthday, keepingHappeningsAt: happenings,
            copyingTo: copyPlace)
    }
}

/// A fresh directory of its own for a copy or a take-out to be written into.
private func freshDirectory() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
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

/// An occurrence noted at `place`.
private func note(
    _ happening: Happening, on day: CalendarDate, at time: TimeOfDay? = nil,
    saying words: String? = nil, at place: URL
) throws {
    try HappeningStore(at: place).note(Occurrence(of: happening, on: day, at: time, saying: words))
}

/// The copy `url` holds, read as a copy is read.
private func copyHeld(at url: URL) throws -> Copy {
    let result = CopyDocument.read(try Data(contentsOf: url))
    guard case .success(let copy) = result else {
        Issue.record("expected \(url.lastPathComponent) to read as a copy")
        throw CocoaError(.fileReadCorruptFile)
    }
    return copy
}

@MainActor
@Test(
    "a copy holds the happenings and occurrences the happening place holds, and none where nothing has been kept there"
)
func aCopyHoldsTheHappeningsAndOccurrencesTheHappeningPlaceHoldsAndNoneWhereNothingHasBeenKeptThere()
    throws
{
    let places = Places()
    let made = try makeHappenings(["Augenmigräne", "Kopfweh"], at: places.happenings)
    try note(
        made[1], on: date(2026, 10, 2), at: time(9, 10), saying: "links", at: places.happenings)
    try HappeningStore(at: places.happenings).stop(made[0])

    let screen = places.commitmentsScreen()
    let bytesBefore = try Data(contentsOf: places.happenings)

    let result = screen.makeACopy(asOf: moment(14, 32), writingInto: freshDirectory())

    guard case .success(let url) = result else {
        Issue.record("expected a copy to be made")
        return
    }
    let copy = try copyHeld(at: url)
    #expect(copy.happenings.all == made)
    #expect(copy.happenings.all.map(\.name) == ["Augenmigräne", "Kopfweh"])
    #expect(copy.happenings.isStopped(made[0]))
    #expect(!copy.happenings.isStopped(made[1]))
    #expect(
        copy.happenings.occurrences == [
            Occurrence(of: made[1], on: date(2026, 10, 2), at: time(9, 10), saying: "links")
        ])
    #expect(try Data(contentsOf: places.happenings) == bytesBefore)

    let empty = Places()
    let emptyResult = empty.commitmentsScreen().makeACopy(
        asOf: moment(14, 32), writingInto: freshDirectory())
    guard case .success(let emptyURL) = emptyResult else {
        Issue.record("expected a copy to be made")
        return
    }
    #expect(try copyHeld(at: emptyURL).happenings.all.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: empty.happenings.path))
}

/// The bytes of a happening store written in the form one later than this app writes.
private func laterHappeningBytes() -> Data {
    Data(#"{"version":\#(HappeningDocument.currentVersion + 1),"happenings":[]}"#.utf8)
}

private let notAHappeningStore = Data("not what happenings are written as".utf8)

private func write(_ bytes: Data, to place: URL) throws {
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try bytes.write(to: place)
}

private let allWeekdays: Schedule = .weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])

private let gym = Commitment(
    name: "Gym", schedule: allWeekdays, keptFrom: date(2026, 1, 1))!

@MainActor
@Test(
    "a copy is refused whole where the happenings cannot be read, naming them only where the other four stores read"
)
func aCopyIsRefusedWholeWhereTheHappeningsCannotBeReadNamingThemOnlyWhereTheOtherFourStoresRead()
    throws
{
    let places = Places()
    try RosterStore(at: places.roster).add(gym)
    try write(notAHappeningStore, to: places.happenings)
    let screen = places.commitmentsScreen()
    let directory = freshDirectory()

    let result = screen.makeACopy(asOf: moment(14, 32), writingInto: directory)

    guard case .failure(let refusal) = result else {
        Issue.record("expected a copy to be refused")
        return
    }
    #expect(refusal == .storeCouldNotBeRead)
    #expect(screen.refusedChange == .makingACopy(.happenings, .storeCouldNotBeRead))
    #expect(!FileManager.default.fileExists(atPath: directory.path))
    #expect(try Data(contentsOf: places.happenings) == notAHappeningStore)

    // A happening store of the form one later than this app writes.
    try write(laterHappeningBytes(), to: places.happenings)
    let later = screen.makeACopy(asOf: moment(14, 32), writingInto: directory)
    guard case .failure(let laterRefusal) = later else {
        Issue.record("expected a copy to be refused")
        return
    }
    #expect(laterRefusal == .storeWrittenByALaterVersion)
    #expect(screen.refusedChange == .makingACopy(.happenings, .storeWrittenByALaterVersion))

    // The birthday place unreadable too is named, not the happenings.
    try write(Data("not what birthday ticks are written as".utf8), to: places.birthday)
    let both = screen.makeACopy(asOf: moment(14, 32), writingInto: directory)
    guard case .failure(let bothRefusal) = both else {
        Issue.record("expected a copy to be refused")
        return
    }
    #expect(bothRefusal == .storeCouldNotBeRead)
    #expect(screen.refusedChange == .makingACopy(.birthdayTicks, .storeCouldNotBeRead))
    #expect(!FileManager.default.fileExists(atPath: directory.path))
}

/// A clock that answers a later minute each time it is asked, starting from `first`.
private func laterMinuteEachTime(from first: Moment) -> @Sendable () -> Moment? {
    final class Counter: @unchecked Sendable {
        var minutesAsked = 0
    }
    let counter = Counter()
    return {
        let asked = Moment(
            on: first.day, hour: first.hour, minute: first.minute + counter.minutesAsked)!
        counter.minutesAsked += 1
        return asked
    }
}

/// A fresh place of its own for a copy place to keep its own state at.
private func freshCopyPlaceState() -> URL {
    freshDirectory().appendingPathComponent("copy-place.json")
}

extension Places {
    @MainActor
    fileprivate func copyPlace(asking clock: @escaping @Sendable () -> Moment?) -> CopyPlace {
        CopyPlace(
            at: freshCopyPlaceState(), keepingRecordAt: record, keepingRosterAt: roster,
            keepingOneOffsAt: oneOffs, keepingBirthdayTicksAt: birthday,
            keepingHappeningsAt: happenings, asking: clock)
    }

    @MainActor
    fileprivate func dayScreen(
        asOf day: CalendarDate = saturday, copyingTo copyPlace: CopyPlace? = nil
    ) -> DayScreen {
        DayScreen(
            startingFrom: [], asOf: day, keepingRecordAt: record, keepingRosterAt: roster,
            keepingOneOffsAt: oneOffs, keepingBirthdayTicksAt: birthday,
            keepingHappeningsAt: happenings, copyingTo: copyPlace)
    }
}

@MainActor
@Test(
    "a change kept where the happenings cannot be read is kept, and the stop names the happenings"
)
func aChangeKeptWhereTheHappeningsCannotBeReadIsKeptAndTheStopNamesTheHappenings() throws {
    func stopAfterTickingWith(_ bytes: Data) throws -> CopyPlace.Stopped? {
        let places = Places()
        try RosterStore(at: places.roster).add(gym)
        let copyPlace = places.copyPlace(asking: laterMinuteEachTime(from: moment(14, 32)))
        let dayScreen = places.dayScreen(copyingTo: copyPlace)
        places.commitmentsScreen(copyingTo: copyPlace).givenAsCopyPlace(freshDirectory())

        try write(bytes, to: places.happenings)
        try dayScreen.tick(dayScreen.dayView.rows.first { $0.name == "Gym" }!)

        #expect(dayScreen.notice == nil)
        #expect(try RecordStore(at: places.record).history.isKept(gym, on: saturday))
        return copyPlace.stopped
    }

    #expect(
        try stopAfterTickingWith(notAHappeningStore)
            == CopyPlace.Stopped(stop: .storeCouldNotBeRead(.happenings), since: moment(14, 33)))
    #expect(
        try stopAfterTickingWith(laterHappeningBytes())
            == CopyPlace.Stopped(
                stop: .storeWrittenByALaterVersion(.happenings), since: moment(14, 33)))
}

@MainActor
@Test(
    "a copy place given no happening place copies the happenings a commitments screen given none keeps"
)
func aCopyPlaceGivenNoHappeningPlaceCopiesTheHappeningsACommitmentsScreenGivenNoneKeeps() throws {
    let base = freshDirectory()
    let record = base.appendingPathComponent("record.json")
    let roster = base.appendingPathComponent("roster.json")
    let oneOffs = base.appendingPathComponent("one-offs.json")
    try makeHappenings(["Kopfweh"], at: base.appendingPathComponent("happenings.json"))

    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: record, keepingRosterAt: roster,
        keepingOneOffsAt: oneOffs, asking: { moment(14, 32) })
    let screen = CommitmentsScreen(
        asOf: saturday, keepingRosterAt: roster, keepingRecordAt: record,
        keepingOneOffsAt: oneOffs, copyingTo: copyPlace)
    let directory = freshDirectory()

    screen.givenAsCopyPlace(directory)

    #expect(screen.happenings.map(\.name) == ["Kopfweh"])
    let copy = try copyHeld(at: directory.appendingPathComponent(CopyPlace.fileName))
    #expect(copy.happenings.all.map(\.name) == ["Kopfweh"])
}

/// `copy`, written as a copy was written before copies held happenings: form 2, no key named
/// `happenings` — derived from the current encoding by dropping that key and lowering `version`.
private func form2CopyBytes(_ copy: Copy) throws -> Data {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys]
    var object =
        try JSONSerialization.jsonObject(with: encoder.encode(CopyDocument(copy)))
        as! [String: Any]
    object["version"] = 2
    object.removeValue(forKey: "happenings")
    return try JSONSerialization.data(withJSONObject: object, options: [.sortedKeys])
}

/// The same, written before copies held birthday ticks either: form 1.
private func form1CopyBytes(_ copy: Copy) throws -> Data {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys]
    var object =
        try JSONSerialization.jsonObject(with: encoder.encode(CopyDocument(copy)))
        as! [String: Any]
    object["version"] = 1
    object.removeValue(forKey: "happenings")
    object.removeValue(forKey: "birthdayTicks")
    return try JSONSerialization.data(withJSONObject: object, options: [.sortedKeys])
}

/// A place for a picked `.daybyday` file under a directory of its own, holding `bytes`.
private func pickedFile(holding bytes: Data) throws -> URL {
    let file = freshDirectory().appendingPathComponent("DayByDay 2026-10-03 09.07.daybyday")
    try write(bytes, to: file)
    return file
}

/// A copy of a roster of one commitment, "Gym", made at 09:07.
private func gymCopy() -> Copy {
    var roster = Roster()
    _ = roster.add(gym)
    return Copy(
        moment: moment(9, 7), history: History(), roster: roster, oneOffs: OneOffs())
}

@MainActor
@Test(
    "a copy made before copies held happenings is read as holding none, and restoring it leaves the happening place holding none"
)
func aCopyMadeBeforeCopiesHeldHappeningsIsReadAsHoldingNoneAndRestoringItLeavesTheHappeningPlaceHoldingNone()
    throws
{
    func restoring(_ bytes: Data) throws {
        let places = Places()
        let kopfweh = try makeHappenings(["Kopfweh"], at: places.happenings)[0]
        try note(kopfweh, on: date(2026, 10, 2), at: time(9, 10), at: places.happenings)
        let screen = places.commitmentsScreen()

        let refusal = screen.askToRestore(from: try pickedFile(holding: bytes))

        #expect(refusal == nil)
        #expect(screen.awaitingRestore?.copy.happenings == 0)
        #expect(screen.awaitingRestore?.copy.stoppedHappenings == 0)

        #expect(screen.confirmRestoring() == nil)

        let store = try HappeningStore(at: places.happenings)
        #expect(store.happenings.all.isEmpty)
        #expect(store.happenings.occurrences.isEmpty)
        #expect(screen.happenings.isEmpty)
        #expect(screen.kept.map(\.name) == ["Gym"])
    }

    let copy = gymCopy()
    try restoring(form2CopyBytes(copy))
    try restoring(form1CopyBytes(copy))

    // A copy made through a screen afterwards says a form later than the file's.
    let places = Places()
    let screen = places.commitmentsScreen()
    let result = screen.makeACopy(asOf: moment(14, 32), writingInto: freshDirectory())
    guard case .success(let url) = result else {
        Issue.record("expected a copy to be made")
        return
    }
    let written = try JSONSerialization.jsonObject(with: Data(contentsOf: url)) as! [String: Any]
    #expect((written["version"] as? Int ?? 0) > 2)
}

/// The bytes of the copy `screen` makes as of 14:32, its `happenings` key replaced by `happenings`
/// (a JSON object) where given, or taken out where `nil`, and `roster` replaced where given.
@MainActor
private func copyBytes(
    madeThrough screen: CommitmentsScreen, happenings: String?, roster: String? = nil
) throws -> Data {
    let result = screen.makeACopy(asOf: moment(14, 32), writingInto: freshDirectory())
    guard case .success(let url) = result else {
        Issue.record("expected a copy to be made")
        throw CocoaError(.fileWriteUnknown)
    }
    var object = try JSONSerialization.jsonObject(with: Data(contentsOf: url)) as! [String: Any]
    func parsed(_ json: String) throws -> Any {
        try JSONSerialization.jsonObject(with: Data(json.utf8))
    }
    if let happenings {
        object["happenings"] = try parsed(happenings)
    } else {
        object.removeValue(forKey: "happenings")
    }
    if let roster {
        object["roster"] = try parsed(roster)
    }
    return try JSONSerialization.data(withJSONObject: object, options: [.sortedKeys])
}

private let kopfwehIdentity = "11111111-1111-1111-1111-111111111111"
private let kopfwehLowerIdentity = "22222222-2222-2222-2222-222222222222"
private let strangerIdentity = "33333333-3333-3333-3333-333333333333"

@MainActor
@Test(
    "a copy whose happenings do not fit together is refused as a damaged copy, and one whose happenings are of a later form as a copy from a later version"
)
func aCopyWhoseHappeningsDoNotFitTogetherIsRefusedAsADamagedCopyAndOneWhoseHappeningsAreOfALaterFormAsACopyFromALaterVersion()
    throws
{
    let places = Places()
    let screen = places.commitmentsScreen()

    func askingToRestore(happenings: String?, roster: String? = nil) throws -> (
        CommitmentsScreen.Refusal?, CommitmentsScreen.AwaitingRestore?
    ) {
        let bytes = try copyBytes(madeThrough: screen, happenings: happenings, roster: roster)
        let refusal = screen.askToRestore(from: try pickedFile(holding: bytes))
        return (refusal, screen.awaitingRestore)
    }

    let strangerOccurrence = """
        {"version":3,"happenings":[{"identity":"\(kopfwehIdentity)","name":"Kopfweh"}],\
        "occurrences":[{"happening":"\(strangerIdentity)","day":{"year":2026,"month":10,"day":2}}]}
        """
    let strangerRefusal = try askingToRestore(happenings: strangerOccurrence)
    #expect(strangerRefusal.0 == .damagedCopy)
    #expect(strangerRefusal.1 == nil)

    let sameName = """
        {"version":3,"happenings":[{"identity":"\(kopfwehIdentity)","name":"Kopfweh"},\
        {"identity":"\(kopfwehLowerIdentity)","name":"kopfweh"}],"occurrences":[]}
        """
    #expect(try askingToRestore(happenings: sameName).0 == .damagedCopy)
    #expect(try askingToRestore(happenings: nil).0 == .damagedCopy)

    let later = #"{"version":\#(HappeningDocument.currentVersion + 1),"happenings":[]}"#
    #expect(try askingToRestore(happenings: later).0 == .copyFromALaterVersion)
    #expect(
        try askingToRestore(happenings: later, roster: #"{"version":1}"#).0
            == .copyFromALaterVersion)
}

/// A copy made through `screen` as of 14:32 into a directory of its own, as the file picked to
/// restore from.
@MainActor
private func copyPicked(madeThrough screen: CommitmentsScreen) throws -> URL {
    let result = screen.makeACopy(asOf: moment(14, 32), writingInto: freshDirectory())
    guard case .success(let url) = result else {
        Issue.record("expected a copy to be made")
        throw CocoaError(.fileWriteUnknown)
    }
    return url
}

/// Deletes `happening` through `screen`, its name typed back.
@MainActor
private func delete(_ happening: Happening, through screen: CommitmentsScreen) {
    screen.askToDelete(happening)
    screen.happeningNameTypedBack = happening.name
    screen.confirmDeletingHappening()
}

/// Stops `happening` through `screen`.
@MainActor
private func stop(_ happening: Happening, through screen: CommitmentsScreen) {
    screen.askToStop(happening)
    screen.confirmStoppingHappening()
}

@MainActor
@Test(
    "a commitments screen asked to restore says how many happenings the copy and the phone hold and have stopped, and counts no occurrence"
)
func aCommitmentsScreenAskedToRestoreSaysHowManyHappeningsTheCopyAndThePhoneHoldAndHaveStoppedAndCountsNoOccurrence()
    throws
{
    let places = Places()
    let made = try makeHappenings(
        ["Augenmigräne", "Kopfweh", "Schlecht geschlafen"], at: places.happenings)
    try HappeningStore(at: places.happenings).stop(made[2])
    for _ in 1...3 {
        try note(made[1], on: date(2026, 10, 2), at: nil, at: places.happenings)
    }
    let screen = places.commitmentsScreen()
    let file = try copyPicked(madeThrough: screen)

    delete(made[0], through: screen)
    stop(made[1], through: screen)
    let bytesBefore = try Data(contentsOf: places.happenings)

    #expect(screen.askToRestore(from: file) == nil)

    let awaiting = try #require(screen.awaitingRestore)
    #expect(awaiting.copy.happenings == 2)
    #expect(awaiting.copy.stoppedHappenings == 1)
    #expect(awaiting.phone.happenings == 0)
    #expect(awaiting.phone.stoppedHappenings == 2)
    #expect(awaiting.unreadable.isEmpty)
    #expect(try Data(contentsOf: places.happenings) == bytesBefore)
}

@MainActor
@Test(
    "a commitments screen asked to restore where the happening place cannot be read says the happenings cannot be read in place of their counts"
)
func aCommitmentsScreenAskedToRestoreWhereTheHappeningPlaceCannotBeReadSaysTheHappeningsCannotBeReadInPlaceOfTheirCounts()
    throws
{
    for unreadable in [notAHappeningStore, laterHappeningBytes()] {
        let places = Places()
        let screen = places.commitmentsScreen()
        let file = try copyPicked(madeThrough: screen)
        try write(unreadable, to: places.happenings)

        #expect(screen.askToRestore(from: file) == nil)

        let awaiting = try #require(screen.awaitingRestore)
        #expect(awaiting.unreadable == [.happenings])
        #expect(awaiting.phone.happenings == nil)
        #expect(awaiting.phone.stoppedHappenings == nil)
        #expect(awaiting.phone.kept == 0)
        #expect(awaiting.phone.stopped == 0)
        #expect(awaiting.phone.oneOffs == 0)
        #expect(awaiting.copy.happenings == 0)
        #expect(awaiting.copy.stoppedHappenings == 0)
    }
}

@MainActor
@Test(
    "a restore confirmed makes the happening place hold the copy's happenings, and the happenings there are gone"
)
func aRestoreConfirmedMakesTheHappeningPlaceHoldTheCopysHappeningsAndTheHappeningsThereAreGone()
    throws
{
    let places = Places()
    let kopfweh = try makeHappenings(["Kopfweh"], at: places.happenings)[0]
    try note(kopfweh, on: date(2026, 10, 2), at: time(9, 10), at: places.happenings)

    // What a happening store writes for that happening and that occurrence, and nothing else.
    let expectedPlace = Places().happenings
    try HappeningStore(at: expectedPlace).add(kopfweh)
    try note(kopfweh, on: date(2026, 10, 2), at: time(9, 10), at: expectedPlace)
    let expected = try Data(contentsOf: expectedPlace)

    let screen = places.commitmentsScreen()
    let file = try copyPicked(madeThrough: screen)
    #expect(screen.rename(kopfweh, to: "Spannungskopfweh") == nil)
    #expect(screen.makeHappening(named: "Augenmigräne") == nil)

    #expect(screen.askToRestore(from: file) == nil)
    #expect(screen.confirmRestoring() == nil)

    #expect(try Data(contentsOf: places.happenings) == expected)

    // The same where what stood at the happening place could not be read.
    let unreadablePlaces = Places()
    let unreadableScreen = unreadablePlaces.commitmentsScreen()
    try HappeningStore(at: unreadablePlaces.happenings).add(kopfweh)
    try note(kopfweh, on: date(2026, 10, 2), at: time(9, 10), at: unreadablePlaces.happenings)
    let unreadableFile = try copyPicked(madeThrough: unreadableScreen)
    try write(notAHappeningStore, to: unreadablePlaces.happenings)

    #expect(unreadableScreen.askToRestore(from: unreadableFile) == nil)
    #expect(unreadableScreen.confirmRestoring() == nil)
    #expect(try Data(contentsOf: unreadablePlaces.happenings) == expected)
}

@MainActor
@Test(
    "a commitments screen that restored a copy lists the copy's happenings, and no happening is awaiting a stop or a deletion"
)
func aCommitmentsScreenThatRestoredACopyListsTheCopysHappeningsAndNoHappeningIsAwaitingAStopOrADeletion()
    throws
{
    /// What the scenario does before the restore, answered with the screen and the happenings.
    func preparedScreen(
        at places: Places
    ) throws -> (screen: CommitmentsScreen, made: [Happening], file: URL) {
        let made = try makeHappenings(["Augenmigräne", "Kopfweh"], at: places.happenings)
        try HappeningStore(at: places.happenings).stop(made[1])
        let screen = places.commitmentsScreen()
        let file = try copyPicked(madeThrough: screen)
        delete(made[0], through: screen)
        #expect(screen.resume(made[1]) == nil)
        return (screen, made, file)
    }

    let places = Places()
    let prepared = try preparedScreen(at: places)
    let screen = prepared.screen
    // A day screen of no commitments, opened before the restore, holding "Kopfweh" alone.
    let dayScreen = places.dayScreen()
    #expect(dayScreen.happenings.map(\.name) == ["Kopfweh"])
    screen.askToDelete(prepared.made[1])
    screen.happeningNameTypedBack = "Kopfweh"

    #expect(screen.askToRestore(from: prepared.file) == nil)
    #expect(screen.confirmRestoring() == nil)

    #expect(screen.happenings.map(\.name) == ["Augenmigräne", "Kopfweh"])
    #expect(!screen.isStopped(prepared.made[0]))
    #expect(screen.isStopped(prepared.made[1]))
    #expect(screen.happeningState == .kept)
    #expect(screen.happeningAwaitingStop == nil)
    #expect(screen.happeningAwaitingDeletion == nil)
    #expect(screen.happeningNameTypedBack == "")

    dayScreen.returnedTo(from: screen)
    #expect(dayScreen.happenings.map(\.name) == ["Augenmigräne"])

    // A screen asked to stop, rather than to delete, has nothing awaiting a stop afterwards.
    let stopPlaces = Places()
    let stopPrepared = try preparedScreen(at: stopPlaces)
    stopPrepared.screen.askToStop(stopPrepared.made[1])
    #expect(stopPrepared.screen.happeningAwaitingStop == stopPrepared.made[1])
    #expect(stopPrepared.screen.askToRestore(from: stopPrepared.file) == nil)
    #expect(stopPrepared.screen.confirmRestoring() == nil)
    #expect(stopPrepared.screen.happeningAwaitingStop == nil)

    // The same where what stood at the happening place could not be read at the restore.
    let unreadablePlaces = Places()
    let unreadablePrepared = try preparedScreen(at: unreadablePlaces)
    try write(notAHappeningStore, to: unreadablePlaces.happenings)
    #expect(unreadablePrepared.screen.askToRestore(from: unreadablePrepared.file) == nil)
    #expect(unreadablePrepared.screen.confirmRestoring() == nil)
    #expect(unreadablePrepared.screen.happenings.map(\.name) == ["Augenmigräne", "Kopfweh"])
    #expect(unreadablePrepared.screen.happeningState == .kept)
}

/// A path that cannot be written: `name` beneath an ordinary file, so any write through it fails.
private func blockedPlace(named name: String) throws -> URL {
    let directory = freshDirectory()
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let blocker = directory.appendingPathComponent("blocker")
    try Data().write(to: blocker)
    return blocker.appendingPathComponent(name)
}

private let journaling = Commitment(
    name: "Journaling", schedule: allWeekdays, keptFrom: date(2026, 1, 1))!

/// A file holding a copy of a roster of "Journaling" and a happening named "Kopfweh", and the
/// happening it holds.
@MainActor
private func journalingAndKopfwehCopy() throws -> (file: URL, kopfweh: Happening) {
    let source = Places()
    try RosterStore(at: source.roster).add(journaling)
    let kopfweh = try makeHappenings(["Kopfweh"], at: source.happenings)[0]
    let result = source.commitmentsScreen().makeACopy(
        asOf: moment(14, 32), writingInto: freshDirectory())
    guard case .success(let url) = result else {
        Issue.record("expected a copy to be made")
        throw CocoaError(.fileWriteUnknown)
    }
    return (url, kopfweh)
}

@MainActor
@Test("a restore refused where the happening place cannot be written leaves the five places as they were")
func aRestoreRefusedWhereTheHappeningPlaceCannotBeWrittenLeavesTheFivePlacesAsTheyWere() throws {
    let base = freshDirectory()
    let roster = base.appendingPathComponent("roster.json")
    let record = base.appendingPathComponent("record.json")
    let oneOffs = base.appendingPathComponent("one-offs.json")
    let birthday = base.appendingPathComponent("birthday-ticks.json")
    let happenings = try blockedPlace(named: "happenings.json")

    try RosterStore(at: roster).add(gym)
    try RecordStore(at: record).add(Tick(gym, on: date(2026, 10, 2))!)
    try OneOffStore(at: oneOffs).add(OneOff(name: "Book dentist", date: date(2026, 10, 25))!)
    let screen = CommitmentsScreen(
        asOf: saturday, keepingRosterAt: roster, keepingRecordAt: record, keepingOneOffsAt: oneOffs,
        keepingBirthdayTicksAt: birthday, keepingHappeningsAt: happenings)
    let rosterBefore = try Data(contentsOf: roster)
    let recordBefore = try Data(contentsOf: record)
    let oneOffsBefore = try Data(contentsOf: oneOffs)

    #expect(screen.askToRestore(from: try journalingAndKopfwehCopy().file) == nil)
    let refusal = screen.confirmRestoring()

    #expect(refusal == .notKept)
    #expect(try Data(contentsOf: roster) == rosterBefore)
    #expect(try Data(contentsOf: record) == recordBefore)
    #expect(try Data(contentsOf: oneOffs) == oneOffsBefore)
    #expect(!FileManager.default.fileExists(atPath: birthday.path))
    #expect(!FileManager.default.fileExists(atPath: happenings.path))
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.happenings.isEmpty)
    #expect(screen.copyRestored == nil)
    #expect(screen.awaitingRestore == nil)
}

@MainActor
@Test(
    "a restore stopped before it was whole is undone at the happening place when the places are next opened"
)
func aRestoreStoppedBeforeItWasWholeIsUndoneAtTheHappeningPlaceWhenThePlacesAreNextOpened() throws {
    /// Places holding "Gym" and "Kopfweh", and a restore of "Journaling" and "Augenmigräne" left
    /// having written all five, with the restore in progress it left standing.
    func placesWithATornRestore(
        beforeTheRestore opened: (Places) throws -> Void = { _ in }
    ) throws -> (places: Places, rosterBefore: Data, happeningsBefore: Data) {
        let places = Places()
        try RosterStore(at: places.roster).add(gym)
        try makeHappenings(["Kopfweh"], at: places.happenings)
        let rosterBefore = try Data(contentsOf: places.roster)
        let happeningsBefore = try Data(contentsOf: places.happenings)
        try opened(places)

        var roster = Roster()
        _ = roster.add(journaling)
        var happenings = Happenings()
        _ = happenings.add(try #require(Happening(name: "Augenmigräne")))
        let copy = Copy(
            moment: moment(9, 0), history: History(), roster: roster, oneOffs: OneOffs(),
            happenings: happenings)
        try RestoreInProgress.restore(
            copy, recordAt: places.record, rosterAt: places.roster, oneOffsAt: places.oneOffs,
            birthdayTicksAt: places.birthday, happeningsAt: places.happenings, stoppingAfter: 5)
        #expect(
            FileManager.default.fileExists(
                atPath: RestoreInProgress.place(besideRecordAt: places.record).path))
        return (places, rosterBefore, happeningsBefore)
    }

    let torn = try placesWithATornRestore()
    let screen = torn.places.commitmentsScreen()

    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.happenings.map(\.name) == ["Kopfweh"])
    #expect(try Data(contentsOf: torn.places.roster) == torn.rosterBefore)
    #expect(try Data(contentsOf: torn.places.happenings) == torn.happeningsBefore)
    #expect(!FileManager.default.fileExists(atPath: torn.places.record.path))
    #expect(!FileManager.default.fileExists(atPath: torn.places.oneOffs.path))
    #expect(!FileManager.default.fileExists(atPath: torn.places.birthday.path))
    #expect(
        !FileManager.default.fileExists(
            atPath: RestoreInProgress.place(besideRecordAt: torn.places.record).path))

    // A day screen of no commitments at all opened at those places instead lists "Kopfweh" alone.
    let instead = try placesWithATornRestore()
    #expect(instead.places.dayScreen().happenings.map(\.name) == ["Kopfweh"])

    // And so does one opened before that restore was left, and returned to after.
    var openedBefore: DayScreen?
    let after = try placesWithATornRestore { places in
        openedBefore = places.dayScreen()
    }
    let returned = try #require(openedBefore)
    returned.returnedTo()
    #expect(returned.happenings.map(\.name) == ["Kopfweh"])
    #expect(try Data(contentsOf: after.places.happenings) == after.happeningsBefore)

    // A restore in progress kept before restores wrote the happening place leaves it as it stands.
    let old = Places()
    try RosterStore(at: old.roster).add(gym)
    try makeHappenings(["Kopfweh"], at: old.happenings)
    let oldHappeningsBefore = try Data(contentsOf: old.happenings)
    let oldRosterBefore = try Data(contentsOf: old.roster)
    let oldSnapshot = RestoreInProgress(
        record: nil, roster: oldRosterBefore, oneOffs: nil, saveInProgress: nil,
        birthdayTicks: nil)
    let oldSnapshotPlace = RestoreInProgress.place(besideRecordAt: old.record)
    try write(JSONEncoder().encode(oldSnapshot), to: oldSnapshotPlace)
    try RosterStore(at: old.roster).add(journaling)

    let oldScreen = old.commitmentsScreen()

    #expect(oldScreen.kept.map(\.name) == ["Gym"])
    #expect(try Data(contentsOf: old.happenings) == oldHappeningsBefore)
    #expect(!FileManager.default.fileExists(atPath: oldSnapshotPlace.path))
}

/// The happenings the copy standing at `directory` holds.
@MainActor
private func happeningsCopied(at directory: URL) throws -> Happenings {
    try copyHeld(at: directory.appendingPathComponent(CopyPlace.fileName)).happenings
}

@MainActor
@Test(
    "a happening made, renamed, stopped, resumed and deleted through a commitments screen each write a copy at the copy place"
)
func aHappeningMadeRenamedStoppedResumedAndDeletedThroughACommitmentsScreenEachWriteACopyAtTheCopyPlace()
    throws
{
    let places = Places()
    let copyPlace = places.copyPlace(asking: laterMinuteEachTime(from: moment(14, 32)))
    let screen = places.commitmentsScreen(copyingTo: copyPlace)
    let directory = freshDirectory()
    screen.givenAsCopyPlace(directory)

    func heldInStep(_ step: String) throws -> Happenings {
        let kept = try HappeningStore(at: places.happenings).happenings
        let copied = try happeningsCopied(at: directory)
        #expect(copied == kept, "after \(step)")
        return copied
    }

    #expect(screen.makeHappening(named: "Kopfweh") == nil)
    let made = try heldInStep("making")
    let kopfweh = try #require(made.all.first)

    #expect(screen.rename(kopfweh, to: "Spannungskopfweh") == nil)
    #expect(try heldInStep("renaming").all.map(\.name) == ["Spannungskopfweh"])

    screen.askToStop(kopfweh)
    #expect(screen.confirmStoppingHappening() == nil)
    #expect(try heldInStep("stopping").isStopped(kopfweh))

    #expect(screen.resume(kopfweh) == nil)
    #expect(!(try heldInStep("resuming").isStopped(kopfweh)))

    delete(try #require(screen.happenings.first), through: screen)
    #expect(try heldInStep("deleting").all.isEmpty)

    #expect(copyPlace.lastCopy == moment(14, 37))
}

@MainActor
@Test(
    "an occurrence noted, changed and taken back on a day screen each write a copy at the copy place"
)
func anOccurrenceNotedChangedAndTakenBackOnADayScreenEachWriteACopyAtTheCopyPlace() throws {
    let places = Places()
    let kopfweh = try makeHappenings(["Kopfweh"], at: places.happenings)[0]
    let copyPlace = places.copyPlace(asking: laterMinuteEachTime(from: moment(14, 32)))
    let dayScreen = places.dayScreen(copyingTo: copyPlace)
    let directory = freshDirectory()
    places.commitmentsScreen(copyingTo: copyPlace).givenAsCopyPlace(directory)
    let now = moment(18, 52)

    #expect(dayScreen.note(kopfweh, at: time(9, 10), saying: "links", asOf: now) == nil)
    #expect(
        try happeningsCopied(at: directory).occurrences == [
            Occurrence(of: kopfweh, on: saturday, at: time(9, 10), saying: "links")
        ])

    let noted = try #require(try happeningsCopied(at: directory).occurrences.first)
    #expect(dayScreen.change(noted, to: time(8, 0), saying: "", asOf: now) == nil)
    #expect(
        try happeningsCopied(at: directory).occurrences == [
            Occurrence(of: kopfweh, on: saturday, at: time(8, 0), saying: nil)
        ])

    let changed = try #require(try happeningsCopied(at: directory).occurrences.first)
    #expect(dayScreen.takeBack(changed) == nil)
    #expect(try happeningsCopied(at: directory).occurrences.isEmpty)
    #expect(copyPlace.lastCopy == moment(14, 35))
}

@MainActor
@Test("a happening change refused, or one that asks for no change, writes no copy at the copy place")
func aHappeningChangeRefusedOrOneThatAsksForNoChangeWritesNoCopyAtTheCopyPlace() throws {
    let places = Places()
    let kopfweh = try makeHappenings(["Kopfweh"], at: places.happenings)[0]
    try note(kopfweh, on: date(2026, 10, 2), at: time(9, 10), at: places.happenings)
    let copyPlace = places.copyPlace(asking: laterMinuteEachTime(from: moment(14, 32)))
    let screen = places.commitmentsScreen(copyingTo: copyPlace)
    screen.givenAsCopyPlace(freshDirectory())
    #expect(copyPlace.lastCopy == moment(14, 32))

    #expect(screen.makeHappening(named: "kopfweh") != nil)
    #expect(screen.rename(kopfweh, to: " Kopfweh ") == nil)
    screen.askToStop(kopfweh)
    screen.cancelStoppingHappening()
    screen.askToDelete(kopfweh)
    screen.happeningNameTypedBack = "Kopfweh"
    screen.cancelDeletingHappening()

    #expect(copyPlace.lastCopy == moment(14, 32))
    #expect(copyPlace.stopped == nil)

    let dayScreen = places.dayScreen(copyingTo: copyPlace)
    #expect(
        dayScreen.note(kopfweh, at: time(18, 53), saying: "", asOf: moment(18, 52))
            == .notYetCome)
    #expect(copyPlace.lastCopy == moment(14, 32))

    let occurrence = try #require(
        try HappeningStore(at: places.happenings).happenings.occurrences.first)
    #expect(dayScreen.change(occurrence, to: time(9, 10), saying: "", asOf: moment(18, 52)) == nil)
    #expect(copyPlace.lastCopy == moment(14, 32))
}

@MainActor
@Test("an occurrence noted where the copy place cannot be written is kept and is not refused")
func anOccurrenceNotedWhereTheCopyPlaceCannotBeWrittenIsKeptAndIsNotRefused() throws {
    let places = Places()
    let kopfweh = try makeHappenings(["Kopfweh"], at: places.happenings)[0]
    let copyPlace = places.copyPlace(asking: laterMinuteEachTime(from: moment(14, 32)))
    let dayScreen = places.dayScreen(copyingTo: copyPlace)
    let screen = places.commitmentsScreen(copyingTo: copyPlace)

    let directory = freshDirectory()
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    try FileManager.default.setAttributes(
        [.posixPermissions: 0o500], ofItemAtPath: directory.path)
    defer {
        try? FileManager.default.setAttributes(
            [.posixPermissions: 0o700], ofItemAtPath: directory.path)
    }
    screen.givenAsCopyPlace(directory)

    #expect(dayScreen.note(kopfweh, at: time(9, 10), saying: "", asOf: moment(18, 52)) == nil)
    #expect(try HappeningStore(at: places.happenings).happenings.occurrences.count == 1)
    #expect(
        copyPlace.stopped
            == CopyPlace.Stopped(stop: .folderCannotBeWritten, since: moment(14, 32)))

    #expect(screen.makeHappening(named: "Augenmigräne") == nil)
    #expect(
        copyPlace.stopped
            == CopyPlace.Stopped(stop: .folderCannotBeWritten, since: moment(14, 32)))
}

@MainActor
@Test("a take-out hands out the file at the happening place byte-for-byte under the name it lies under")
func aTakeOutHandsOutTheFileAtTheHappeningPlaceByteForByteUnderTheNameItLiesUnder() throws {
    let places = Places()
    let kopfweh = try makeHappenings(["Kopfweh"], at: places.happenings)[0]
    try note(kopfweh, on: date(2026, 10, 2), at: time(9, 10), at: places.happenings)
    try write(Data("not a record".utf8), to: places.record)
    let screen = places.commitmentsScreen()

    let result = screen.takeOut(writingInto: freshDirectory())

    guard case .success(let urls) = result else {
        Issue.record("expected a take-out to be made")
        return
    }
    #expect(urls.map(\.lastPathComponent).sorted() == ["happenings.json", "record.json"])
    let handed = try #require(urls.first { $0.lastPathComponent == "happenings.json" })
    #expect(try Data(contentsOf: handed) == Data(contentsOf: places.happenings))
}

@MainActor
@Test(
    "a commitments screen offers a take-out over happenings that cannot be read, naming them after the birthday ticks"
)
func aCommitmentsScreenOffersATakeOutOverHappeningsThatCannotBeReadNamingThemAfterTheBirthdayTicks()
    throws
{
    let places = Places()
    try write(notAHappeningStore, to: places.happenings)
    let screen = places.commitmentsScreen()

    #expect(screen.offersATakeOut)
    #expect(
        screen.storesNotRead
            == [CommitmentsScreen.StoreNotRead(store: .happenings, cause: .couldNotBeRead)])

    let both = Places()
    try write(notAHappeningStore, to: both.happenings)
    try write(Data("not what birthday ticks are written as".utf8), to: both.birthday)
    #expect(
        both.commitmentsScreen().storesNotRead
            == [
                CommitmentsScreen.StoreNotRead(store: .birthdayTicks, cause: .couldNotBeRead),
                CommitmentsScreen.StoreNotRead(store: .happenings, cause: .couldNotBeRead),
            ])

    let later = Places()
    try write(laterHappeningBytes(), to: later.happenings)
    let laterScreen = later.commitmentsScreen()
    #expect(laterScreen.offersATakeOut)
    #expect(
        laterScreen.storesNotRead
            == [CommitmentsScreen.StoreNotRead(store: .happenings, cause: .writtenByALaterVersion)])

    // A restore in progress that could not be undone names the first three alone where the
    // happening place holds "Kopfweh", and the happenings after them where it holds bytes.
    func notRead(whereTheHappeningPlaceHolds bytes: Data?) throws -> [CommitmentsScreen.StoreNotRead] {
        let stuck = Places()
        try RosterStore(at: stuck.roster).add(gym)
        if let bytes {
            try write(bytes, to: stuck.happenings)
        } else {
            try makeHappenings(["Kopfweh"], at: stuck.happenings)
        }
        try write(
            Data("not a restore in progress".utf8),
            to: RestoreInProgress.place(besideRecordAt: stuck.record))
        return stuck.commitmentsScreen().storesNotRead
    }
    #expect(
        try notRead(whereTheHappeningPlaceHolds: nil)
            == [
                CommitmentsScreen.StoreNotRead(store: .record, cause: .couldNotBeRead),
                CommitmentsScreen.StoreNotRead(store: .roster, cause: .couldNotBeRead),
                CommitmentsScreen.StoreNotRead(store: .oneOffs, cause: .couldNotBeRead),
            ])
    #expect(
        try notRead(whereTheHappeningPlaceHolds: notAHappeningStore)
            == [
                CommitmentsScreen.StoreNotRead(store: .record, cause: .couldNotBeRead),
                CommitmentsScreen.StoreNotRead(store: .roster, cause: .couldNotBeRead),
                CommitmentsScreen.StoreNotRead(store: .oneOffs, cause: .couldNotBeRead),
                CommitmentsScreen.StoreNotRead(store: .happenings, cause: .couldNotBeRead),
            ])
}

@MainActor
@Test("a commitments screen that cannot erase a removed commitment's records names the happenings it cannot read too")
func aCommitmentsScreenThatCannotEraseARemovedCommitmentsRecordsNamesTheHappeningsItCannotReadToo()
    throws
{
    // `readPlaces` rebuilds `storesNotRead` by hand once the erase the migration owes at open
    // fails; the happenings must not be dropped by that rebuild.
    let places = Places()
    let gymIdentity = "11111111-1111-1111-1111-111111111111"
    let days = #"["monday","tuesday","wednesday","thursday","friday","saturday","sunday"]"#
    try write(
        Data(
            """
            {"version":5,"commitments":[{"commitment":{"name":"Gym",\
            "keptFrom":{"year":2026,"month":1,"day":1},"schedule":{"weekdays":\(days)},\
            "identity":"\(gymIdentity)"},"keptUntil":{"year":2026,"month":8,"day":30},\
            "removed":true,"category":null}]}
            """.utf8), to: places.roster)
    let removed = Commitment(
        identity: Commitment.Identity(gymIdentity)!, name: "Gym", schedule: allWeekdays,
        keptFrom: date(2026, 1, 1), kind: .tick)!
    let recordDirectory = freshDirectory()
    let record = recordDirectory.appendingPathComponent("record.json")
    try RecordStore(at: record).add(Tick(removed, on: date(2026, 8, 3))!)
    try FileManager.default.setAttributes(
        [.posixPermissions: 0o500], ofItemAtPath: recordDirectory.path)
    defer {
        try? FileManager.default.setAttributes(
            [.posixPermissions: 0o700], ofItemAtPath: recordDirectory.path)
    }
    try write(notAHappeningStore, to: places.happenings)

    let screen = CommitmentsScreen(
        asOf: saturday, keepingRosterAt: places.roster, keepingRecordAt: record,
        keepingOneOffsAt: places.oneOffs, keepingBirthdayTicksAt: places.birthday,
        keepingHappeningsAt: places.happenings)

    #expect(
        screen.storesNotRead == [
            CommitmentsScreen.StoreNotRead(store: .roster, cause: .couldNotBeRead),
            CommitmentsScreen.StoreNotRead(store: .happenings, cause: .couldNotBeRead),
        ])
}

private let kate = Birthday(
    contact: "kate", words: "Kate Bell's 48th Birthday", day: date(2026, 9, 25))!

@MainActor
@Test(
    "a commitments screen asked for a take-out answers the happenings' file after the birthday ticks' and before a save in progress"
)
func aCommitmentsScreenAskedForATakeOutAnswersTheHappeningsFileAfterTheBirthdayTicksAndBeforeASaveInProgress()
    throws
{
    let places = Places()
    try RosterStore(at: places.roster).add(gym)
    try BirthdayStore(at: places.birthday).tick(kate)
    try makeHappenings(["Kopfweh"], at: places.happenings)
    try write(
        Data("not a save in progress".utf8),
        to: SaveInProgress.place(besideRecordAt: places.record))
    let screen = places.commitmentsScreen()

    let result = screen.takeOut(writingInto: freshDirectory())

    guard case .success(let urls) = result else {
        Issue.record("expected a take-out to be made")
        return
    }
    #expect(
        urls.map(\.lastPathComponent)
            == ["roster.json", "birthday-ticks.json", "happenings.json", "save-in-progress.json"])
    let directory = try #require(urls.first).deletingLastPathComponent()
    #expect(
        Set(try FileManager.default.contentsOfDirectory(atPath: directory.path))
            == Set(urls.map(\.lastPathComponent)))
}

@MainActor
@Test("a take-out refused over the happening place names the happenings and hands out none of the others")
func aTakeOutRefusedOverTheHappeningPlaceNamesTheHappeningsAndHandsOutNoneOfTheOthers() throws {
    let places = Places()
    try write(Data("not a roster".utf8), to: places.roster)
    let rosterBytes = try Data(contentsOf: places.roster)
    try FileManager.default.createDirectory(
        at: places.happenings, withIntermediateDirectories: true)
    let screen = places.commitmentsScreen()
    let directory = freshDirectory()

    let result = screen.takeOut(writingInto: directory)

    guard case .failure(let refusal) = result else {
        Issue.record("expected a take-out to be refused")
        return
    }
    #expect(refusal == .storeCouldNotBeRead)
    #expect(screen.refusedChange == .takingOut(.happenings, .storeCouldNotBeRead))
    if FileManager.default.fileExists(atPath: directory.path) {
        #expect(try FileManager.default.contentsOfDirectory(atPath: directory.path).isEmpty)
    }
    #expect(try Data(contentsOf: places.roster) == rosterBytes)
    var isDirectory: ObjCBool = false
    #expect(FileManager.default.fileExists(atPath: places.happenings.path, isDirectory: &isDirectory))
    #expect(isDirectory.boolValue)
}

@MainActor
@Test(
    "a day screen that cannot read its happenings says a copy can be restored, and says nothing of it where they were written by a later version"
)
func aDayScreenThatCannotReadItsHappeningsSaysACopyCanBeRestoredAndSaysNothingOfItWhereTheyWereWrittenByALaterVersion()
    throws
{
    let places = Places()
    try write(notAHappeningStore, to: places.happenings)
    let screen = places.dayScreen()

    #expect(screen.happeningState == .notKept)
    #expect(screen.saysACopyCanBeRestored)

    // With the record place unreadable too, it says so once and no more: one flag, already true.
    let both = Places()
    try write(notAHappeningStore, to: both.happenings)
    try write(Data("not a record".utf8), to: both.record)
    #expect(both.dayScreen().saysACopyCanBeRestored)

    let later = Places()
    try write(laterHappeningBytes(), to: later.happenings)
    let laterScreen = later.dayScreen()
    #expect(laterScreen.happeningState == .writtenByALaterVersion)
    #expect(!laterScreen.saysACopyCanBeRestored)
}
