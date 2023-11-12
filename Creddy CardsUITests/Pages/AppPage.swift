//

import XCTest

class AppPage: Page {
    
    var navbar: XCUIElement {
        application.tabBars["Tab Bar"]
    }
    
    var cardsListTab: XCUIElement {
        navbar.buttons["Cards"]
    }
    
    var favouritesListTab: XCUIElement {
        navbar.buttons["Favourites"]
    }
    
    func navigateToCardsList() -> CardsListPage {
        cardsListTab.tap()
        return .init(application: application)
    }
    
    func navigateToFavouritesList() -> FavouritesListPage {
        favouritesListTab.tap()
        return .init(application: application)
    }
}
