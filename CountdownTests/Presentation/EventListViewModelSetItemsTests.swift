import XCTest
@testable import Countdown

final class EventListViewModelSetItemsTests: XCTestCase {
    private actor DummyRepo: EventRepository {
        func fetchAll() async throws -> [Event] { [] }
        func add(_ event: Event) async throws {}
        func update(_ event: Event) async throws {}
        func delete(_ id: UUID) async throws {}
    }
    
    func testSetItemsPartitionsIntoUpcomingAndPast() async {
        let vm = await EventListViewModel(repository: DummyRepo())
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let items: [Event] = [
            .init(title: "Future", date: calendar.date(byAdding: .day, value: 2, to: today)!, iconSymbolName: "airplane", eventColorHex: "#0A84FF"),
            .init(title: "Past", date: calendar.date(byAdding: .day, value: -1, to: today)!, iconSymbolName: "clock", eventColorHex: "#FF3B30"),
            .init(title: "Today", date: today, iconSymbolName: "calendar", eventColorHex: "#34C759")
        ]
        await vm.setItems(items)
        
        let (upcoming, past) = await MainActor.run {
            (vm.upcomingRows, vm.pastRows)
        }
        XCTAssertEqual(upcoming.count, 2) // today + future
        XCTAssertEqual(past.count, 1)     // past
    }
}


