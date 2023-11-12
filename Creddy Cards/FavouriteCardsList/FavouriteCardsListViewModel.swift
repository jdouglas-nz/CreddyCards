//

import Foundation

extension FavouriteCardsList {
    
    @Observable
    class ViewModel {
        private static let emptyListState = ViewState<[CreditCard]>.empty(title: "No Favourites for you! 💔", description: "You'll need to ❤️ a card from the Cards list for it to show up here.")
        
        var viewState: ViewState<[CreditCard]> = emptyListState
    }
}
