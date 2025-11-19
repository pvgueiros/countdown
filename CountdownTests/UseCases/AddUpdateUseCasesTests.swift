import XCTest
@testable import Countdown

final class AddUpdateUseCasesTests: XCTestCase {
    actor InMemoryRepo: DateOfInterestRepository {
        var items: [DateOfInterest] = []
        func fetchAll() async throws -> [DateOfInterest] { items }
        func add(_ item: DateOfInterest) async throws { items.append(item) }
        func update(_ item: DateOfInterest) async throws {
            if let idx = items.firstIndex(where: { $0.id == item.id }) {
                items[idx] = item
            }
        }
        func delete(_ id: UUID) async throws {
            items.removeAll { $0.id == id }
        }
    }

    func testAddUseCaseAppendsItemAndSetsCreatedAt() async throws {
        let repo = InMemoryRepo()
        let add = await AddDateOfInterestUseCase(repository: repo)
        let before = try await repo.fetchAll()
        XCTAssertTrue(before.isEmpty)

        try await add.execute(
            title: "New",
            date: Date(),
            iconSymbolName: "star",
            entryColorHex: "#FF9500"
        )
        let after = try await repo.fetchAll()
        XCTAssertEqual(after.count, 1)
        XCTAssertEqual(after.first?.title, "New")
        // createdAt should be set by the use case's initializer default
        XCTAssertNotNil(after.first?.createdAt)
    }

    func testUpdateUseCaseModifiesExistingItem() async throws {
        let repo = InMemoryRepo()
        let initial = DateOfInterest(title: "Old", date: Date(), iconSymbolName: "star", entryColorHex: "#FF9500")
        try await repo.add(initial)

        let update = await UpdateDateOfInterestUseCase(repository: repo)
        var updated = initial
        updated.title = "Updated"
        try await update.execute(updated)

        let stored = try await repo.fetchAll()
        XCTAssertEqual(stored.first?.title, "Updated")
        XCTAssertEqual(stored.first?.id, initial.id)
        XCTAssertEqual(stored.count, 1)
    }
}


