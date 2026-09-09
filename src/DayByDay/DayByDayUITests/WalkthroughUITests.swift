import XCTest

/// The UI smoke layer: proof that SwiftUI drew something, which no test at the `DayByDayKit` seam
/// can give. `docs/open-questions.md` § *No UI smoke layer* is the gap this closes, and it is
/// deliberately thin — a row left blank by a misspelled binding is the failure it exists to catch.
/// The day screen's *rules* are specified and tested behind the seam and are not retested here.
///
/// **XCTest rather than Swift Testing, and that is not a preference.** Xcode compiles a UI testing
/// bundle with `-module-alias Testing=_Testing_Unavailable`, so `import Testing` fails outright
/// with `Unable to resolve module dependency: '_Testing_Unavailable'`. Measured on this project,
/// 2026-09-06, Xcode 26.6. It is why CI check 4 cannot see these test names and why the ADR beside
/// this file has to say what happens instead.
final class WalkthroughUITests: XCTestCase {
    /// The whole smoke layer in one launch. Kept as a single test on purpose: each XCUITest case
    /// relaunches the app, which costs about half a minute, and nothing here needs isolation.
    /// `@MainActor` because `XCUIApplication.init` is main-actor-isolated and this target builds
    /// under Swift 6 language mode; without it the call is a concurrency warning, which CI showed
    /// and a local run filtered for errors did not.
    @MainActor
    func testTheDayScreenDraws() {
        let app = XCUIApplication()
        app.launch()

        // Moved a day back before either assertion below, so the *Today* button is proved rather
        // than assumed: `add-offered-today-control` (#174) hides it on the today the screen was
        // handed, and this is the one control this smoke layer would otherwise never see drawn.
        // The move itself is ADR-1042's horizontal swipe on the list, the same recognizer a row
        // that offers nothing still sits under.
        let list = app.collectionViews.firstMatch
        _ = list.waitForExistence(timeout: 60)
        list.swipeRight()

        // The three fixed controls of the day screen. If the body failed to build, or a binding
        // was misspelled so a subtree never rendered, this is where it shows.
        XCTAssertTrue(
            app.buttons["Today"].waitForExistence(timeout: 60),
            "the day screen drew no Today button")

        // A row for something the day-one week asks for. Which commitments are due on the day the
        // test happens to run is the kit's business and changes with the calendar, so this asserts
        // that *some* row was drawn rather than naming one — the misspelled-binding failure is a
        // list with nothing in it, not a list with the wrong thing in it.
        let rows = app.collectionViews.buttons
        XCTAssertGreaterThan(
            rows.count, 0, "the day screen drew no commitment rows at all")
    }
}
