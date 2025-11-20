import XCTest
@testable import Countdown

final class EventListViewModelErrorTests: XCTestCase {
    private enum FakeError: Error { case boom }
    
    private actor ThrowingRepo: EventRepository {
        func fetchAll() async throws -> [Event] { throw FakeError.boom }
        func add(_ event: Event) async throws {}
        func update(_ event: Event) async throws {}
        func delete(_ id: UUID) async throws {}
    }
    
    func testLoadFailureClearsState() async {
        let vm = await EventListViewModel(repository: ThrowingRepo())
        await vm.load()
        
        let (rows, items, upcoming, past) = await MainActor.run {
            (vm.rows, vm.items, vm.upcomingRows, vm.pastRows)
        }
        XCTAssertTrue(rows.isEmpty)
        XCTAssertTrue(items.isEmpty)
        XCTAssertTrue(upcoming.isEmpty)
        XCTAssertTrue(past.isEmpty)
    }
}


