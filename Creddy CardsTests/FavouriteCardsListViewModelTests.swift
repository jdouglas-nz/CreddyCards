//

import Foundation
import XCTest
import SwiftData
@testable import Creddy_Cards

class FavouriteCardsListViewModelTests: XCTestCase {
    
    func test_noCards_showsEmptyState() {
        let vm = FavouriteCardsList.ViewModel(repository: StubbedFavouriteCardsRepository(cards: []))
        XCTAssertEqual(vm.state, .empty(title: "No Favourites for you! 💔", description: "You'll need to ❤️ a card from the Cards list for it to show up here."))
        vm.refresh()
        XCTAssertEqual(vm.state, .empty(title: "No Favourites for you! 💔", description: "You'll need to ❤️ a card from the Cards list for it to show up here."))
    }
    
    func test_refreshErrors_showsErrorState() {
        let vm = FavouriteCardsList.ViewModel(repository: StubbedFavouriteCardsRepository(cards: [], throwError: true))
        vm.refresh()
        XCTAssertEqual(vm.state, .error(.init(title: "Hmm", description: "That shouldn't happen. try again.")))
    }
    
    func test_refreshSucceeds_showsCards() {
        let vm = FavouriteCardsList.ViewModel(repository: StubbedFavouriteCardsRepository(cards: [.init(id: 1, uid: UUID(), cardNumber: "first", expiry: Date(), type: .americanExpress, isFavourite: true)], throwError: false))
        vm.refresh()
        guard case let .loaded(creditCards) = vm.state else { fatalError("View should be loaded after calling refresh in tests") }
        XCTAssertEqual(creditCards.first?.cardNumber, "first")
    }
    
}
