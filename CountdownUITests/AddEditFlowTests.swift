import XCTest

final class AddEditFlowTests: XCTestCase {
    func testAddFlowCreatesNewItem() {
        let app = XCUIApplication()
        app.launchArguments += ["UITEST_CLEAR_DATA", "UITEST_AUTO_DATE"]
        app.launch()

        // Tap + button
        XCTAssertTrue(app.buttons["add_button"].waitForExistence(timeout: 5))
        app.buttons["add_button"].tap()

        // Fill title
        let titleField = app.textFields["title_field"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 5))
        titleField.tap()
        titleField.typeText("Vacation")

        // Tap Add
        let addButton = app.buttons["add_event_cta"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()

        // Verify item appears in Upcoming
        XCTAssertTrue(app.staticTexts["Vacation"].waitForExistence(timeout: 5))

        // Relaunch to verify persistence
        app.terminate()
        app.launchArguments = []
        app.launch()
        XCTAssertTrue(app.staticTexts["Vacation"].waitForExistence(timeout: 5))
    }
}


