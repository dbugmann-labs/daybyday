import Foundation
import Testing

@testable import DayByDayKit

private func date(_ year: Int, _ month: Int, _ day: Int) -> CalendarDate {
    CalendarDate(year: year, month: month, day: day)!
}

private let tuesday = date(2026, 10, 13)

private func moment(_ hour: Int, _ minute: Int, on day: CalendarDate = tuesday) -> Moment {
    Moment(on: day, hour: hour, minute: minute)!
}

/// A fresh roster, record, one-off, birthday, happening and present-idea place, six sibling files
/// under one fresh temporary directory. Nothing is created until something writes to one of them.
private struct Places {
    let roster: URL
    let record: URL
    let oneOffs: URL
    let birthday: URL
    let happenings: URL
    let presentIdeas: URL

    init() {
        let base = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        roster = base.appendingPathComponent("roster.json")
        record = base.appendingPathComponent("record.json")
        oneOffs = base.appendingPathComponent("one-offs.json")
        birthday = base.appendingPathComponent("birthday-ticks.json")
        happenings = base.appendingPathComponent("happenings.json")
        presentIdeas = base.appendingPathComponent("present-ideas.json")
    }

    @MainActor
    func commitmentsScreen(
        asOf day: CalendarDate = tuesday, whileOn birthdaySwitch: BirthdaySwitch? = nil,
        copyingTo copyPlace: CopyPlace? = nil
    ) -> CommitmentsScreen {
        CommitmentsScreen(
            asOf: day, keepingRosterAt: roster, keepingRecordAt: record, keepingOneOffsAt: oneOffs,
            keepingBirthdayTicksAt: birthday, keepingHappeningsAt: happenings,
            keepingPresentIdeasAt: presentIdeas, whileOn: birthdaySwitch, copyingTo: copyPlace)
    }
}

/// A fresh directory of its own for a copy or a take-out to be written into.
private func freshDirectory() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
}

/// A birthday switch that is off: the phone has never been asked.
@MainActor
private func offSwitch() -> BirthdaySwitch {
    BirthdaySwitch(
        at: freshDirectory().appendingPathComponent("birthday-switch.json"),
        readingAccess: { .notAsked }, askingForAccess: {})
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

private func idea(_ text: String, link: String = "") -> PresentIdea {
    try! PresentIdea(text: text, link: link)
}

@MainActor
@Test(
    "a copy holds every present idea the present-idea place holds, given or not, and none where nothing has been kept there"
)
func aCopyHoldsEveryPresentIdeaThePresentIdeaPlaceHoldsGivenOrNotAndNoneWhereNothingHasBeenKeptThere()
    throws
{
    let places = Places()
    let store = try PresentIdeaStore(at: places.presentIdeas)
    try store.add(idea("Ceramics class voucher"), to: "kate")
    try store.add(idea("Hiking socks, size 38", link: "https://bergzeit.ch/socks"), to: "kate")
    try store.mark(0, of: "kate", given: true)
    try store.add(idea("Book voucher"), to: "anna")

    let screen = places.commitmentsScreen(whileOn: offSwitch())
    let bytesBefore = try Data(contentsOf: places.presentIdeas)

    let result = screen.makeACopy(asOf: moment(14, 32), writingInto: freshDirectory())

    guard case .success(let url) = result else {
        Issue.record("expected a copy to be made")
        return
    }
    let copy = try copyHeld(at: url)
    #expect(Set(copy.presentIdeas.keys) == ["kate", "anna"])
    #expect(
        copy.presentIdeas["kate"] == [
            try PresentIdea(text: "Ceramics class voucher", link: "").marked(given: true),
            try PresentIdea(text: "Hiking socks, size 38", link: "https://bergzeit.ch/socks"),
        ])
    #expect(copy.presentIdeas["anna"] == [idea("Book voucher")])
    #expect(try Data(contentsOf: places.presentIdeas) == bytesBefore)

    let empty = Places()
    let emptyResult = empty.commitmentsScreen(whileOn: offSwitch()).makeACopy(
        asOf: moment(14, 32), writingInto: freshDirectory())
    guard case .success(let emptyURL) = emptyResult else {
        Issue.record("expected a copy to be made")
        return
    }
    #expect(try copyHeld(at: emptyURL).presentIdeas.isEmpty)
    #expect(!FileManager.default.fileExists(atPath: empty.presentIdeas.path))
}

private let allWeekdays: Schedule = .weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])

private let gym = Commitment(
    name: "Gym", schedule: allWeekdays, keptFrom: date(2026, 1, 1))!

private let notAPresentIdeaStore = Data("not what present ideas are written as".utf8)

/// The bytes of a present-idea store written in the form one later than this app writes.
private func laterPresentIdeaBytes() -> Data {
    Data(#"{"version":\#(PresentIdeaDocument.currentVersion + 1),"contacts":[]}"#.utf8)
}

private func write(_ bytes: Data, to place: URL) throws {
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try bytes.write(to: place)
}

@MainActor
@Test(
    "a copy is refused whole where the present ideas cannot be read, naming them only where the other five stores read"
)
func aCopyIsRefusedWholeWhereThePresentIdeasCannotBeReadNamingThemOnlyWhereTheOtherFiveStoresRead()
    throws
{
    let places = Places()
    try RosterStore(at: places.roster).add(gym)
    try write(notAPresentIdeaStore, to: places.presentIdeas)
    let screen = places.commitmentsScreen()
    let directory = freshDirectory()

    let result = screen.makeACopy(asOf: moment(14, 32), writingInto: directory)

    guard case .failure(let refusal) = result else {
        Issue.record("expected a copy to be refused")
        return
    }
    #expect(refusal == .storeCouldNotBeRead)
    #expect(screen.refusedChange == .makingACopy(.presentIdeas, .storeCouldNotBeRead))
    #expect(!FileManager.default.fileExists(atPath: directory.path))
    #expect(try Data(contentsOf: places.presentIdeas) == notAPresentIdeaStore)

    // The same through a screen handed a birthday switch that is off.
    let withSwitch = places.commitmentsScreen(whileOn: offSwitch())
    let switched = withSwitch.makeACopy(asOf: moment(14, 32), writingInto: directory)
    guard case .failure(let switchedRefusal) = switched else {
        Issue.record("expected a copy to be refused")
        return
    }
    #expect(switchedRefusal == .storeCouldNotBeRead)
    #expect(withSwitch.refusedChange == .makingACopy(.presentIdeas, .storeCouldNotBeRead))

    // A present-idea store of the form one later than this app writes.
    try write(laterPresentIdeaBytes(), to: places.presentIdeas)
    let later = screen.makeACopy(asOf: moment(14, 32), writingInto: directory)
    guard case .failure(let laterRefusal) = later else {
        Issue.record("expected a copy to be refused")
        return
    }
    #expect(laterRefusal == .storeWrittenByALaterVersion)
    #expect(screen.refusedChange == .makingACopy(.presentIdeas, .storeWrittenByALaterVersion))

    // The happening place unreadable too is named, not the present ideas.
    try write(Data("not what happenings are written as".utf8), to: places.happenings)
    let both = screen.makeACopy(asOf: moment(14, 32), writingInto: directory)
    guard case .failure(let bothRefusal) = both else {
        Issue.record("expected a copy to be refused")
        return
    }
    #expect(bothRefusal == .storeCouldNotBeRead)
    #expect(screen.refusedChange == .makingACopy(.happenings, .storeCouldNotBeRead))
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
    fileprivate func copyPlace(
        at state: URL = freshCopyPlaceState(), asking clock: @escaping @Sendable () -> Moment?
    ) -> CopyPlace {
        CopyPlace(
            at: state, keepingRecordAt: record, keepingRosterAt: roster,
            keepingOneOffsAt: oneOffs, keepingBirthdayTicksAt: birthday,
            keepingHappeningsAt: happenings, keepingPresentIdeasAt: presentIdeas, asking: clock)
    }

    @MainActor
    fileprivate func dayScreen(
        asOf day: CalendarDate = tuesday, copyingTo copyPlace: CopyPlace? = nil
    ) -> DayScreen {
        DayScreen(
            startingFrom: [], asOf: day, keepingRecordAt: record, keepingRosterAt: roster,
            keepingOneOffsAt: oneOffs, keepingBirthdayTicksAt: birthday,
            keepingHappeningsAt: happenings, copyingTo: copyPlace)
    }
}

@MainActor
@Test(
    "a change kept where the present ideas cannot be read is kept, and the stop names the present ideas"
)
func aChangeKeptWhereThePresentIdeasCannotBeReadIsKeptAndTheStopNamesThePresentIdeas() throws {
    func stopAfterTickingWith(_ bytes: Data) throws -> (CopyPlace.Stopped?, CopyPlace.Stopped?) {
        let places = Places()
        try RosterStore(at: places.roster).add(gym)
        let state = freshCopyPlaceState()
        let copyPlace = places.copyPlace(at: state, asking: laterMinuteEachTime(from: moment(14, 32)))
        let dayScreen = places.dayScreen(copyingTo: copyPlace)
        places.commitmentsScreen(copyingTo: copyPlace).givenAsCopyPlace(freshDirectory())

        try write(bytes, to: places.presentIdeas)
        try dayScreen.tick(dayScreen.dayView.rows.first { $0.name == "Gym" }!)

        #expect(dayScreen.notice == nil)
        #expect(try RecordStore(at: places.record).history.isKept(gym, on: tuesday))
        let reopened = places.copyPlace(at: state, asking: { nil })
        return (copyPlace.stopped, reopened.stopped)
    }

    let unreadable = try stopAfterTickingWith(notAPresentIdeaStore)
    let stopped = CopyPlace.Stopped(stop: .storeCouldNotBeRead(.presentIdeas), since: moment(14, 33))
    #expect(unreadable.0 == stopped)
    #expect(unreadable.1 == stopped)

    let later = try stopAfterTickingWith(laterPresentIdeaBytes())
    let laterStopped = CopyPlace.Stopped(
        stop: .storeWrittenByALaterVersion(.presentIdeas), since: moment(14, 33))
    #expect(later.0 == laterStopped)
    #expect(later.1 == laterStopped)
}

@MainActor
@Test(
    "a copy place given no present-idea place copies the present ideas kept beside its record place"
)
func aCopyPlaceGivenNoPresentIdeaPlaceCopiesThePresentIdeasKeptBesideItsRecordPlace() throws {
    let base = freshDirectory()
    let record = base.appendingPathComponent("record.json")
    let roster = base.appendingPathComponent("roster.json")
    let oneOffs = base.appendingPathComponent("one-offs.json")
    try PresentIdeaStore(at: base.appendingPathComponent("present-ideas.json"))
        .add(idea("Book voucher"), to: "kate")

    let copyPlace = CopyPlace(
        at: freshCopyPlaceState(), keepingRecordAt: record, keepingRosterAt: roster,
        keepingOneOffsAt: oneOffs, asking: { moment(14, 32) })
    let screen = CommitmentsScreen(
        asOf: tuesday, keepingRosterAt: roster, keepingRecordAt: record,
        keepingOneOffsAt: oneOffs, copyingTo: copyPlace)
    let directory = freshDirectory()

    screen.givenAsCopyPlace(directory)

    let written = try copyHeld(at: directory.appendingPathComponent(CopyPlace.fileName))
    #expect(written.presentIdeas == ["kate": [idea("Book voucher")]])

    let result = screen.makeACopy(asOf: moment(14, 33), writingInto: freshDirectory())
    guard case .success(let url) = result else {
        Issue.record("expected a copy to be made")
        return
    }
    #expect(try copyHeld(at: url).presentIdeas == ["kate": [idea("Book voucher")]])

    #expect(
        DayScreen.presentIdeaPlace(besideRecordAt: DayScreen.recordPlace)
            == BirthdaysScreen.presentIdeaPlace)
}

/// `copy`, written as a copy was written in an earlier form: `version` lowered to `version` and
/// every key a later form added taken out.
private func earlierFormCopyBytes(_ copy: Copy, version: Int) throws -> Data {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys]
    var object =
        try JSONSerialization.jsonObject(with: encoder.encode(CopyDocument(copy)))
        as! [String: Any]
    object["version"] = version
    if version < 4 { object.removeValue(forKey: "presentIdeas") }
    if version < 3 { object.removeValue(forKey: "happenings") }
    if version < 2 { object.removeValue(forKey: "birthdayTicks") }
    return try JSONSerialization.data(withJSONObject: object, options: [.sortedKeys])
}

/// A place for a picked `.daybyday` file under a directory of its own, holding `bytes`.
private func pickedFile(holding bytes: Data) throws -> URL {
    let file = freshDirectory().appendingPathComponent("DayByDay 2026-10-13 09.07.daybyday")
    try write(bytes, to: file)
    return file
}

/// A copy of a roster of one commitment, "Gym", made at 09:07.
private func gymCopy() -> Copy {
    var roster = Roster()
    _ = roster.add(gym)
    return Copy(moment: moment(9, 7), history: History(), roster: roster, oneOffs: OneOffs())
}

@MainActor
@Test(
    "a copy made before copies held present ideas is read as holding none, and restoring it leaves the present-idea place holding none"
)
func aCopyMadeBeforeCopiesHeldPresentIdeasIsReadAsHoldingNoneAndRestoringItLeavesThePresentIdeaPlaceHoldingNone()
    throws
{
    func restoring(_ bytes: Data) throws {
        let places = Places()
        try PresentIdeaStore(at: places.presentIdeas).add(idea("Book voucher"), to: "kate")
        let screen = places.commitmentsScreen()

        let refusal = screen.askToRestore(from: try pickedFile(holding: bytes))

        #expect(refusal == nil)
        #expect(screen.awaitingRestore?.copy.presentIdeas == 0)
        #expect(screen.awaitingRestore?.phone.presentIdeas == 1)

        #expect(screen.confirmRestoring() == nil)

        #expect(try PresentIdeaStore(at: places.presentIdeas).ideas(of: "kate").isEmpty)
        #expect(screen.kept.map(\.name) == ["Gym"])
    }

    let copy = gymCopy()
    try restoring(earlierFormCopyBytes(copy, version: 3))
    try restoring(earlierFormCopyBytes(copy, version: 2))
    try restoring(earlierFormCopyBytes(copy, version: 1))

    // A copy made through a screen afterwards says a form later than the file's.
    let result = Places().commitmentsScreen().makeACopy(
        asOf: moment(14, 32), writingInto: freshDirectory())
    guard case .success(let url) = result else {
        Issue.record("expected a copy to be made")
        return
    }
    let written = try JSONSerialization.jsonObject(with: Data(contentsOf: url)) as! [String: Any]
    #expect((written["version"] as? Int ?? 0) > 3)
}

/// The bytes of the copy `screen` makes as of 14:32, its `presentIdeas` key replaced by
/// `presentIdeas` (a JSON object) where given, or taken out where `nil`, and `roster` replaced
/// where given.
@MainActor
private func copyBytes(
    madeThrough screen: CommitmentsScreen, presentIdeas: String?, roster: String? = nil
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
    if let presentIdeas {
        object["presentIdeas"] = try parsed(presentIdeas)
    } else {
        object.removeValue(forKey: "presentIdeas")
    }
    if let roster {
        object["roster"] = try parsed(roster)
    }
    return try JSONSerialization.data(withJSONObject: object, options: [.sortedKeys])
}

@MainActor
@Test(
    "a copy holding present ideas the app never writes is refused as a damaged copy, and one whose present ideas are of a later form as a copy from a later version"
)
func aCopyHoldingPresentIdeasTheAppNeverWritesIsRefusedAsADamagedCopyAndOneWhosePresentIdeasAreOfALaterFormAsACopyFromALaterVersion()
    throws
{
    let screen = Places().commitmentsScreen()

    func askingToRestore(presentIdeas: String?, roster: String? = nil) throws -> (
        CommitmentsScreen.Refusal?, CommitmentsScreen.AwaitingRestore?
    ) {
        let bytes = try copyBytes(madeThrough: screen, presentIdeas: presentIdeas, roster: roster)
        let refusal = screen.askToRestore(from: try pickedFile(holding: bytes))
        return (refusal, screen.awaitingRestore)
    }

    func ideas(_ contacts: String) -> String {
        #"{"version":2,"contacts":[\#(contacts)]}"#
    }

    let neither = try askingToRestore(
        presentIdeas: ideas(#"{"contact":"kate","ideas":[{}]}"#))
    #expect(neither.0 == .damagedCopy)
    #expect(neither.1 == nil)

    for contacts in [
        #"{"contact":"kate","ideas":[{"link":"ask Anna"}]}"#,
        #"{"contact":"kate","ideas":[{"link":"amazon.de/xyz"}]}"#,
        #"{"contact":"kate","ideas":[{"text":" Book voucher "}]}"#,
        #"{"contact":"  ","ideas":[{"text":"Book voucher"}]}"#,
        #"{"contact":"kate","ideas":[{"text":"Book voucher"}]},{"contact":"kate","ideas":[{"text":"Scarf"}]}"#,
    ] {
        #expect(try askingToRestore(presentIdeas: ideas(contacts)).0 == .damagedCopy)
    }
    #expect(try askingToRestore(presentIdeas: nil).0 == .damagedCopy)

    let later = #"{"version":\#(PresentIdeaDocument.currentVersion + 1),"contacts":[]}"#
    #expect(try askingToRestore(presentIdeas: later).0 == .copyFromALaterVersion)
    #expect(
        try askingToRestore(presentIdeas: later, roster: #"{"version":1}"#).0
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

@MainActor
@Test(
    "a commitments screen asked to restore says how many present ideas the copy and the phone hold, given and not given together"
)
func aCommitmentsScreenAskedToRestoreSaysHowManyPresentIdeasTheCopyAndThePhoneHoldGivenAndNotGivenTogether()
    throws
{
    let places = Places()
    let store = try PresentIdeaStore(at: places.presentIdeas)
    try store.add(idea("Ceramics class voucher"), to: "kate")
    try store.add(idea("Hiking socks, size 38"), to: "kate")
    try store.mark(0, of: "kate", given: true)
    try store.add(idea("Book voucher"), to: "anna")
    let screen = places.commitmentsScreen(whileOn: offSwitch())
    let file = try copyPicked(madeThrough: screen)

    try store.add(idea("Scarf"), to: "john")
    try store.add(idea("Kite"), to: "john")
    try store.delete(0, of: "anna")
    let bytesBefore = try Data(contentsOf: places.presentIdeas)

    #expect(screen.askToRestore(from: file) == nil)

    let awaiting = try #require(screen.awaitingRestore)
    #expect(awaiting.copy.presentIdeas == 3)
    #expect(awaiting.phone.presentIdeas == 4)
    #expect(awaiting.unreadable.isEmpty)
    #expect(try Data(contentsOf: places.presentIdeas) == bytesBefore)
}

@MainActor
@Test(
    "a commitments screen asked to restore where the present-idea place cannot be read says the present ideas cannot be read in place of their count"
)
func aCommitmentsScreenAskedToRestoreWhereThePresentIdeaPlaceCannotBeReadSaysThePresentIdeasCannotBeReadInPlaceOfTheirCount()
    throws
{
    for unreadable in [notAPresentIdeaStore, laterPresentIdeaBytes()] {
        let places = Places()
        let screen = places.commitmentsScreen()
        let file = try copyPicked(madeThrough: screen)
        try write(unreadable, to: places.presentIdeas)

        #expect(screen.askToRestore(from: file) == nil)

        let awaiting = try #require(screen.awaitingRestore)
        #expect(awaiting.unreadable == [.presentIdeas])
        #expect(awaiting.phone.presentIdeas == nil)
        #expect(awaiting.phone.kept == 0)
        #expect(awaiting.phone.stopped == 0)
        #expect(awaiting.phone.oneOffs == 0)
        #expect(awaiting.phone.happenings == 0)
        #expect(awaiting.phone.stoppedHappenings == 0)
        #expect(awaiting.copy.presentIdeas == 0)
    }
}

private func birthday(_ contact: String, _ words: String, _ day: CalendarDate) -> Birthday {
    Birthday(contact: contact, words: words, day: day)!
}

/// A birthday switch that is on: the phone gives full calendar access.
@MainActor
private func onSwitch() async -> BirthdaySwitch {
    let result = BirthdaySwitch(
        at: freshDirectory().appendingPathComponent("birthday-switch.json"),
        readingAccess: { .full }, askingForAccess: {})
    await result.turnOn()
    return result
}

/// A calendar handing the contact "kate"'s birthday on 14 November 2026 and, where `andJohn`,
/// the contact "john"'s on 5 June 2027.
@MainActor
private func calendar(andJohn: Bool = false) -> BirthdayCalendar {
    var handed = [birthday("kate", "Kate Bell's 48th Birthday", date(2026, 11, 14))]
    if andJohn {
        handed.append(birthday("john", "John Appleseed's 40th Birthday", date(2027, 6, 5)))
    }
    return BirthdayCalendar(reading: { _, _ in handed }, collating: { $0 < $1 })
}

@MainActor
@Test(
    "a restore confirmed makes the present-idea place hold the copy's present ideas, and the ideas there are gone"
)
func aRestoreConfirmedMakesThePresentIdeaPlaceHoldTheCopysPresentIdeasAndTheIdeasThereAreGone()
    async throws
{
    let places = Places()
    try PresentIdeaStore(at: places.presentIdeas).add(idea("Book voucher"), to: "kate")
    let birthdays = BirthdaysScreen(
        asOf: tuesday, readingBirthdaysFrom: calendar(andJohn: true), whileOn: await onSwitch(),
        keepingPresentIdeasAt: places.presentIdeas)
    let screen = places.commitmentsScreen()
    let file = try copyPicked(madeThrough: screen)

    let kate = try #require(birthdays.lines.first { $0.contact == "kate" })
    let john = try #require(birthdays.lines.first { $0.contact == "john" })
    #expect(birthdays.markIdea(0, of: kate, given: true) == nil)
    #expect(birthdays.addIdea(text: "Scarf", link: "", to: john) == nil)

    #expect(screen.askToRestore(from: file) == nil)
    #expect(screen.confirmRestoring() == nil)

    let reference = Places()
    try PresentIdeaStore(at: reference.presentIdeas).add(idea("Book voucher"), to: "kate")
    #expect(
        try Data(contentsOf: places.presentIdeas) == Data(contentsOf: reference.presentIdeas))

    birthdays.shown(asOf: tuesday)
    #expect(birthdays.lines.first { $0.contact == "kate" }?.ideasInWords == "1 idea")
    #expect(birthdays.lines.first { $0.contact == "john" }?.ideasInWords == nil)

    // A restore of that copy where the place holds a run of bytes that is not a store.
    try write(notAPresentIdeaStore, to: places.presentIdeas)
    let again = places.commitmentsScreen()
    #expect(again.askToRestore(from: file) == nil)
    #expect(again.confirmRestoring() == nil)
    #expect(
        try Data(contentsOf: places.presentIdeas) == Data(contentsOf: reference.presentIdeas))
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

/// A file holding a copy of a roster of "Journaling" and the idea "Book voucher" against "kate".
@MainActor
private func journalingAndBookVoucherCopy() throws -> URL {
    let source = Places()
    try RosterStore(at: source.roster).add(journaling)
    try PresentIdeaStore(at: source.presentIdeas).add(idea("Book voucher"), to: "kate")
    return try copyPicked(madeThrough: source.commitmentsScreen())
}

@MainActor
@Test(
    "a restore refused where the present-idea place cannot be written leaves the six places as they were"
)
func aRestoreRefusedWhereThePresentIdeaPlaceCannotBeWrittenLeavesTheSixPlacesAsTheyWere() throws {
    let base = freshDirectory()
    let roster = base.appendingPathComponent("roster.json")
    let record = base.appendingPathComponent("record.json")
    let oneOffs = base.appendingPathComponent("one-offs.json")
    let birthday = base.appendingPathComponent("birthday-ticks.json")
    let happenings = base.appendingPathComponent("happenings.json")
    let presentIdeas = try blockedPlace(named: "present-ideas.json")

    try RosterStore(at: roster).add(gym)
    try RecordStore(at: record).add(Tick(gym, on: date(2026, 10, 12))!)
    try OneOffStore(at: oneOffs).add(OneOff(name: "Book dentist", date: date(2026, 10, 25))!)
    let screen = CommitmentsScreen(
        asOf: tuesday, keepingRosterAt: roster, keepingRecordAt: record, keepingOneOffsAt: oneOffs,
        keepingBirthdayTicksAt: birthday, keepingHappeningsAt: happenings,
        keepingPresentIdeasAt: presentIdeas)
    let rosterBefore = try Data(contentsOf: roster)
    let recordBefore = try Data(contentsOf: record)
    let oneOffsBefore = try Data(contentsOf: oneOffs)

    #expect(screen.askToRestore(from: try journalingAndBookVoucherCopy()) == nil)
    let refusal = screen.confirmRestoring()

    #expect(refusal == .notKept)
    #expect(try Data(contentsOf: roster) == rosterBefore)
    #expect(try Data(contentsOf: record) == recordBefore)
    #expect(try Data(contentsOf: oneOffs) == oneOffsBefore)
    #expect(!FileManager.default.fileExists(atPath: birthday.path))
    #expect(!FileManager.default.fileExists(atPath: happenings.path))
    #expect(!FileManager.default.fileExists(atPath: presentIdeas.path))
    #expect(screen.kept.map(\.name) == ["Gym"])
    #expect(screen.copyRestored == nil)
    #expect(screen.awaitingRestore == nil)
}

@MainActor
@Test(
    "a restore stopped before it was whole is undone at the present-idea place when the places are next opened"
)
func aRestoreStoppedBeforeItWasWholeIsUndoneAtThePresentIdeaPlaceWhenThePlacesAreNextOpened()
    throws
{
    /// Places holding "Gym" and "Book voucher" against "kate", and a restore of "Journaling" and
    /// "Scarf" against "john" left having written all six, with the restore in progress it left
    /// standing.
    func placesWithATornRestore(
        writing stoppingAfter: Int = 6
    ) throws -> (places: Places, rosterBefore: Data, presentIdeasBefore: Data) {
        let places = Places()
        try RosterStore(at: places.roster).add(gym)
        try PresentIdeaStore(at: places.presentIdeas).add(idea("Book voucher"), to: "kate")
        let rosterBefore = try Data(contentsOf: places.roster)
        let presentIdeasBefore = try Data(contentsOf: places.presentIdeas)

        var roster = Roster()
        _ = roster.add(journaling)
        let copy = Copy(
            moment: moment(9, 0), history: History(), roster: roster, oneOffs: OneOffs(),
            presentIdeas: ["john": [idea("Scarf")]])
        try RestoreInProgress.restore(
            copy, recordAt: places.record, rosterAt: places.roster, oneOffsAt: places.oneOffs,
            birthdayTicksAt: places.birthday, happeningsAt: places.happenings,
            presentIdeasAt: places.presentIdeas, stoppingAfter: stoppingAfter)
        #expect(
            FileManager.default.fileExists(
                atPath: RestoreInProgress.place(besideRecordAt: places.record).path))
        #expect(try Data(contentsOf: places.presentIdeas) != presentIdeasBefore)
        return (places, rosterBefore, presentIdeasBefore)
    }

    func expectUndone(_ torn: (places: Places, rosterBefore: Data, presentIdeasBefore: Data)) throws
    {
        #expect(try Data(contentsOf: torn.places.roster) == torn.rosterBefore)
        #expect(try Data(contentsOf: torn.places.presentIdeas) == torn.presentIdeasBefore)
        #expect(!FileManager.default.fileExists(atPath: torn.places.record.path))
        #expect(!FileManager.default.fileExists(atPath: torn.places.oneOffs.path))
        #expect(!FileManager.default.fileExists(atPath: torn.places.birthday.path))
        #expect(!FileManager.default.fileExists(atPath: torn.places.happenings.path))
        #expect(
            !FileManager.default.fileExists(
                atPath: RestoreInProgress.place(besideRecordAt: torn.places.record).path))
    }

    let torn = try placesWithATornRestore()
    #expect(torn.places.commitmentsScreen().kept.map(\.name) == ["Gym"])
    try expectUndone(torn)

    // A day screen of that commitment opened at those places instead.
    let instead = try placesWithATornRestore()
    _ = instead.places.dayScreen()
    try expectUndone(instead)

    // A restore in progress kept before restores wrote the present-idea place leaves it as it
    // stands.
    let old = Places()
    try RosterStore(at: old.roster).add(gym)
    try PresentIdeaStore(at: old.presentIdeas).add(idea("Book voucher"), to: "kate")
    let oldPresentIdeasBefore = try Data(contentsOf: old.presentIdeas)
    let oldSnapshot = RestoreInProgress(
        record: nil, roster: try Data(contentsOf: old.roster), oneOffs: nil,
        saveInProgress: nil, birthdayTicks: nil)
    let oldSnapshotPlace = RestoreInProgress.place(besideRecordAt: old.record)
    try write(JSONEncoder().encode(oldSnapshot), to: oldSnapshotPlace)
    try RosterStore(at: old.roster).add(journaling)
    try PresentIdeaStore(at: old.presentIdeas).add(idea("Scarf"), to: "john")
    let oldPresentIdeasAfter = try Data(contentsOf: old.presentIdeas)

    #expect(old.commitmentsScreen().kept.map(\.name) == ["Gym"])
    #expect(try Data(contentsOf: old.presentIdeas) == oldPresentIdeasAfter)
    #expect(oldPresentIdeasAfter != oldPresentIdeasBefore)
    #expect(!FileManager.default.fileExists(atPath: oldSnapshotPlace.path))
}
