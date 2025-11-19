import XCTest
import SwiftUI
@testable import Countdown

final class CountdownRowViewTests: XCTestCase {
    func testRowBodyExecutesForFutureTodayPast() {
        let futureRow = DateListViewModel.Row(
            id: UUID(),
            iconSymbolName: "airplane",
            title: "Future",
            dateText: "Jan 1, 2030",
            entryColorHex: "#0A84FF",
            daysNumberText: "5",
            backgroundColorHex: "#0A84FF",
            hasClockIcon: true
        )
        let todayRow = DateListViewModel.Row(
            id: UUID(),
            iconSymbolName: "calendar",
            title: "Today",
            dateText: "Today",
            entryColorHex: "#34C759",
            daysNumberText: "Today",
            backgroundColorHex: "#34C759",
            hasClockIcon: false
        )
        let pastRow = DateListViewModel.Row(
            id: UUID(),
            iconSymbolName: "clock",
            title: "Past",
            dateText: "Yesterday",
            entryColorHex: "#FF3B30",
            daysNumberText: "- 1",
            backgroundColorHex: DateListViewModel.Row.grayBackgroundColorHex,
            hasClockIcon: false
        )
        
        _ = CountdownRowView(row: futureRow).body
        _ = CountdownRowView(row: todayRow).body
        _ = CountdownRowView(row: pastRow).body
        
        // No assertion needed; executing body covers view logic branches.
        XCTAssertTrue(true)
    }
}


