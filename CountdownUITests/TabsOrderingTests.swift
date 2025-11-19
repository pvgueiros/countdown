import XCTest

final class TabsOrderingTests: XCTestCase {
    func testSwitchingTabsShowsDifferentContent() {
        let app = XCUIApplication()
        app.launchArguments.append("UITEST_PRELOAD_DATA")
        app.launch()

        // Expect segment exists
        let segmented = app.segmentedControls.firstMatch
        XCTAssertTrue(segmented.waitForExistence(timeout: 5))

        // Default should be Upcoming: should contain a future/today sample like "Conference"
        XCTAssertTrue(app.staticTexts["Conference"].waitForExistence(timeout: 5))

        // Tap Past segment
        if segmented.buttons["Past"].exists {
            segmented.buttons["Past"].tap()
        }

        // Now expect a past sample like "Travel" to be visible
        XCTAssertTrue(app.staticTexts["Travel"].waitForExistence(timeout: 5))
    }
}


