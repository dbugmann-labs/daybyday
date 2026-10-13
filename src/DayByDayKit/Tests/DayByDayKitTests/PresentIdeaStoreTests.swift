import Foundation
import Testing

@testable import DayByDayKit

private func freshPlace() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("present-ideas.json")
}

private func idea(_ text: String, _ link: String = "") -> PresentIdea {
    try! PresentIdea(text: text, link: link)
}

@Test("a present-idea store opened where nothing has been kept holds no ideas")
func aPresentIdeaStoreOpenedWhereNothingHasBeenKeptHoldsNoIdeas() throws {
    let store = try PresentIdeaStore(at: freshPlace())
    #expect(store.ideas(of: "kate").isEmpty)
}

@Test(
    "a present-idea store opened again holds each contact's ideas in the order added, two alike both held"
)
func aPresentIdeaStoreOpenedAgainHoldsEachContactsIdeasInTheOrderAddedTwoAlikeBothHeld() throws {
    let place = freshPlace()
    let first = try PresentIdeaStore(at: place)
    try first.add(idea("Ceramics class voucher"), to: "kate")
    try first.add(idea("Hiking socks, size 38", "https://bergzeit.ch/socks"), to: "kate")
    try first.add(idea("Ceramics class voucher"), to: "kate")
    try first.add(idea("", "https://amazon.de/xyz"), to: "john")

    let second = try PresentIdeaStore(at: place)
    #expect(
        second.ideas(of: "kate") == [
            idea("Ceramics class voucher"),
            idea("Hiking socks, size 38", "https://bergzeit.ch/socks"),
            idea("Ceramics class voucher"),
        ])
    #expect(second.ideas(of: "john") == [idea("", "https://amazon.de/xyz")])
    #expect(second.ideas(of: "anna").isEmpty)
}

/// A place nothing can be written at: a path beneath an existing ordinary file.
private func unwritablePlace() throws -> URL {
    let file = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString)
    try Data("not a directory".utf8).write(to: file)
    return file.appendingPathComponent("present-ideas.json")
}

@Test("a present idea that cannot be kept is refused and not held")
func aPresentIdeaThatCannotBeKeptIsRefusedAndNotHeld() throws {
    let place = try unwritablePlace()
    let store = try PresentIdeaStore(at: place)
    #expect(throws: PresentIdeaStoreError.cannotWrite(at: place)) {
        try store.add(idea("Book voucher"), to: "kate")
    }
    #expect(store.ideas(of: "kate").isEmpty)
    #expect(try PresentIdeaStore(at: place).ideas(of: "kate").isEmpty)
}

@Test("a present idea added to a contact that says nothing is refused and leaves the place untouched")
func aPresentIdeaAddedToAContactThatSaysNothingIsRefusedAndLeavesThePlaceUntouched() throws {
    let place = freshPlace()
    let store = try PresentIdeaStore(at: place)
    #expect(try store.add(idea("Book voucher"), to: "kate"))
    let before = try Data(contentsOf: place)

    #expect(try store.add(idea("Ceramics class voucher"), to: " \t ") == false)
    #expect(try Data(contentsOf: place) == before)
    #expect(store.ideas(of: " \t ").isEmpty)
}

@Test("present-idea stores at different places are independent")
func presentIdeaStoresAtDifferentPlacesAreIndependent() throws {
    let place = freshPlace()
    let store = try PresentIdeaStore(at: place)
    try store.add(idea("Book voucher"), to: "kate")

    let other = try PresentIdeaStore(at: freshPlace())
    #expect(other.ideas(of: "kate").isEmpty)
    #expect(try PresentIdeaStore(at: place).ideas(of: "kate") == [idea("Book voucher")])
}

private func writeRaw(_ text: String, at place: URL) throws {
    try FileManager.default.createDirectory(
        at: place.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(text.utf8).write(to: place)
}

@Test("content that is not a present-idea store is refused and left as it was")
func contentThatIsNotAPresentIdeaStoreIsRefusedAndLeftAsItWas() throws {
    let place = freshPlace()
    try writeRaw("these are not the bytes a store writes", at: place)
    let before = try Data(contentsOf: place)

    #expect(throws: PresentIdeaStoreError.notAStore(at: place)) {
        try PresentIdeaStore(at: place)
    }
    #expect(try Data(contentsOf: place) == before)
}

@Test("a present-idea store written in a later form than this app knows is refused")
func aPresentIdeaStoreWrittenInALaterFormThanThisAppKnowsIsRefused() throws {
    let place = freshPlace()
    try writeRaw(#"{"contacts":[],"version":3}"#, at: place)
    let before = try Data(contentsOf: place)

    #expect(throws: PresentIdeaStoreError.laterForm(at: place, version: 3)) {
        try PresentIdeaStore(at: place)
    }
    #expect(try Data(contentsOf: place) == before)
}

@Test("a present-idea store holding what could not be held is refused")
func aPresentIdeaStoreHoldingWhatCouldNotBeHeldIsRefused() throws {
    func store(contact: String, idea: String, version: Int) -> String {
        #"{"contacts":[{"contact":"\#(contact)","ideas":[\#(idea)]}],"version":\#(version)}"#
    }
    let cases = [1, 2].flatMap { version in
        [
            store(contact: "  ", idea: #"{"text":"Book voucher"}"#, version: version),
            store(contact: "kate", idea: "{}", version: version),
            store(contact: "kate", idea: #"{"text":" Book voucher "}"#, version: version),
            store(contact: "kate", idea: #"{"link":"ask Anna"}"#, version: version),
            store(contact: "kate", idea: #"{"link":"amazon.de/xyz"}"#, version: version),
        ]
    }
    for content in cases {
        let place = freshPlace()
        try writeRaw(content, at: place)
        let before = try Data(contentsOf: place)
        #expect(throws: PresentIdeaStoreError.notAStore(at: place), "\(content)") {
            try PresentIdeaStore(at: place)
        }
        #expect(try Data(contentsOf: place) == before)
    }
}

@Test("a present-idea store opened again holds each idea as changed, deleted and marked")
func aPresentIdeaStoreOpenedAgainHoldsEachIdeaAsChangedDeletedAndMarked() throws {
    let place = freshPlace()
    let first = try PresentIdeaStore(at: place)
    for text in ["Ceramics class voucher", "Hiking socks", "Book voucher", "Scarf"] {
        try first.add(idea(text), to: "kate")
    }
    try first.change(1, of: "kate", to: idea("Hiking socks, size 38", "https://bergzeit.ch/socks"))
    try first.mark(2, of: "kate", given: true)
    try first.mark(3, of: "kate", given: true)
    try first.mark(3, of: "kate", given: false)
    try first.delete(0, of: "kate")

    let second = try PresentIdeaStore(at: place)
    let held = second.ideas(of: "kate")
    #expect(held.map(\.text) == ["Hiking socks, size 38", "Book voucher", "Scarf"])
    #expect(held[0].link == "https://bergzeit.ch/socks")
    #expect(held.map(\.isGiven) == [false, true, false])

    try second.change(1, of: "kate", to: idea("Book voucher, hardback"))
    let third = try PresentIdeaStore(at: place).ideas(of: "kate")
    #expect(third[1].text == "Book voucher, hardback")
    #expect(third[1].isGiven)
}

@Test("a change, deletion or mark the present-idea store cannot keep is refused and not held")
func aChangeDeletionOrMarkThePresentIdeaStoreCannotKeepIsRefusedAndNotHeld() throws {
    let place = freshPlace()
    let store = try PresentIdeaStore(at: place)
    try store.add(idea("Ceramics class voucher"), to: "kate")
    try store.add(idea("Book voucher"), to: "kate")
    try store.mark(1, of: "kate", given: true)
    let folder = place.deletingLastPathComponent()
    try FileManager.default.setAttributes([.posixPermissions: 0o555], ofItemAtPath: folder.path)
    defer {
        try? FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: folder.path)
    }

    #expect(throws: PresentIdeaStoreError.cannotWrite(at: place)) {
        try store.change(0, of: "kate", to: idea("Hiking socks"))
    }
    #expect(store.ideas(of: "kate").first?.text == "Ceramics class voucher")
    #expect(throws: PresentIdeaStoreError.cannotWrite(at: place)) {
        try store.mark(0, of: "kate", given: true)
    }
    #expect(store.ideas(of: "kate").first?.isGiven == false)
    #expect(throws: PresentIdeaStoreError.cannotWrite(at: place)) {
        try store.mark(1, of: "kate", given: false)
    }
    #expect(store.ideas(of: "kate").last?.isGiven == true)
    #expect(throws: PresentIdeaStoreError.cannotWrite(at: place)) {
        try store.delete(0, of: "kate")
    }
    #expect(store.ideas(of: "kate").count == 2)

    let reopened = try PresentIdeaStore(at: place).ideas(of: "kate")
    #expect(reopened.map(\.text) == ["Ceramics class voucher", "Book voucher"])
    #expect(reopened.map(\.isGiven) == [false, true])
}

@Test(
    "a change, deletion or mark naming no idea, or a mark already so, is refused without an error and leaves the place untouched"
)
func aChangeDeletionOrMarkNamingNoIdeaOrAMarkAlreadySoIsRefusedWithoutAnErrorAndLeavesThePlaceUntouched()
    throws
{
    let place = freshPlace()
    let store = try PresentIdeaStore(at: place)
    try store.add(idea("Book voucher"), to: "kate")
    try store.mark(0, of: "kate", given: true)
    let before = try Data(contentsOf: place)

    #expect(try store.change(1, of: "kate", to: idea("Scarf")) == false)
    #expect(try store.delete(1, of: "kate") == false)
    #expect(try store.mark(1, of: "kate", given: true) == false)
    for contact in ["john", " \t "] {
        #expect(try store.change(0, of: contact, to: idea("Scarf")) == false)
        #expect(try store.delete(0, of: contact) == false)
        #expect(try store.mark(0, of: contact, given: true) == false)
    }
    #expect(try store.mark(0, of: "kate", given: true) == false)
    #expect(try Data(contentsOf: place) == before)

    #expect(try store.mark(0, of: "kate", given: false))
    #expect(try store.mark(0, of: "kate", given: false) == false)
}

@Test("a present-idea store in its first form is read as holding no idea given")
func aPresentIdeaStoreInItsFirstFormIsReadAsHoldingNoIdeaGiven() throws {
    let place = freshPlace()
    try writeRaw(
        #"{"contacts":[{"contact":"kate","ideas":[{"text":"Book voucher"},{"given":true,"text":"Scarf"}]}],"version":1}"#,
        at: place)
    let before = try Data(contentsOf: place)

    let store = try PresentIdeaStore(at: place)
    #expect(store.ideas(of: "kate") == [idea("Book voucher"), idea("Scarf")])
    #expect(store.ideas(of: "kate").map(\.isGiven) == [false, false])
    #expect(try Data(contentsOf: place) == before)

    try store.mark(0, of: "kate", given: true)
    let reopened = try PresentIdeaStore(at: place).ideas(of: "kate")
    #expect(reopened.map(\.text) == ["Book voucher", "Scarf"])
    #expect(reopened.map(\.isGiven) == [true, false])
}
