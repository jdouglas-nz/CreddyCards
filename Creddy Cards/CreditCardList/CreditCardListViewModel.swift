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
            guard case let .loaded(creditCards) = state else { return }
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
