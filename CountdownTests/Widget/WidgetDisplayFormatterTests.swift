import XCTest
@testable import Countdown

final class WidgetDisplayFormatterTests: XCTestCase {
    private let calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        return cal
    }()

    private func makeDate(year: Int, month: Int, day: Int) -> Date {
        let comps = DateComponents(calendar: calendar, timeZone: calendar.timeZone, year: year, month: month, day: day)
        return calendar.date(from: comps)!
    }

    private func makeItem(title: String, date: Date) -> DateOfInterest {
        DateOfInterest(title: title, date: date, iconSymbolName: "calendar", entryColorHex: "#FF00FF")
    }

    func testTodayDisplaysToday() {
        let now = makeDate(year: 2025, month: 11, day: 19)
        let item = makeItem(title: "Today", date: now)
        let sut = WidgetDisplayFormatter()

        let display = sut.makeDisplay(for: item, now: now, calendar: calendar)
        XCTAssertEqual(display.countdownText, "Today")
    }

    func testFutureDateDisplaysPositiveDays() {
        let now = makeDate(year: 2025, month: 11, day: 19)
        let target = makeDate(year: 2025, month: 11, day: 25) // +6 days
        let item = makeItem(title: "Future", date: target)
        let sut = WidgetDisplayFormatter()

        let display = sut.makeDisplay(for: item, now: now, calendar: calendar)
        XCTAssertEqual(display.countdownText, "6")
    }

    func testPastDateDisplaysNegativeDaysWithDash() {
        let now = makeDate(year: 2025, month: 11, day: 19)
        let target = makeDate(year: 2025, month: 11, day: 10) // -9 days
        let item = makeItem(title: "Past", date: target)
        let sut = WidgetDisplayFormatter()

        let display = sut.makeDisplay(for: item, now: now, calendar: calendar)
        XCTAssertEqual(display.countdownText, "- 9")
    }
}


