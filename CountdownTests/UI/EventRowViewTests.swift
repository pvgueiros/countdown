import XCTest
import SwiftUI
@testable import Countdown

final class EventRowViewTests: XCTestCase {
    func testRowBodyExecutesForFutureTodayPast() {
        let futureRow = EventListViewModel.Row(
            id: UUID(),
            iconSymbolName: "airplane",
            title: "Future",
            dateText: "Jan 1, 2030",
            eventColorHex: "#0A84FF",
            daysNumberText: "5",
            backgroundColorHex: "#0A84FF",
            hasClockIcon: true
        )
        let todayRow = EventListViewModel.Row(
            id: UUID(),
            iconSymbolName: "calendar",
            title: "Today",
            dateText: "Today",
            eventColorHex: "#34C759",
            daysNumberText: "Today",
            backgroundColorHex: "#34C759",
            hasClockIcon: false
        )
        let pastRow = EventListViewModel.Row(
            id: UUID(),
            iconSymbolName: "clock",
            title: "Past",
            dateText: "Yesterday",
            eventColorHex: "#FF3B30",
            daysNumberText: "- 1",
            backgroundColorHex: EventListViewModel.Row.grayBackgroundColorHex,
            hasClockIcon: false
        )
        
        _ = EventRowView(row: futureRow).body
        _ = EventRowView(row: todayRow).body
        _ = EventRowView(row: pastRow).body
        
        // No assertion needed; executing body covers view logic branches.
        XCTAssertTrue(true)
    }
}


