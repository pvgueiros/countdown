import XCTest
@testable import Countdown

final class GetDatesPartitionedEdgeTests: XCTestCase {
    func testSameDateOrdersByCreatedAtAscendingForUpcoming() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let items: [DateOfInterest] = [
            .init(id: UUID(), title: "B", date: today, iconSymbolName: "calendar", entryColorHex: "#0000FF", createdAt: Date().addingTimeInterval(10)),
            .init(id: UUID(), title: "A", date: today, iconSymbolName: "calendar", entryColorHex: "#FF0000", createdAt: Date().addingTimeInterval(0))
        ]
        let sut = GetDatesPartitionedUseCase()
        let result = sut.execute(items: items)
        
        XCTAssertEqual(result.upcoming.count, 2)
        XCTAssertEqual(result.upcoming[0].title, "A")
        XCTAssertEqual(result.upcoming[1].title, "B")
    }
}


