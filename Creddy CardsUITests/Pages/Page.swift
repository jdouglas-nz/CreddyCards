//

import XCTest

class Page {
    
    let application: XCUIApplication
    
    init(application: XCUIApplication) {
        self.application = application
    }
    
    func navigateBack() {
        application.navigationBars.firstMatch.buttons.firstMatch.tap()
    }
}
