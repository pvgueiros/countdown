import XCTest
@testable import Countdown

final class GetDatesPartitionedUseCaseTests: XCTestCase {
    func testPartitionsUpcomingAndPastWithSortAndTieBreaker() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dPast1 = calendar.date(byAdding: .day, value: -1, to: today)!
        let dPast2 = calendar.date(byAdding: .day, value: -5, to: today)!
        let dFuture1 = calendar.date(byAdding: .day, value: 0, to: today)! // today counts as upcoming
        let dFuture2 = calendar.date(byAdding: .day, value: 3, to: today)!

        // Same-date tie-breaker for upcoming
        let createdOld = Date(timeIntervalSince1970: 1_700_000_000)
        let createdNew = Date(timeIntervalSince1970: 1_800_000_000)

        let items: [DateOfInterest] = [
            .init(id: UUID(), title: "Past 5", date: dPast2, iconSymbolName: "calendar", entryColorHex: "#AAAAAA", createdAt: createdOld),
            .init(id: UUID(), title: "Past 1", date: dPast1, iconSymbolName: "calendar", entryColorHex: "#BBBBBB", createdAt: createdNew),
            .init(id: UUID(), title: "Today old", date: dFuture1, iconSymbolName: "calendar", entryColorHex: "#CCCCCC", createdAt: createdOld),
            .init(id: UUID(), title: "Today new", date: dFuture1, iconSymbolName: "calendar", entryColorHex: "#DDDDDD", createdAt: createdNew),
            .init(id: UUID(), title: "Future 3", date: dFuture2, iconSymbolName: "calendar", entryColorHex: "#EEEEEE", createdAt: createdOld),
        ]

        let uc = GetDatesPartitionedUseCase()
        let (upcoming, past) = uc.execute(items: items, calendar: calendar)

        // Upcoming sorted: today (oldest created first), then future ascending
        XCTAssertEqual(upcoming.map { $0.title }, ["Today old", "Today new", "Future 3"])
        // Past sorted: most recent past first (desc by date)
        XCTAssertEqual(past.map { $0.title }, ["Past 1", "Past 5"])
    }
}


