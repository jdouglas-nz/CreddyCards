//

import Foundation

extension CreditCardList {
 
    @Observable
    class ViewModel {
        private let repository: CreditCardRepository
        private(set) var creditCards = [CreditCard]()
        
        init(repository: CreditCardRepository) {
            self.repository = repository
        }
        
        func addCreditCard() async {
            let newCard = CreditCard(
                id: (0...10000).randomElement()!,
                uid: UUID(),
                cardNumber: UUID().uuidString,
                expiry: Date().addingTimeInterval(TimeInterval(-(0...100000).randomElement()!)),
                type: CreditCardType.allCases.randomElement()!
            )
            
            do {
                try await repository.add(card: newCard)
            } catch {
                print("ooopsie! time to show this error somewhere")
            }
                await refresh()
        }
        
        func deleteItems(at offsets: IndexSet) async {
            for index in offsets {
                do {
                    try await repository.delete(card: creditCards[index])
                } catch {
                    print("ooopsie! time to show this error somewhere")
                }
            }
            await refresh()
        }
        
        @MainActor
        func refresh() async {
            do {
                creditCards = try await repository.getCreditCards()
            } catch {
                print("oooppsie! time to show this error somewhere")
            }
        }
    }
}
