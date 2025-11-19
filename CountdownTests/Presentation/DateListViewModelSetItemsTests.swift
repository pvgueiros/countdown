import XCTest
@testable import Countdown

final class DateListViewModelSetItemsTests: XCTestCase {
    private actor DummyRepo: DateOfInterestRepository {
        func fetchAll() async throws -> [DateOfInterest] { [] }
        func add(_ item: DateOfInterest) async throws {}
        func update(_ item: DateOfInterest) async throws {}
        func delete(_ id: UUID) async throws {}
    }
    
    func testSetItemsPartitionsIntoUpcomingAndPast() async {
        let vm = await DateListViewModel(repository: DummyRepo())
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let items: [DateOfInterest] = [
            .init(title: "Future", date: calendar.date(byAdding: .day, value: 2, to: today)!, iconSymbolName: "airplane", entryColorHex: "#0A84FF"),
            .init(title: "Past", date: calendar.date(byAdding: .day, value: -1, to: today)!, iconSymbolName: "clock", entryColorHex: "#FF3B30"),
            .init(title: "Today", date: today, iconSymbolName: "calendar", entryColorHex: "#34C759")
        ]
        await vm.setItems(items)
        
        let (upcoming, past) = await MainActor.run {
            (vm.upcomingRows, vm.pastRows)
        }
        XCTAssertEqual(upcoming.count, 2) // today + future
        XCTAssertEqual(past.count, 1)     // past
    }
}


