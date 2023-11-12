//

import Foundation

extension CreditCardDetails {
    
    @Observable
    class ViewModel {
        
        var creditCard: CreditCard
        private var repository: FavouriteCardsRepository
        
        init(creditCard: CreditCard, repository: FavouriteCardsRepository) {
            self.creditCard = creditCard
            self.repository = repository
        }
        
        func toggleFavourite() {
            repository.toggleFavourite(card: creditCard)
        }
    }
}
