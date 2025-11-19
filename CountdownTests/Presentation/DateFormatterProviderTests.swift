import XCTest
@testable import Countdown

final class DateFormatterProviderTests: XCTestCase {
    func testMediumFormatterProducesNonEmptyOutputAndVariesAcrossDates() {
        let df = DateFormatterProvider.mediumLocaleFormatter()
        let d1 = Date(timeIntervalSince1970: 0) // Jan 1, 1970
        let d2 = Date(timeIntervalSince1970: 60 * 60 * 24 * 7) // Jan 8, 1970
        
        let s1 = df.string(from: d1)
        let s2 = df.string(from: d2)
        
        XCTAssertFalse(s1.isEmpty)
        XCTAssertFalse(s2.isEmpty)
        XCTAssertNotEqual(s1, s2)
    }
}


