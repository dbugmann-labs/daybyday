import Foundation
import Testing

@testable import DayByDayKit

@MainActor
private func screen(happeningsAt place: URL) -> CommitmentsScreen {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    return CommitmentsScreen(
        asOf: CalendarDate(year: 2026, month: 10, day: 3)!,
        keepingRosterAt: directory.appendingPathComponent("roster.json"),
        keepingRecordAt: directory.appendingPathComponent("record.json"),
        keepingHappeningsAt: place)
}

private final class Flag: @unchecked Sendable { var raised = false }

@MainActor
@Suite struct CommitmentsScreenStoppedHappeningsTests {
    @Test func stoppedHappeningsFollowsAStopAResumeAndADeletion() throws {
        let place = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
            .appendingPathComponent("happenings.json")
        let screen = screen(happeningsAt: place)
        screen.makeHappening(named: "Dentist")
        let dentist = try #require(screen.happenings.first)
        #expect(screen.stoppedHappenings.isEmpty)

        screen.askToStop(dentist)
        screen.confirmStoppingHappening()
        #expect(screen.stoppedHappenings == [dentist])
        #expect(screen.isStopped(dentist))

        screen.resume(dentist)
        #expect(screen.stoppedHappenings.isEmpty)
        #expect(!screen.isStopped(dentist))

        screen.askToStop(dentist)
        screen.confirmStoppingHappening()
        screen.askToDelete(dentist)
        screen.happeningNameTypedBack = "Dentist"
        screen.confirmDeletingHappening()
        #expect(screen.stoppedHappenings.isEmpty)
    }

    @Test func stoppedHappeningsIsObservedWhenAHappeningIsStopped() throws {
        let place = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
            .appendingPathComponent("happenings.json")
        let screen = screen(happeningsAt: place)
        screen.makeHappening(named: "Dentist")
        let dentist = try #require(screen.happenings.first)

        let changed = Flag()
        withObservationTracking {
            _ = screen.stoppedHappenings
        } onChange: {
            changed.raised = true
        }
        screen.askToStop(dentist)
        screen.confirmStoppingHappening()
        #expect(changed.raised)
    }
}
