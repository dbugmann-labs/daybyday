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
    try writeRaw(#"{"contacts":[],"version":2}"#, at: place)
    let before = try Data(contentsOf: place)

    #expect(throws: PresentIdeaStoreError.laterForm(at: place, version: 2)) {
        try PresentIdeaStore(at: place)
    }
    #expect(try Data(contentsOf: place) == before)
}

@Test("a present-idea store holding what could not be held is refused")
func aPresentIdeaStoreHoldingWhatCouldNotBeHeldIsRefused() throws {
    func store(contact: String, idea: String) -> String {
        #"{"contacts":[{"contact":"\#(contact)","ideas":[\#(idea)]}],"version":1}"#
    }
    let cases = [
        store(contact: "  ", idea: #"{"text":"Book voucher"}"#),
        store(contact: "kate", idea: "{}"),
        store(contact: "kate", idea: #"{"text":" Book voucher "}"#),
        store(contact: "kate", idea: #"{"link":"ask Anna"}"#),
        store(contact: "kate", idea: #"{"link":"amazon.de/xyz"}"#),
    ]
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
