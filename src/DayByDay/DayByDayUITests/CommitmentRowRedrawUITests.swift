import XCTest

/// Regression coverage for `tasks.md` § 14.4 of `give-a-commitment-an-identity` (#303): a rename
/// kept through the commitments screen's sheet must redraw the kept list's own row without
/// leaving the screen and coming back. `Commitment`'s equality is the identity alone (this
/// Story), so a `ForEach` keyed on the commitment value never reconfigured a row whose name or
/// rhythm changed but whose identity did not — the seam was always right, `screen.kept` read the
/// new name the moment the change was kept, but the row and a reopened sheet's title went on
/// reading the old one. No test at the seam can catch this; it is a fact about what SwiftUI
/// draws, which is what this layer exists for — `WalkthroughUITests.swift`'s own doc comment.
final class CommitmentRowRedrawUITests: XCTestCase {
    @MainActor
    func testARenamedRowRedrawsWithoutLeavingTheScreen() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["Commitments"].tap()
        XCTAssertTrue(
            app.navigationBars["Commitments"].waitForExistence(timeout: 30),
            "the commitments screen did not open")

        let gymRow = app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'Gym'")).firstMatch
        XCTAssertTrue(gymRow.waitForExistence(timeout: 30), "no Gym row on a fresh install")
        gymRow.swipeRight()
        app.buttons["Edit"].tap()

        let nameField = app.textFields["Name"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 30), "the change sheet did not open")
        nameField.tap()
        nameField.press(forDuration: 1.5)
        let selectAll = app.menuItems["Select All"]
        XCTAssertTrue(selectAll.waitForExistence(timeout: 10), "no Select All menu item on the Name field")
        selectAll.tap()
        nameField.typeText("Lifting")
        XCTAssertEqual(
            nameField.value as? String, "Lifting",
            "typing \"Lifting\" did not replace the Name field's text")
        app.buttons["Save"].tap()

        XCTAssertTrue(
            app.navigationBars["Commitments"].waitForExistence(timeout: 30),
            "did not return after the rename")

        // No navigation since the save — this is the same screen the rename was made on.
        let liftingRow = app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'Lifting'")).firstMatch
        XCTAssertTrue(
            liftingRow.waitForExistence(timeout: 10),
            "the kept list row did not redraw under the new name")
    }
}
