import XCTest
@testable import Countdown

final class CountdownNumberTests: XCTestCase {
    private actor FakeRepository: DateOfInterestRepository {
        let items: [DateOfInterest]
        init(items: [DateOfInterest]) { self.items = items }
        func fetchAll() async throws -> [DateOfInterest] { items }
        func add(_ item: DateOfInterest) async throws {}
        func update(_ item: DateOfInterest) async throws {}
    }

    func testFutureShowsPositiveNumber() async {
        let futureDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())!
        let repo = FakeRepository(items: [
            .init(title: "Future", date: futureDate, iconSymbolName: "calendar", entryColorHex: "#0A84FF")
        ])
        let vm = await DateListViewModel(repository: repo)
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
            .init(title: "Past", date: pastDate, iconSymbolName: "calendar", entryColorHex: "#FF3B30")
        ])
        let vm = await DateListViewModel(repository: repo)
        await vm.load()

        // Do the gray-background comparison on the main actor too
        let (daysNumberText, hasGrayBackground) = await MainActor.run { () -> (String?, Bool?) in
            let firstRow = vm.rows.first
            let isGray = firstRow?.backgroundColorHex == DateListViewModel.Row.grayBackgroundColorHex
            return (firstRow?.daysNumberText, isGray)
        }

        XCTAssertEqual(daysNumberText, "- 3")
        XCTAssertTrue(hasGrayBackground == true)
    }

    func testTodayShowsTodayString() async {
        let today = Date()
        let repo = FakeRepository(items: [
            .init(title: "Today", date: today, iconSymbolName: "calendar", entryColorHex: "#34C759")
        ])
        let vm = await DateListViewModel(repository: repo)
        await vm.load()

        let (daysNumberText, backgroundColorHex) = await MainActor.run { () -> (String?, String?) in
            let firstRow = vm.rows.first
            return (firstRow?.daysNumberText, firstRow?.backgroundColorHex)
        }

        XCTAssertEqual(daysNumberText, "Today")
        XCTAssertTrue(backgroundColorHex == "#34C759")
    }
}
