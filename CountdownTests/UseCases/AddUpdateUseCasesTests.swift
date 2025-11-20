import XCTest
@testable import Countdown

final class AddUpdateUseCasesTests: XCTestCase {
    actor InMemoryRepo: EventRepository {
        var items: [Event] = []
        func fetchAll() async throws -> [Event] { items }
        func add(_ event: Event) async throws { items.append(event) }
        func update(_ event: Event) async throws {
            if let idx = items.firstIndex(where: { $0.id == event.id }) {
                items[idx] = event
            }
        }
        func delete(_ id: UUID) async throws {
            items.removeAll { $0.id == id }
        }
    }

    func testAddUseCaseAppendsItemAndSetsCreatedAt() async throws {
        let repo = InMemoryRepo()
        let add = await AddEventUseCase(repository: repo)
        let before = try await repo.fetchAll()
        XCTAssertTrue(before.isEmpty)

        try await add.execute(
            title: "New",
            date: Date(),
            iconSymbolName: "star",
            eventColorHex: "#FF9500"
        )
        let after = try await repo.fetchAll()
        XCTAssertEqual(after.count, 1)
        XCTAssertEqual(after.first?.title, "New")
        // createdAt should be set by the use case's initializer default
        XCTAssertNotNil(after.first?.createdAt)
    }

    func testUpdateUseCaseModifiesExistingItem() async throws {
        let repo = InMemoryRepo()
        let initial = Event(title: "Old", date: Date(), iconSymbolName: "star", eventColorHex: "#FF9500")
        try await repo.add(initial)

        let update = await UpdateEventUseCase(repository: repo)
        var updated = initial
        updated.title = "Updated"
        try await update.execute(updated)

        let stored = try await repo.fetchAll()
        XCTAssertEqual(stored.first?.title, "Updated")
        XCTAssertEqual(stored.first?.id, initial.id)
        XCTAssertEqual(stored.count, 1)
    }
}


