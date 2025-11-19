import XCTest

final class PerformanceScrollingTests: XCTestCase {
    func testSmoothScrollingWithHundredItems() {
        let app = XCUIApplication()
        app.launchArguments += ["UITEST_CLEAR_DATA", "UITEST_PRELOAD_100"]
        app.launch()

        // Wait for the screen to finish loading (segment should appear)
        let segmented = app.segmentedControls.firstMatch
        XCTAssertTrue(segmented.waitForExistence(timeout: 10))

        // SwiftUI List may expose as UITableView or UICollectionView depending on OS
        let table = app.tables.firstMatch
        let collection = app.collectionViews.firstMatch
        let scroll = app.scrollViews.firstMatch
        let container: XCUIElement
        if table.exists {
            container = table
        } else if collection.exists {
            container = collection
        } else {
            container = scroll
        }
        XCTAssertTrue(container.waitForExistence(timeout: 10))

        // Measure time/CPU/memory while performing multiple scrolls through the list
        measure(metrics: [XCTClockMetric(), XCTCPUMetric(), XCTMemoryMetric()]) {
            for _ in 0..<6 {
                container.swipeUp()
            }
            for _ in 0..<3 {
                container.swipeDown()
            }
        }
        
        // Verify a late item can be reached to ensure list is responsive
        let lastCell = app.staticTexts["Item 99"]
        // Try a few extra swipes to ensure we hit the bottom
        for _ in 0..<6 where !lastCell.exists {
            container.swipeUp()
        }
        XCTAssertTrue(lastCell.waitForExistence(timeout: 5))
    }
}


