import XCTest
@testable import Countdown

final class DateListViewModelTests: XCTestCase {
    // MARK: - Doubles
    private actor FakeRepository: DateOfInterestRepository {
        let items: [DateOfInterest]
        init(items: [DateOfInterest]) {
            self.items = items
        }
        func fetchAll() async throws -> [DateOfInterest] { items }
        func add(_ item: DateOfInterest) async throws {}
        func update(_ item: DateOfInterest) async throws {}
    }

    func testMappingModelToRowViewModel_usesInjectedFormatters() async throws {
        // Given
        let sample = DateOfInterest(
            id: UUID(uuidString: "AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEEE")!,
            title: "Sample Event",
            date: Date(timeIntervalSince1970: 1_733_404_800), // Arbitrary date
            iconSymbolName: "calendar",
            entryColorHex: "#3366FF",
            createdAt: Date(timeIntervalSince1970: 1_733_318_400)
        )
        let repo = FakeRepository(items: [sample])
        let vm = DateListViewModel(
            repository: repo,
            dateString: { _ in "DATE" },
            countdownString: { _ in "COUNTDOWN" }
        )

        // When
        await vm.load()

        // Then
        XCTAssertEqual(vm.rows.count, 1)
        let row = vm.rows[0]
        XCTAssertEqual(row.id, sample.id)
        XCTAssertEqual(row.title, "Sample Event")
        XCTAssertEqual(row.iconSymbolName, "calendar")
        XCTAssertEqual(row.entryColorHex, "#3366FF")
        XCTAssertEqual(row.dateText, "DATE")
        XCTAssertEqual(row.countdownText, "COUNTDOWN")
    }
}


