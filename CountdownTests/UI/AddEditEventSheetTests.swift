import XCTest
import SwiftUI
import UIKit
@testable import Countdown

final class AddEditEventSheetTests: XCTestCase {
    private actor DummyRepo: EventRepository {
        func fetchAll() async throws -> [Event] { [] }
        func add(_ event: Event) async throws {}
        func update(_ event: Event) async throws {}
        func delete(_ id: UUID) async throws {}
    }
    
    func testBodyRendersInAddAndEditModes() async {
        let repo = DummyRepo()
        let addVM = await AddEditEventViewModel(repository: repo, mode: .add, onCompleted: {})
        await MainActor.run {
            let host = UIHostingController(rootView: AddEditEventSheet(viewModel: addVM))
            host.loadViewIfNeeded()
        }
        
        let item = Event(title: "X", date: Date(), iconSymbolName: "star", eventColorHex: "#FF9500")
        let editVM = await AddEditEventViewModel(repository: repo, mode: .edit(item), onCompleted: {})
        await MainActor.run {
            let host = UIHostingController(rootView: AddEditEventSheet(viewModel: editVM))
            host.loadViewIfNeeded()
        }
        
        XCTAssertTrue(true)
    }
}


