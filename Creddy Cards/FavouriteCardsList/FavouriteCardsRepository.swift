//

import Foundation
import SwiftData

protocol FavouriteCardsRepository {
    func getFavourites() throws -> [CreditCard]
    func toggleFavourite(card: CreditCard)
}

class ConcreteFavouriteCardsRepository: FavouriteCardsRepository {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getFavourites() throws -> [CreditCard] {
        let predicate = #Predicate<CreditCard> { c in
            c.isFavourite
        }
        
        return try modelContext.fetch(FetchDescriptor<CreditCard>(predicate: predicate, sortBy: [.init(\.id, order: .forward)]))
    }
    
    func toggleFavourite(card: CreditCard) {
        if card.modelContext == nil {
            modelContext.insert(card)
        }
        card.isFavourite.toggle()
    }
}

#if DEBUG
class StubbedFavouriteCardsRepository: FavouriteCardsRepository {
    
    private let cards: [CreditCard]
    private let throwError: Bool

    enum StubError: Error {
        case testError
    }
    
    init(cards: [CreditCard], throwError: Bool = false) {
        self.cards = cards
        self.throwError = throwError
    }
    
    func getFavourites() throws -> [CreditCard] {
        try throwErrorIfNeeded()
        return cards
    }
    
    func toggleFavourite(card: CreditCard) {
        card.isFavourite.toggle()
    }
    
    private func throwErrorIfNeeded() throws {
        if throwError {
            throw StubError.testError
        }
    }
}
#endif
