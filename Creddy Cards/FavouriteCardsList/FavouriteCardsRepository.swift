//

import Foundation
import SwiftData

protocol FavouriteCardsRepository {
    func getFavourites() throws -> [CreditCard]
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
}

#if DEBUG
class StubbedFavouriteCardsRepository: FavouriteCardsRepository {
    private let cards: [CreditCard]
    
    enum StubError: Error {
        case testError
    }
    
    let throwError: Bool
        init(cards: [CreditCard], throwError: Bool = false) {
        self.cards = cards
        self.throwError = throwError
    }
    
    func getFavourites() throws -> [CreditCard] {
        try throwErrorIfNeeded()
        return cards
    }
    
    private func throwErrorIfNeeded() throws {
        if throwError {
            throw StubError.testError
        }
    }
}
#endif
