import Foundation

/// The screen that lists the birthdays the phone's calendar hands over for the coming year,
/// soonest first. See this change's `design.md` § *The seam*. It takes the calendar and the switch
/// a day screen takes, and a place for present ideas: it reads no tick, and writes only an idea
/// added through it, to that place.
@MainActor
@Observable
public final class BirthdaysScreen {
    /// One birthday as this screen says it: the `contact` it belongs to, the calendar's words, its
    /// day in words, and how many present ideas are held against that contact in words, which is
    /// nil for a contact with none and where the place cannot be read.
    public struct Line: Hashable, Sendable {
        public let contact: String
        public let words: String
        public let dayInWords: String
        public let ideasInWords: String?
    }

    /// What this screen says about birthdays when it lists none.
    public enum BirthdayState: Equatable, Sendable {
        case off, calendarUnreadable, on
    }

    private let calendar: BirthdayCalendar
    private let birthdaySwitch: BirthdaySwitch
    private let ideaPlace: URL
    private var ideaStore: PresentIdeaStore?
    /// The lines as the calendar handed them, before what the present-idea place says is added.
    private var listed: [Line] = []

    public private(set) var lines: [Line] = []
    public private(set) var birthdayState: BirthdayState = .off
    public private(set) var presentIdeaState: RosterState = .kept
    public private(set) var ideaRefusal: PresentIdeaRefusal?

    public static var presentIdeaPlace: URL {
        let applicationSupport = FileManager.default.urls(
            for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return applicationSupport
            .appendingPathComponent("DayByDay", isDirectory: true)
            .appendingPathComponent("present-ideas.json")
    }

    /// The ideas held against `line`'s contact, in the order added.
    public func ideas(of line: Line) -> [PresentIdea] {
        ideaStore?.ideas(of: line.contact) ?? []
    }

    /// Adds an idea made from `text` and `link` to `line`'s contact, last, kept at the present-idea
    /// place before this returns. `nil` where it is kept; otherwise why not, and nothing written.
    @discardableResult
    public func addIdea(text: String, link: String, to line: Line) -> PresentIdeaRefusal? {
        let idea: PresentIdea
        do {
            idea = try PresentIdea(text: text, link: link)
        } catch {
            return refuseIdea(error)
        }
        guard let store = ideaStore, (try? store.add(idea, to: line.contact)) == true else {
            return refuseIdea(.notKept)
        }
        ideaRefusal = nil
        lines = listed.map(withIdeas)
        return nil
    }

    /// A field of the idea sheet was edited: what was told about the last add ends.
    public func ideaFieldEdited() {
        ideaRefusal = nil
    }

    /// The idea sheet closed: what was told about the last add ends.
    public func ideaSheetClosed() {
        ideaRefusal = nil
    }

    private func refuseIdea(_ refusal: PresentIdeaRefusal) -> PresentIdeaRefusal {
        ideaRefusal = refusal
        return refusal
    }

    private func withIdeas(_ line: Line) -> Line {
        Line(
            contact: line.contact, words: line.words, dayInWords: line.dayInWords,
            ideasInWords: wordsForIdeas(of: line.contact))
    }

    /// Opens the present-idea place afresh, or holds no store and says why.
    private func readIdeas() {
        do {
            ideaStore = try PresentIdeaStore(at: ideaPlace)
            presentIdeaState = .kept
        } catch {
            ideaStore = nil
            if case PresentIdeaStoreError.laterForm = error {
                presentIdeaState = .writtenByALaterVersion
            } else {
                presentIdeaState = .notKept
            }
        }
    }

    private func wordsForIdeas(of contact: String) -> String? {
        switch ideaStore?.ideas(of: contact).count ?? 0 {
        case 0: nil
        case 1: "1 idea"
        case let count: "\(count) ideas"
        }
    }

    public init(
        asOf today: CalendarDate, readingBirthdaysFrom calendar: BirthdayCalendar,
        whileOn birthdaySwitch: BirthdaySwitch, keepingPresentIdeasAt ideaPlace: URL
    ) {
        self.calendar = calendar
        self.birthdaySwitch = birthdaySwitch
        self.ideaPlace = ideaPlace
        readIdeas()
        form(asOf: today)
    }

    public func shown(asOf today: CalendarDate) {
        birthdaySwitch.shown()
        ideaRefusal = nil
        readIdeas()
        form(asOf: today)
    }

    /// Asks the calendar once, for the days from `today` through the day before the same date a
    /// year later — through 28 February where `today` is 29 February, and through the last
    /// supported date where that day would fall past it.
    private func form(asOf today: CalendarDate) {
        guard birthdaySwitch.isOn else {
            listed = []
            lines = []
            birthdayState = .off
            return
        }
        let last = Self.lastDay(ofTheYearFrom: today)
        guard let handed = try? calendar.reading(today, last) else {
            listed = []
            lines = []
            birthdayState = .calendarUnreadable
            return
        }
        birthdayState = .on
        listed = handed
            .filter { today.days(until: $0.day) >= 0 && $0.day.days(until: last) >= 0 }
            .enumerated()
            .sorted { first, second in
                let firstDay = today.days(until: first.element.day)
                let secondDay = today.days(until: second.element.day)
                if firstDay != secondDay {
                    return firstDay < secondDay
                }
                if calendar.collating(first.element.words, second.element.words) {
                    return true
                }
                if calendar.collating(second.element.words, first.element.words) {
                    return false
                }
                return first.offset < second.offset
            }
            .map(\.element)
            .map {
                Line(
                    contact: $0.contact, words: $0.words,
                    dayInWords: $0.day == today ? "Today" : DayTitle.birthdayDayInWords($0.day),
                    ideasInWords: nil)
            }
        lines = listed.map(withIdeas)
    }

    private static func lastDay(ofTheYearFrom today: CalendarDate) -> CalendarDate {
        let leapDay = today.month == 2 && today.day == 29
        guard
            let sameDateAYearOn = CalendarDate(
                year: today.year + 1, month: today.month, day: leapDay ? 28 : today.day)
        else {
            return CalendarDate(year: 9999, month: 12, day: 31)!
        }
        return leapDay ? sameDateAYearOn : (sameDateAYearOn.adding(days: -1) ?? sameDateAYearOn)
    }
}
