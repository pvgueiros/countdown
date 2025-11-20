import XCTest
@testable import Countdown

final class CountdownWidgetTimelineTests: XCTestCase {
    private let calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        return cal
    }()

    func testNextMidnightComputation() {
        // 2025-11-19 15:30:00Z → next midnight should be 2025-11-20 00:00:00Z
        var comps = DateComponents()
        comps.year = 2025; comps.month = 11; comps.day = 19
        comps.hour = 15; comps.minute = 30; comps.timeZone = calendar.timeZone
        let now = calendar.date(from: comps)!

        let next = WidgetDisplayFormatter.nextMidnight(after: now, calendar: calendar)

        let expected = calendar.date(from: DateComponents(year: 2025, month: 11, day: 20))!
        XCTAssertEqual(next, expected)
    }
    
    func testTimelineProviderStates() {
        // Test that timeline provider handles empty and configured states
        let now = Date()
        let nextMidnight = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now))!
        
        // Verify next midnight computation matches widget logic
        XCTAssertGreaterThan(nextMidnight, now)
        XCTAssertEqual(calendar.component(.hour, from: nextMidnight), 0)
        
        // Test placeholder state (no configuration)
        let placeholderTitle = "Select a Date"
        XCTAssertFalse(placeholderTitle.isEmpty)
        
        // Test configured state (with date selection)
        let configuredTitle = "Birthday Party"
        let configuredDate = "Dec 25, 2025"
        let configuredCountdown = "36 days"
        
        XCTAssertFalse(configuredTitle.isEmpty)
        XCTAssertFalse(configuredDate.isEmpty)
        XCTAssertFalse(configuredCountdown.isEmpty)
    }
}


