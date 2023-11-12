//

import XCTest

class CardDetailsPage: Page {
    
    var heartButton: XCUIElement {
        let detailsNavigationBar = application.navigationBars["Details"]
        return detailsNavigationBar.buttons["Toggle Favourite"]
    }
    
    func favouriteCard() {
        heartButton.tap()
    }
}
