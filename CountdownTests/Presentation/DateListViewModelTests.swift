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
        let vm = await DateListViewModel(
            repository: repo,
            dateString: { _ in "DATE" }
        )

        // When
        await vm.load()
        let rows = await vm.rows

        // Then
        assertRows(rows, matching: sample)
    }

    // MARK: - Helpers (synchronous)
    private func assertRows(
        _ rows: [DateListViewModel.Row],
        matching sample: DateOfInterest,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertEqual(rows.count, 1, file: file, line: line)
        let row = rows[0]
        XCTAssertEqual(row.id, sample.id, file: file, line: line)
        XCTAssertEqual(row.title, "Sample Event", file: file, line: line)
        XCTAssertEqual(row.iconSymbolName, "calendar", file: file, line: line)
        XCTAssertEqual(row.entryColorHex, "#3366FF", file: file, line: line)
        XCTAssertEqual(row.dateText, "DATE", file: file, line: line)
    }
}
