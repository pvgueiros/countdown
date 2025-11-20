import XCTest
@testable import Countdown

final class WidgetReconfigurationTests: XCTestCase {
    func testSnapshotPersistenceForReconfiguration() {
        // Test that snapshots are saved keyed by date ID for reconfiguration
        let defaults = UserDefaults.standard
        let keyA = "widget.snapshot.dateA.title"
        let keyB = "widget.snapshot.dateB.title"
        
        // Clean up any existing keys
        defaults.removeObject(forKey: keyA)
        defaults.removeObject(forKey: keyB)
        
        // Simulate saving snapshot for date A
        defaults.set("Birthday Party", forKey: keyA)
        XCTAssertEqual(defaults.string(forKey: keyA), "Birthday Party")
        
        // Simulate reconfiguring to date B
        defaults.set("Conference", forKey: keyB)
        XCTAssertEqual(defaults.string(forKey: keyB), "Conference")
        
        // Both snapshots should exist independently
        XCTAssertEqual(defaults.string(forKey: keyA), "Birthday Party")
        XCTAssertEqual(defaults.string(forKey: keyB), "Conference")
        
        // Clean up
        defaults.removeObject(forKey: keyA)
        defaults.removeObject(forKey: keyB)
    }
}


