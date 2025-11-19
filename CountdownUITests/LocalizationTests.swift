import XCTest

final class LocalizationTests: XCTestCase {
    func testPortugueseHeaderAppears() {
        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(pt-BR)", "-AppleLocale", "pt_BR", "UITEST_CLEAR_DATA"]
        app.launch()
        
        // Header localized
        XCTAssertTrue(app.staticTexts["Contagens regressivas"].waitForExistence(timeout: 5))
    }
}


