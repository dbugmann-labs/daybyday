import Foundation
import Testing

@testable import DayByDayKit

@Test("two happenings made separately from one name are two happenings")
func twoHappeningsMadeSeparatelyFromOneNameAreTwoHappenings() throws {
    let first = try #require(Happening(name: "Kopfweh"))
    let second = try #require(Happening(name: "Kopfweh"))

    #expect(first != second)
    #expect(first == first)
    #expect(second == second)
}

@Test("a happening's name is kept exactly as it was given")
func aHappeningsNameIsKeptExactlyAsItWasGiven() throws {
    let happening = try #require(Happening(name: " Kopfweh "))

    #expect(happening.name == " Kopfweh ")
}

@Test("a name that says nothing makes no happening")
func aNameThatSaysNothingMakesNoHappening() {
    #expect(Happening(name: "") == nil)
    #expect(Happening(name: " \t\n ") == nil)
    #expect(Happening(name: "K") != nil)
}

@Test("happenings are held in the order they were added, the newest last")
func happeningsAreHeldInTheOrderTheyWereAddedTheNewestLast() throws {
    var happenings = Happenings()
    let augenmigraene = try #require(Happening(name: "Augenmigräne"))
    let kopfweh = try #require(Happening(name: "Kopfweh"))
    let schlecht = try #require(Happening(name: "Schlecht geschlafen"))

    let first = happenings.add(augenmigraene)
    let second = happenings.add(kopfweh)
    let third = happenings.add(schlecht)

    #expect(first && second && third)

    #expect(happenings.all.map(\.name) == ["Augenmigräne", "Kopfweh", "Schlecht geschlafen"])
}

@Test("adding a happening whose name one held already has is refused and changes nothing")
func addingAHappeningWhoseNameOneHeldAlreadyHasIsRefusedAndChangesNothing() throws {
    var happenings = Happenings()
    let kopfweh = try #require(Happening(name: "Kopfweh"))
    _ = happenings.add(kopfweh)
    let before = happenings

    let lower = happenings.add(try #require(Happening(name: "kopfweh")))
    #expect(!lower)
    #expect(happenings == before)
    #expect(happenings.holding(name: "kopfweh") == kopfweh)
    let padded = happenings.add(try #require(Happening(name: " KOPFWEH ")))
    let again = happenings.add(kopfweh)
    #expect(!padded && !again)
    #expect(happenings == before)

    let spaced = try #require(Happening(name: "Kopf weh"))
    let added = happenings.add(spaced)
    #expect(added)
    #expect(happenings.all == [kopfweh, spaced])
}

@Test("a happening renamed keeps its identity and its place")
func aHappeningRenamedKeepsItsIdentityAndItsPlace() throws {
    var happenings = Happenings()
    let augenmigraene = try #require(Happening(name: "Augenmigräne"))
    let kopfweh = try #require(Happening(name: "Kopfweh"))
    let schlecht = try #require(Happening(name: "Schlecht geschlafen"))
    _ = happenings.add(augenmigraene)
    _ = happenings.add(kopfweh)
    _ = happenings.add(schlecht)

    let renamed = happenings.rename(kopfweh, to: "Spannungskopfweh")

    #expect(renamed)
    #expect(
        happenings.all.map(\.name) == ["Augenmigräne", "Spannungskopfweh", "Schlecht geschlafen"])
    #expect(happenings.all[1] == kopfweh)
    #expect(happenings.holding(name: "Kopfweh") == nil)
}

@Test(
    "renaming a happening onto another's name, to a name that says nothing, or when it is not held, is refused"
)
func renamingAHappeningOntoAnothersNameToANameThatSaysNothingOrWhenItIsNotHeldIsRefused() throws {
    var happenings = Happenings()
    let augenmigraene = try #require(Happening(name: "Augenmigräne"))
    let kopfweh = try #require(Happening(name: "Kopfweh"))
    _ = happenings.add(augenmigraene)
    _ = happenings.add(kopfweh)
    let before = happenings

    let onto = happenings.rename(kopfweh, to: "augenmigräne")
    #expect(!onto)
    #expect(happenings == before)
    let blank = happenings.rename(kopfweh, to: "  ")
    #expect(!blank)
    let notHeld = happenings.rename(try #require(Happening(name: "Schlecht geschlafen")), to: "X")
    #expect(!notHeld)
    #expect(happenings == before)

    let caseOnly = happenings.rename(kopfweh, to: "KOPFWEH")
    #expect(caseOnly)
    #expect(happenings.all.map(\.name) == ["Augenmigräne", "KOPFWEH"])
}
