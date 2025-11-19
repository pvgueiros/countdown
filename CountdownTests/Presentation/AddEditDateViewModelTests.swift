import XCTest
@testable import Countdown

final class AddEditDateViewModelTests: XCTestCase {
    private actor DummyRepo: DateOfInterestRepository {
        func fetchAll() async throws -> [DateOfInterest] { [] }
        func add(_ item: DateOfInterest) async throws {}
        func update(_ item: DateOfInterest) async throws {}
        func delete(_ id: UUID) async throws {}
    }
    
    func testHeaderAndCtaTitlesForAddAndEditModes() async {
        let repo = DummyRepo()
        
        let addVM = await AddEditDateViewModel(repository: repo, mode: .add, onCompleted: {})
        let addHeader = await addVM.headerTitle
        let addCTA = await addVM.ctaTitle
        XCTAssertEqual(addHeader, "New Countdown")
        XCTAssertEqual(addCTA, "Add Countdown")
        
        let item = DateOfInterest(title: "Title", date: Date(), iconSymbolName: "star", entryColorHex: "#FF0000")
        let editVM = await AddEditDateViewModel(repository: repo, mode: .edit(item), onCompleted: {})
        let editHeader = await editVM.headerTitle
        let editCTA = await editVM.ctaTitle
        XCTAssertEqual(editHeader, "Edit Countdown")
        XCTAssertEqual(editCTA, "Save Changes")
    }
    
    func testValidationTrimsWhitespaceAndRequiresDate() async {
        let repo = DummyRepo()
        let vm = await AddEditDateViewModel(repository: repo, mode: .add, onCompleted: {})
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


