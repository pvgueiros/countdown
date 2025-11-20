import XCTest
@testable import Countdown

final class RowStylingTests: XCTestCase {
    func testGrayBackgroundReturnsGrayHex() {
        let result = RowStylingRules.badgeColorHex(hasGrayBackground: true, eventColorHex: "#FF0000")
        XCTAssertEqual(result, "#808080")
    }
    
    func testEventColorReturnedWhenNotGrayBackground() {
        let result = RowStylingRules.badgeColorHex(hasGrayBackground: false, eventColorHex: "#123456")
        XCTAssertEqual(result, "#123456")
    }
}


