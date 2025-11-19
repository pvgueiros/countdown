import XCTest
@testable import Countdown

final class UserDefaultsRepositoryTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Clear key used by repository to isolate tests
        UserDefaults.standard.removeObject(forKey: "datesOfInterest")
    }
    
    override func tearDown() {
        // Clean up after tests
        UserDefaults.standard.removeObject(forKey: "datesOfInterest")
        super.tearDown()
    }
    
    func testAddFetchUpdateDelete() async throws {
        let repo = await UserDefaultsDateOfInterestRepository()
        
        // Initially empty
        var items = try await repo.fetchAll()
        XCTAssertEqual(items.count, 0)
        
        // Add one
        let original = DateOfInterest(title: "Title", date: Date(), iconSymbolName: "star", entryColorHex: "#00FF00")
        try await repo.add(original)
        
        items = try await repo.fetchAll()
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.title, "Title")
        
        // Update
        var updated = original
        updated = DateOfInterest(id: original.id, title: "Updated", date: original.date, iconSymbolName: original.iconSymbolName, entryColorHex: original.entryColorHex, createdAt: original.createdAt)
        try await repo.update(updated)
        
        items = try await repo.fetchAll()
        XCTAssertEqual(items.first?.title, "Updated")
        
        // Delete
        try await repo.delete(updated.id)
        items = try await repo.fetchAll()
        XCTAssertEqual(items.count, 0)
    }
}


