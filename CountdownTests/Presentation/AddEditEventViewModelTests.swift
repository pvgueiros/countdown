import XCTest
@testable import Countdown

final class AddEditEventViewModelTests: XCTestCase {
    private actor DummyRepo: EventRepository {
        func fetchAll() async throws -> [Event] { [] }
        func add(_ event: Event) async throws {}
        func update(_ event: Event) async throws {}
        func delete(_ id: UUID) async throws {}
    }
    
    func testHeaderAndCtaTitlesForAddAndEditModes() async {
        let repo = DummyRepo()
        
        let addVM = await AddEditEventViewModel(repository: repo, mode: .add, onCompleted: {})
        let addHeader = await addVM.headerTitle
        let addCTA = await addVM.ctaTitle
        XCTAssertEqual(addHeader, "New Event")
        XCTAssertEqual(addCTA, "Add Event")
        
        let item = Event(title: "Title", date: Date(), iconSymbolName: "star", eventColorHex: "#FF0000")
        let editVM = await AddEditEventViewModel(repository: repo, mode: .edit(item), onCompleted: {})
        let editHeader = await editVM.headerTitle
        let editCTA = await editVM.ctaTitle
        XCTAssertEqual(editHeader, "Edit Event")
        XCTAssertEqual(editCTA, "Save Changes")
    }
    
    func testValidationTrimsWhitespaceAndRequiresDate() async {
        let repo = DummyRepo()
        let vm = await AddEditEventViewModel(repository: repo, mode: .add, onCompleted: {})
        await MainActor.run {
            vm.title = "   "
            // hasCustomDate is true by default for add mode, per implementation
        }
        let valid1 = await vm.isValid
        XCTAssertFalse(valid1)
        
        await MainActor.run {
            vm.title = "  Event  "
        }
        let valid2 = await vm.isValid
        XCTAssertTrue(valid2)
    }
}


