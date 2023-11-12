//

import XCTest

class FavouritesListPage: Page {
    
    var list: XCUIElement {
        application.collectionViews["Sidebar"]
    }
    
    func ensureListIsPopulated(expectedCount: Int) {
        XCTAssertEqual(list.children(matching: .cell).count, expectedCount)
    }
    
    func ensureEmptyList() {
        XCTAssertEqual(list.exists, false)
    }
    
    func clickFirstElement() -> CardDetailsPage {
        let child = list.children(matching: .cell).firstMatch
        child.tap()
        return .init(application: application)
    }
}
