//

import Foundation

extension FavouriteCardsList {
    
    @Observable
    class ViewModel {
        private static let emptyListState = ViewState<[CreditCard]>.empty(title: "No Favourites for you! 💔", description: "You'll need to ❤️ a card from the Cards list for it to show up here.")
        
        var state: ViewState<[CreditCard]> = emptyListState
        
        var repository: FavouriteCardsRepository
        
        init(repository: FavouriteCardsRepository) {
            self.repository = repository
        }
        
        func refresh() {
            do {
                let cards = try repository.getFavourites()
                if cards.isEmpty {
                    state = Self.emptyListState
                } else {
                    state = .loaded(cards)
                }
            } catch {
                state = .error(.init(title: "Hmm", description: "That shouldn't happen. try again."))
            }
        }
    }
}
