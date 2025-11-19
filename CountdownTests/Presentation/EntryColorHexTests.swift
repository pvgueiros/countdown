import XCTest
import SwiftUI
@testable import Countdown

final class EntryColorHexTests: XCTestCase {
    func testValidHexParsesToColor() {
        let color = Color(hex: "#3366FF")
        XCTAssertNotNil(color)
    }
    
    func testInvalidHexReturnsNil() {
        let color = Color(hex: "ZZZZZZ")
        XCTAssertNil(color)
    }
}


