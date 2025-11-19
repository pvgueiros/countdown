import XCTest
@testable import Countdown

final class DateListViewModelErrorTests: XCTestCase {
    private enum FakeError: Error { case boom }
    
    private actor ThrowingRepo: DateOfInterestRepository {
        func fetchAll() async throws -> [DateOfInterest] { throw FakeError.boom }
        func add(_ item: DateOfInterest) async throws {}
        func update(_ item: DateOfInterest) async throws {}
        func delete(_ id: UUID) async throws {}
    }
    
    func testLoadFailureClearsState() async {
        let vm = await DateListViewModel(repository: ThrowingRepo())
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


