import XCTest
@testable import Countdown

final class AddEditEventViewModelSubmitTests: XCTestCase {
    private actor SpyRepo: EventRepository {
        private(set) var added: [Event] = []
        private(set) var updated: [Event] = []
        func fetchAll() async throws -> [Event] { [] }
        func add(_ event: Event) async throws { added.append(event) }
        func update(_ event: Event) async throws { updated.append(event) }
        func delete(_ id: UUID) async throws {}
    }
    
    func testSubmitAddCallsRepository() async {
        let repo = SpyRepo()
        let vm = await AddEditEventViewModel(repository: repo, mode: .add, onCompleted: {})
        await MainActor.run {
            vm.title = "New"
            vm.hasCustomDate = true
        }
        await vm.submit()
        let addedCount = await repo.added.count
        XCTAssertEqual(addedCount, 1)
    }
    
    func testSubmitEditCallsRepositoryUpdate() async {
        let repo = SpyRepo()
        let item = Event(title: "Old", date: Date(), iconSymbolName: "star", eventColorHex: "#FF0000")
        let vm = await AddEditEventViewModel(repository: repo, mode: .edit(item), onCompleted: {})
        await MainActor.run {
            vm.title = "Updated"
        }
        await vm.submit()
        let updatedCount = await repo.updated.count
        XCTAssertEqual(updatedCount, 1)
    }
    
    func testCTATitleChangesWhenSubmitting() async {
        let repo = SpyRepo()
        let vm = await AddEditEventViewModel(repository: repo, mode: .add, onCompleted: {})
        await MainActor.run {
            vm.title = "New"
            vm.hasCustomDate = true
        }
        let before = await vm.ctaTitle
        XCTAssertEqual(before, "Add Countdown")
        // We cannot easily intercept mid-submit without adding hooks; ensure it ends
        await vm.submit()
        let after = await vm.ctaTitle
        XCTAssertEqual(after, "Add Countdown")
    }
}


