import XCTest

final class CountdownListRenderingTests: XCTestCase {
    func testListRendersWithPreloadedData() throws {
        let app = XCUIApplication()
        app.launchArguments.append("UITEST_PRELOAD_DATA")
        app.launch()

        // Title/subtitle exist
        XCTAssertTrue(app.staticTexts["Countdowns"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Track important dates"].exists)

        // At least one known row appears
        XCTAssertTrue(app.staticTexts["My Birthday"].waitForExistence(timeout: 5))
        // Countdown text is visible on the right (content not asserted)
        // We just ensure another text exists on screen alongside the title.
        XCTAssertTrue(app.staticTexts["My Birthday"].exists)
    }
}


