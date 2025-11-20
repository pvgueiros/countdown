import XCTest
@testable import Countdown

final class CountdownNumberTests: XCTestCase {
    private actor FakeRepository: EventRepository {
        func delete(_ id: UUID) async throws {}
        let items: [Event]
        init(items: [Event]) { self.items = items }
        func fetchAll() async throws -> [Event] { items }
        func add(_ event: Event) async throws {}
        func update(_ event: Event) async throws {}
    }

    func testFutureShowsPositiveNumber() async {
        let futureDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())!
        let repo = FakeRepository(items: [
            .init(title: "Future", date: futureDate, iconSymbolName: "calendar", eventColorHex: "#0A84FF")
        ])
        let vm = await EventListViewModel(repository: repo)
        await vm.load()

        // Hop to main actor, read scalar values there
        let (daysNumberText, backgroundColorHex) = await MainActor.run { () -> (String?, String?) in
            let firstRow = vm.rows.first
            return (firstRow?.daysNumberText, firstRow?.backgroundColorHex)
        }

        XCTAssertEqual(daysNumberText, "5")
        XCTAssertTrue(backgroundColorHex == "#0A84FF")
    }

    func testPastShowsNegativeNumber() async {
        let pastDate = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
        let repo = FakeRepository(items: [
            .init(title: "Past", date: pastDate, iconSymbolName: "calendar", eventColorHex: "#FF3B30")
        ])
        let vm = await EventListViewModel(repository: repo)
        await vm.load()

        // Do the gray-background comparison on the main actor too
        let (daysNumberText, hasGrayBackground) = await MainActor.run { () -> (String?, Bool?) in
            let firstRow = vm.rows.first
            let isGray = firstRow?.backgroundColorHex == EventListViewModel.Row.grayBackgroundColorHex
            return (firstRow?.daysNumberText, isGray)
        }

        XCTAssertEqual(daysNumberText, "- 3")
        XCTAssertTrue(hasGrayBackground == true)
    }

    func testTodayShowsTodayString() async {
        let today = Date()
        let repo = FakeRepository(items: [
            .init(title: "Today", date: today, iconSymbolName: "calendar", eventColorHex: "#34C759")
        ])
        let vm = await EventListViewModel(repository: repo)
        await vm.load()

        let (daysNumberText, backgroundColorHex) = await MainActor.run { () -> (String?, String?) in
            let firstRow = vm.rows.first
            return (firstRow?.daysNumberText, firstRow?.backgroundColorHex)
        }

        XCTAssertEqual(daysNumberText, "Today")
        XCTAssertTrue(backgroundColorHex == "#34C759")
    }
}
