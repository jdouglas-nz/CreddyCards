//

import Foundation

extension CreditCardList {
 
    @Observable
    class ViewModel {
        private let repository: CreditCardRepository
        private(set) var state: ViewState<[CreditCard]> = .loading
        
        init(repository: CreditCardRepository) {
            self.repository = repository
        }
        
        @MainActor
        func refresh() async {
            do {
                state = .loading
                let cards = try await repository.getCreditCards()
                if cards.isEmpty {
                    state = .empty(title: "Yo", description: "You got no cards to see my friend")
                } else {
                    state = .loaded(cards)
                }
            } catch {
                state = .error(.init(title: "oof", description: "something went wrong. please try again."))
            }
        }
    }
}
