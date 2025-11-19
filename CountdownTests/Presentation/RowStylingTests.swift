import XCTest
@testable import Countdown

final class RowStylingTests: XCTestCase {
    func testGrayBackgroundReturnsGrayHex() {
        let result = RowStylingRules.badgeColorHex(hasGrayBackground: true, entryColorHex: "#FF0000")
        XCTAssertEqual(result, "#808080")
    }
    
    func testEntryColorReturnedWhenNotGrayBackground() {
        let result = RowStylingRules.badgeColorHex(hasGrayBackground: false, entryColorHex: "#123456")
        XCTAssertEqual(result, "#123456")
    }
}


