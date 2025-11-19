import XCTest
import SwiftUI
@testable import Countdown

final class AddEditDateSheetTests: XCTestCase {
    private actor DummyRepo: DateOfInterestRepository {
        func fetchAll() async throws -> [DateOfInterest] { [] }
        func add(_ item: DateOfInterest) async throws {}
        func update(_ item: DateOfInterest) async throws {}
        func delete(_ id: UUID) async throws {}
    }
    
    func testBodyRendersInAddAndEditModes() async {
        let repo = DummyRepo()
        let addVM = await AddEditDateViewModel(repository: repo, mode: .add, onCompleted: {})
        _ = AddEditDateSheet(viewModel: addVM).body
        
        let item = DateOfInterest(title: "X", date: Date(), iconSymbolName: "star", entryColorHex: "#FF9500")
        let editVM = await AddEditDateViewModel(repository: repo, mode: .edit(item), onCompleted: {})
        _ = AddEditDateSheet(viewModel: editVM).body
        
        XCTAssertTrue(true)
    }
}


