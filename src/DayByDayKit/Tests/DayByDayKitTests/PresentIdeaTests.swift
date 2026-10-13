import Foundation
import Testing

@testable import DayByDayKit

@Test("a present idea holds its text and its link, each trimmed")
func aPresentIdeaHoldsItsTextAndItsLinkEachTrimmed() throws {
    let both = try PresentIdea(text: " Book voucher ", link: " https://amazon.de/xyz ")
    #expect(both.text == "Book voucher")
    #expect(both.link == "https://amazon.de/xyz")

    let textOnly = try PresentIdea(text: "Hiking socks, size 38", link: "")
    #expect(textOnly.text == "Hiking socks, size 38")
    #expect(textOnly.link == nil)

    let linkOnly = try PresentIdea(text: "  \t ", link: "https://bergzeit.ch/socks")
    #expect(linkOnly.text == nil)
    #expect(linkOnly.link == "https://bergzeit.ch/socks")

    let long = String(repeating: "a", count: 1000)
    let longIdea = try PresentIdea(text: long, link: "")
    #expect(longIdea.text == long)
}

@Test("a present idea whose text and link both say nothing is refused")
func aPresentIdeaWhoseTextAndLinkBothSayNothingIsRefused() {
    #expect(throws: PresentIdeaRefusal.saysNothing) {
        try PresentIdea(text: "", link: "")
    }
    #expect(throws: PresentIdeaRefusal.saysNothing) {
        try PresentIdea(text: "   ", link: "\t")
    }
}

@Test("a link that names no scheme is kept with https:// in front, and opens that address")
func aLinkThatNamesNoSchemeIsKeptWithHttpsInFrontAndOpensThatAddress() throws {
    let bare = try PresentIdea(text: "", link: "amazon.de/xyz")
    #expect(bare.link == "https://amazon.de/xyz")
    #expect(bare.opens == URL(string: "https://amazon.de/xyz"))

    #expect(try PresentIdea(text: "", link: "www.galaxus.ch").link == "https://www.galaxus.ch")

    let umlaut = try PresentIdea(text: "", link: "müller.de")
    #expect(umlaut.link == "https://müller.de")
    #expect(umlaut.opens == URL(string: "https://müller.de"))
    #expect(umlaut.opens != nil)
}

@Test("a link that names http or https is kept exactly as typed")
func aLinkThatNamesHttpOrHttpsIsKeptExactlyAsTyped() throws {
    let shouted = try PresentIdea(text: "Hiking socks", link: "HTTP://Bergzeit.ch/socks?size=38#top")
    #expect(shouted.link == "HTTP://Bergzeit.ch/socks?size=38#top")
    #expect(shouted.opens == URL(string: "HTTP://Bergzeit.ch/socks?size=38#top"))
    #expect(shouted.opens != nil)

    #expect(try PresentIdea(text: "", link: "https://amazon.de/xyz").link == "https://amazon.de/xyz")
}

@Test("a link that does not read as a web address is refused, whatever the text")
func aLinkThatDoesNotReadAsAWebAddressIsRefusedWhateverTheText() {
    #expect(throws: PresentIdeaRefusal.linkIsNotAWebAddress) {
        try PresentIdea(text: "Book voucher", link: "ask Anna")
    }
    for link in [
        "amazon", "amazon.de/a b", "ftp://amazon.de", "anna@example.com", "amazon.d3", "amazon..de",
    ] {
        #expect(throws: PresentIdeaRefusal.linkIsNotAWebAddress, "\(link)") {
            try PresentIdea(text: "Book voucher", link: link)
        }
    }
    #expect(throws: PresentIdeaRefusal.linkIsNotAWebAddress) {
        try PresentIdea(text: "", link: "ask Anna")
    }
}
