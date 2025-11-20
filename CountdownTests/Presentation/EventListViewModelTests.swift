import XCTest
@testable import Countdown

final class EventListViewModelTests: XCTestCase {
    // MARK: - Doubles
    private actor FakeRepository: EventRepository {
        let items: [Event]
        init(items: [Event]) {
            self.items = items
        }
        func fetchAll() async throws -> [Event] { items }
        func add(_ event: Event) async throws {}
        func update(_ event: Event) async throws {}
        func delete(_ id: UUID) async throws {}
    }

    func testMappingModelToRowViewModel_usesInjectedFormatters() async throws {
        // Given
        let sample = Event(
            id: UUID(uuidString: "AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEEE")!,
            title: "Sample Event",
            date: Date(timeIntervalSince1970: 1_733_404_800), // Arbitrary date
            iconSymbolName: "calendar",
            eventColorHex: "#3366FF",
            createdAt: Date(timeIntervalSince1970: 1_733_318_400)
        )
        let repo = FakeRepository(items: [sample])
        let vm = await EventListViewModel(
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
        _ rows: [EventListViewModel.Row],
        matching sample: Event,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertEqual(rows.count, 1, file: file, line: line)
        let row = rows[0]
        XCTAssertEqual(row.id, sample.id, file: file, line: line)
        XCTAssertEqual(row.title, "Sample Event", file: file, line: line)
        XCTAssertEqual(row.iconSymbolName, "calendar", file: file, line: line)
        XCTAssertEqual(row.eventColorHex, "#3366FF", file: file, line: line)
        XCTAssertEqual(row.dateText, "DATE", file: file, line: line)
    }
}
