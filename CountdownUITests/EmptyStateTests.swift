import XCTest

final class EmptyStateTests: XCTestCase {
    func testShowsEmptyStateWhenNoItems() {
        let app = XCUIApplication()
        app.launchArguments.append("UITEST_CLEAR_DATA")
        // DO NOT add preload arg so dataset stays empty
        app.launch()

        XCTAssertTrue(app.staticTexts["Countdown"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.otherElements["empty_state_message"].waitForExistence(timeout: 5))
    }
}


