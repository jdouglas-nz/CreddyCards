//

import XCTest

class CardsListPage: Page {
    
    var list: XCUIElement {
        application.collectionViews["Sidebar"]
    }
    
    func waitForListToLoad() {
        let exists = list.waitForExistence(timeout: 5)
        XCTAssertTrue(exists)
    }
    
    func clickFirstElement() -> CardDetailsPage {
        let child = list.children(matching: .cell).element(boundBy: 1)
        child.tap()
        return .init(application: application)
    }
}
