//

import XCTest

final class CreditCardFavouritingUITests: XCTestCase {
    
    lazy var application: XCUIApplication = {
        let a = XCUIApplication()
        a.launch()
        return a
    }()
    
    func test_favouriteACard_populatesFavouritesList() throws {
        let appPage = AppPage(application: application)
        let cardsPage = appPage.navigateToCardsList()
        cardsPage.waitForListToLoad()
        let detailsPage = cardsPage.clickFirstElement()
        detailsPage.favouriteCard()
        detailsPage.navigateBack()
        let favouritesPage = appPage.navigateToFavouritesList()
        favouritesPage.ensureListIsPopulated(expectedCount: 1)
    }
    
    func test_favouriteACard_ThenUnFavouritingTheCard_resultsInEmptyList() throws {
        let appPage = AppPage(application: application)
        let cardsPage = appPage.navigateToCardsList()
        cardsPage.waitForListToLoad()
        let detailsPage = cardsPage.clickFirstElement()
        detailsPage.favouriteCard()
        let favouritesPage = appPage.navigateToFavouritesList()
        let sameDetailsPage = favouritesPage.clickFirstElement()
        sameDetailsPage.favouriteCard()
        sameDetailsPage.navigateBack()
        favouritesPage.ensureEmptyList()
    }
    
    override func tearDown() async throws {
        await application.uninstall(name: "Creddy Cards")
        try await super.tearDown()
    }
}
