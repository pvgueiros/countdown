import XCTest

final class DeleteFlowTests: XCTestCase {
    func testSwipeToDeleteRemovesItem() {
        let app = XCUIApplication()
        app.launchArguments += ["UITEST_PRELOAD_DATA"]
        app.launch()
        
        // Ensure an item exists (from preload)
        let target = app.staticTexts["Conference"]
        XCTAssertTrue(target.waitForExistence(timeout: 5))
        
        // Swipe to delete on the row containing the target title
        target.swipeLeft()
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 3))
        deleteButton.tap()
        
        // Confirm alert
        let deleteAlertButton = app.alerts.firstMatch.buttons["Delete"]
        if deleteAlertButton.waitForExistence(timeout: 3) {
            deleteAlertButton.tap()
        }
        
        // Verify it's gone (allow some time for reload)
        XCTAssertFalse(target.waitForExistence(timeout: 3))
    }
}


