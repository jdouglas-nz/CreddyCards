//

import Foundation

extension CreditCardDetails {
    
    @Observable
    class ViewModel {
        
        var creditCard: CreditCard
        private var repository: CreditCardRepository
        
        init(creditCard: CreditCard, repository: CreditCardRepository) {
            self.creditCard = creditCard
            self.repository = repository
        }
        
        func toggleFavourite() {
            repository.toggleFavourite(card: creditCard)
        }
    }
}
