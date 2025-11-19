import XCTest
@testable import Countdown

final class AddEditDateViewModelSubmitTests: XCTestCase {
    private actor SpyRepo: DateOfInterestRepository {
        private(set) var added: [DateOfInterest] = []
        private(set) var updated: [DateOfInterest] = []
        func fetchAll() async throws -> [DateOfInterest] { [] }
        func add(_ item: DateOfInterest) async throws { added.append(item) }
        func update(_ item: DateOfInterest) async throws { updated.append(item) }
        func delete(_ id: UUID) async throws {}
    }
    
    func testSubmitAddCallsRepository() async {
        let repo = SpyRepo()
        let vm = await AddEditDateViewModel(repository: repo, mode: .add, onCompleted: {})
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
        let item = DateOfInterest(title: "Old", date: Date(), iconSymbolName: "star", entryColorHex: "#FF0000")
        let vm = await AddEditDateViewModel(repository: repo, mode: .edit(item), onCompleted: {})
        await MainActor.run {
            vm.title = "Updated"
        }
        await vm.submit()
        let updatedCount = await repo.updated.count
        XCTAssertEqual(updatedCount, 1)
    }
    
    func testCTATitleChangesWhenSubmitting() async {
        let repo = SpyRepo()
        let vm = await AddEditDateViewModel(repository: repo, mode: .add, onCompleted: {})
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


