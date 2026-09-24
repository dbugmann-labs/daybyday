import Foundation
import Testing

@testable import DayByDayKit

/// A fake phone: `access` is what it currently gives, set by a test; `answerWhenAsked` is what
/// it gives once asked, set by a test and defaulting to `access` unchanged; `asks` counts how
/// many times it was asked. Mirrors `CopyPlaceTests.swift`'s own fakes, built as closures a test
/// hands `BirthdaySwitch`'s `readingAccess`/`askingForAccess` parameters.
@MainActor
private final class FakePhone {
    var access: CalendarAccess
    var answerWhenAsked: CalendarAccess
    private(set) var asks = 0

    init(access: CalendarAccess, answerWhenAsked: CalendarAccess? = nil) {
        self.access = access
        self.answerWhenAsked = answerWhenAsked ?? access
    }

    func readAccess() -> CalendarAccess { access }

    func askForAccess() async {
        asks += 1
        access = answerWhenAsked
    }
}

@MainActor
private func birthdaySwitch(at place: URL, asking phone: FakePhone) -> BirthdaySwitch {
    BirthdaySwitch(
        at: place, readingAccess: { phone.readAccess() },
        askingForAccess: { await phone.askForAccess() })
}

/// A fresh place of its own for a birthday switch to keep its own state at — every scenario's
/// "a place where nothing has been kept" or "a place of its own", mirroring
/// `CopyPlaceTests.swift`'s own `freshCopyPlaceState()`.
private func freshSwitchPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("birthday-switch.json")
}

@MainActor
@Test("a birthday switch opened where nothing has been kept is off")
func aBirthdaySwitchOpenedWhereNothingHasBeenKeptIsOff() {
    let phone = FakePhone(access: .notAsked)
    let place = freshSwitchPlace()

    let switchUnderTest = birthdaySwitch(at: place, asking: phone)

    #expect(switchUnderTest.isOn == false)
    #expect(switchUnderTest.isRefused == false)
    #expect(phone.asks == 0)
    #expect(BirthdaySwitch.place != DayScreen.recordPlace)
    #expect(BirthdaySwitch.place != DayScreen.rosterPlace)
    #expect(BirthdaySwitch.place != DayScreen.oneOffPlace)
    #expect(BirthdaySwitch.place != CopyPlace.place)
}

@MainActor
@Test("a birthday switch opened again is on or off as it was left")
func aBirthdaySwitchOpenedAgainIsOnOrOffAsItWasLeft() async {
    let onPlace = freshSwitchPlace()
    let onPhone = FakePhone(access: .full)
    let firstOn = birthdaySwitch(at: onPlace, asking: onPhone)
    await firstOn.turnOn()

    let secondAfterOn = birthdaySwitch(at: onPlace, asking: onPhone)
    #expect(secondAfterOn.isOn == true)

    let offPlace = freshSwitchPlace()
    let offPhone = FakePhone(access: .full)
    let firstOff = birthdaySwitch(at: offPlace, asking: offPhone)
    await firstOff.turnOn()
    firstOff.turnOff()

    let secondAfterOff = birthdaySwitch(at: offPlace, asking: offPhone)
    #expect(secondAfterOff.isOn == false)
}

@MainActor
@Test("a birthday switch opened where what is kept cannot be read is off")
func aBirthdaySwitchOpenedWhereWhatIsKeptCannotBeReadIsOff() async throws {
    let phone = FakePhone(access: .full)

    let garbagePlace = freshSwitchPlace()
    try FileManager.default.createDirectory(
        at: garbagePlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("not what a birthday switch writes".utf8).write(to: garbagePlace)
    let garbageSwitch = birthdaySwitch(at: garbagePlace, asking: phone)
    #expect(garbageSwitch.isOn == false)

    let laterFormPlace = freshSwitchPlace()
    try FileManager.default.createDirectory(
        at: laterFormPlace.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data("{\"on\":true,\"version\":2}".utf8).write(to: laterFormPlace)
    let laterFormSwitch = birthdaySwitch(at: laterFormPlace, asking: phone)
    #expect(laterFormSwitch.isOn == false)

    await garbageSwitch.turnOn()
    #expect(garbageSwitch.isOn == true)
    let reopened = birthdaySwitch(at: garbagePlace, asking: phone)
    #expect(reopened.isOn == true)
}

private let allWeekdays: Schedule = .weekdays([
    .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday,
])

@MainActor
@Test("a restore confirmed leaves the birthday switch as it was before the restore")
func aRestoreConfirmedLeavesTheBirthdaySwitchAsItWasBeforeTheRestore() async throws {
    let keptFrom = CalendarDate(year: 2026, month: 1, day: 1)!
    let monday = CalendarDate(year: 2026, month: 8, day: 31)!
    let gym = Commitment(name: "Gym", schedule: allWeekdays, keptFrom: keptFrom)!

    let rosterPlace = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("roster.json")
    try RosterStore(at: rosterPlace).add(gym)
    let recordPlace = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("record.json")
    let oneOffPlace = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("one-offs.json")

    let screen = CommitmentsScreen(
        asOf: monday, keepingRosterAt: rosterPlace, keepingRecordAt: recordPlace,
        keepingOneOffsAt: oneOffPlace)
    let copyDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let result = screen.makeACopy(
        asOf: Moment(on: monday, hour: 14, minute: 32)!, writingInto: copyDirectory)
    guard case .success(let file) = result else {
        Issue.record("expected a copy to be made")
        return
    }

    let switchPlace = freshSwitchPlace()
    let phone = FakePhone(access: .full)
    let switchUnderTest = birthdaySwitch(at: switchPlace, asking: phone)
    await switchUnderTest.turnOn()
    #expect(switchUnderTest.isOn == true)
    switchUnderTest.turnOff()

    #expect(screen.askToRestore(from: file) == nil)
    #expect(screen.confirmRestoring() == nil)

    let reopenedAfterFirstRestore = birthdaySwitch(at: switchPlace, asking: phone)
    #expect(reopenedAfterFirstRestore.isOn == false)

    await switchUnderTest.turnOn()
    #expect(switchUnderTest.isOn == true)

    #expect(screen.askToRestore(from: file) == nil)
    #expect(screen.confirmRestoring() == nil)

    let reopenedAfterSecondRestore = birthdaySwitch(at: switchPlace, asking: phone)
    #expect(reopenedAfterSecondRestore.isOn == true)
}

@MainActor
@Test("birthdays turned on where the phone has never been asked are on once it gives full access")
func birthdaysTurnedOnWhereThePhoneHasNeverBeenAskedAreOnOnceItGivesFullAccess() async {
    let place = freshSwitchPlace()
    let phone = FakePhone(access: .notAsked, answerWhenAsked: .full)
    let switchUnderTest = birthdaySwitch(at: place, asking: phone)

    await switchUnderTest.turnOn()

    #expect(phone.asks == 1)
    #expect(switchUnderTest.isOn == true)
    #expect(switchUnderTest.isRefused == false)

    let reopened = birthdaySwitch(at: place, asking: phone)
    #expect(reopened.isOn == true)
}

@MainActor
@Test("birthdays turned on and refused at the prompt turn themselves back off")
func birthdaysTurnedOnAndRefusedAtThePromptTurnThemselvesBackOff() async {
    let place = freshSwitchPlace()
    let phone = FakePhone(access: .notAsked, answerWhenAsked: .denied)
    let switchUnderTest = birthdaySwitch(at: place, asking: phone)

    await switchUnderTest.turnOn()

    #expect(phone.asks == 1)
    #expect(switchUnderTest.isOn == false)
    #expect(switchUnderTest.isRefused == true)

    let reopened = birthdaySwitch(at: place, asking: phone)
    #expect(reopened.isOn == false)
}

@MainActor
@Test("birthdays turned on where the phone already gives full access are on without asking")
func birthdaysTurnedOnWhereThePhoneAlreadyGivesFullAccessAreOnWithoutAsking() async throws {
    let place = freshSwitchPlace()
    let phone = FakePhone(access: .full)
    let switchUnderTest = birthdaySwitch(at: place, asking: phone)

    await switchUnderTest.turnOn()

    #expect(switchUnderTest.isOn == true)
    #expect(phone.asks == 0)

    let bytesAfterFirst = try Data(contentsOf: place)

    await switchUnderTest.turnOn()

    #expect(switchUnderTest.isOn == true)
    #expect(phone.asks == 0)
    #expect(try Data(contentsOf: place) == bytesAfterFirst)

    // Regression, G7 finding 1: opened while restricted (isRefused true), access becomes full
    // without a visit — turnOn()'s already-full branch must refresh isRefused from that reading
    // too, not just isOn.
    let regressionPlace = freshSwitchPlace()
    let regressionPhone = FakePhone(access: .restricted)
    let regressionSwitch = birthdaySwitch(at: regressionPlace, asking: regressionPhone)
    #expect(regressionSwitch.isRefused == true)

    regressionPhone.access = .full
    await regressionSwitch.turnOn()

    #expect(regressionSwitch.isOn == true)
    #expect(regressionSwitch.isRefused == false)
}

@MainActor
@Test(
    "birthdays turned on where the phone gives less than full access ask again, and are on only if it then gives it"
)
func birthdaysTurnedOnWhereThePhoneGivesLessThanFullAccessAskAgainAndAreOnOnlyIfItThenGivesIt()
    async
{
    let onPlace = freshSwitchPlace()
    let onPhone = FakePhone(access: .writeOnly, answerWhenAsked: .full)
    let onSwitch = birthdaySwitch(at: onPlace, asking: onPhone)
    await onSwitch.turnOn()
    #expect(onPhone.asks == 1)
    #expect(onSwitch.isOn == true)
    #expect(onSwitch.isRefused == false)

    for stillRefusing: CalendarAccess in [.writeOnly, .denied, .restricted] {
        let place = freshSwitchPlace()
        let phone = FakePhone(access: stillRefusing, answerWhenAsked: stillRefusing)
        let switchUnderTest = birthdaySwitch(at: place, asking: phone)
        await switchUnderTest.turnOn()
        #expect(phone.asks == 1)
        #expect(switchUnderTest.isOn == false)
        #expect(switchUnderTest.isRefused == true)
    }
}

@MainActor
@Test("birthdays turned off are off and kept off, and ask nothing")
func birthdaysTurnedOffAreOffAndKeptOffAndAskNothing() async throws {
    let place = freshSwitchPlace()
    let phone = FakePhone(access: .full)
    let switchUnderTest = birthdaySwitch(at: place, asking: phone)
    await switchUnderTest.turnOn()

    switchUnderTest.turnOff()

    #expect(switchUnderTest.isOn == false)
    #expect(switchUnderTest.isRefused == false)
    #expect(phone.asks == 0)

    let reopened = birthdaySwitch(at: place, asking: phone)
    #expect(reopened.isOn == false)

    let bytesAfterFirstOff = try Data(contentsOf: place)
    switchUnderTest.turnOff()
    #expect(switchUnderTest.isOn == false)
    #expect(try Data(contentsOf: place) == bytesAfterFirstOff)
}

@MainActor
private func turnedOnAtFreshPlace() async -> URL {
    let place = freshSwitchPlace()
    let phone = FakePhone(access: .full)
    let switchUnderTest = birthdaySwitch(at: place, asking: phone)
    await switchUnderTest.turnOn()
    return place
}

@MainActor
@Test("birthdays kept on are off when opened where the phone no longer gives full access")
func birthdaysKeptOnAreOffWhenOpenedWhereThePhoneNoLongerGivesFullAccess() async {
    let deniedPlace = await turnedOnAtFreshPlace()
    let deniedPhone = FakePhone(access: .denied)
    let secondAfterDenied = birthdaySwitch(at: deniedPlace, asking: deniedPhone)
    #expect(secondAfterDenied.isOn == false)
    #expect(secondAfterDenied.isRefused == true)
    #expect(deniedPhone.asks == 0)

    let fullAgainPhone = FakePhone(access: .full)
    let thirdAfterDenied = birthdaySwitch(at: deniedPlace, asking: fullAgainPhone)
    #expect(thirdAfterDenied.isOn == false)

    for lessThanFull: CalendarAccess in [.writeOnly, .restricted] {
        let place = await turnedOnAtFreshPlace()
        let phone = FakePhone(access: lessThanFull)
        let second = birthdaySwitch(at: place, asking: phone)
        #expect(second.isOn == false)
        #expect(second.isRefused == true)
    }

    let notAskedPlace = await turnedOnAtFreshPlace()
    let notAskedPhone = FakePhone(access: .notAsked)
    let secondAfterNotAsked = birthdaySwitch(at: notAskedPlace, asking: notAskedPhone)
    #expect(secondAfterNotAsked.isOn == false)
    #expect(secondAfterNotAsked.isRefused == false)
}

@MainActor
@Test(
    "birthdays on are off when shown again after access is withdrawn, and stay off when it is given back"
)
func birthdaysOnAreOffWhenShownAgainAfterAccessIsWithdrawnAndStayOffWhenItIsGivenBack() async {
    let place = freshSwitchPlace()
    let phone = FakePhone(access: .full)
    let switchUnderTest = birthdaySwitch(at: place, asking: phone)
    await switchUnderTest.turnOn()
    #expect(switchUnderTest.isOn == true)

    phone.access = .denied
    switchUnderTest.shown()

    #expect(switchUnderTest.isOn == false)
    #expect(switchUnderTest.isRefused == true)
    #expect(phone.asks == 0)

    phone.access = .full
    switchUnderTest.shown()

    #expect(switchUnderTest.isOn == false)
    #expect(switchUnderTest.isRefused == false)

    let reopened = birthdaySwitch(at: place, asking: phone)
    #expect(reopened.isOn == false)
}

@MainActor
@Test("a birthday switch says it is refused where the phone refuses, though it was never turned on")
func aBirthdaySwitchSaysItIsRefusedWhereThePhoneRefusesThoughItWasNeverTurnedOn() {
    let place = freshSwitchPlace()
    let phone = FakePhone(access: .denied)
    let switchUnderTest = birthdaySwitch(at: place, asking: phone)

    #expect(switchUnderTest.isOn == false)
    #expect(switchUnderTest.isRefused == true)
    #expect(phone.asks == 0)

    switchUnderTest.shown()
    #expect(switchUnderTest.isRefused == true)
    switchUnderTest.shown()
    #expect(switchUnderTest.isRefused == true)

    #expect(!FileManager.default.fileExists(atPath: place.path))

    for stillRefusing: CalendarAccess in [.writeOnly, .restricted] {
        let otherPlace = freshSwitchPlace()
        let otherPhone = FakePhone(access: stillRefusing)
        let otherSwitch = birthdaySwitch(at: otherPlace, asking: otherPhone)
        #expect(otherSwitch.isOn == false)
        #expect(otherSwitch.isRefused == true)
    }

    let fullPlace = freshSwitchPlace()
    let fullPhone = FakePhone(access: .full)
    let fullSwitch = birthdaySwitch(at: fullPlace, asking: fullPhone)
    #expect(fullSwitch.isOn == false)
    #expect(fullSwitch.isRefused == false)
}
