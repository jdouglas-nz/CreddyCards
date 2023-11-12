//

import Foundation
import SwiftData

protocol CreditCardRepository {
    func add(card: CreditCard) async throws
    func delete(card: CreditCard) async throws
    func getCreditCards() async throws -> [CreditCard]
}

class ConcreteCreditCardRepository: CreditCardRepository {

    private let modelContext: ModelContext
    
    private let network: Network
    private var remoteCreditCards = [CreditCardResponse]()
    
    private let maxItemsFromNetwork: Int
    
    init(modelContext: ModelContext, network: Network, maxItemsFromNetwork: Int = 100) {
        self.modelContext = modelContext
        self.network = network
        self.maxItemsFromNetwork = maxItemsFromNetwork
    }
    
    func add(card: CreditCard) async throws {
        modelContext.insert(card)
    }
    
    func delete(card: CreditCard) async throws {
        modelContext.delete(card)
    }
    
    func getCreditCards() async throws -> [CreditCard] {
        let cachedCards = try getCachedCards()
        let cardsFromNetwork = try await getCardsFromNetwork()
        
        return cachedCards + cardsFromNetwork.map({ c in
                .init(
                    id: c.id,
                    uid: c.uuid,
                    cardNumber: c.cardNumber,
                    expiry: c.expiry,
                    type: .init(type: c.type), 
                    isFavourite: false
                )
        })
    }
    
    private func getCachedCards() throws -> [CreditCard] {
        let descriptor = FetchDescriptor<CreditCard>(sortBy: [SortDescriptor(\.cardNumber, order: .forward)])
        return try modelContext.fetch(descriptor)
    }
    
    private func getCardsFromNetwork() async throws -> [CreditCardResponse] {
        return if maxItemsFromNetwork == 1 {
           [try await network.get(path: "api/v2/credit_cards?size=\(maxItemsFromNetwork)")]
        } else {
            try await network.get(path: "api/v2/credit_cards?size=\(maxItemsFromNetwork)")
        }
    }
}

fileprivate extension CreditCardType {
    
    init(type: CreditCardTypeResponse) {
        switch type {
        case .switch:
            self = .switch
        case .discover:
            self = .discover
        case .maestro:
            self = .maestro
        case .mastercard:
            self = .mastercard
        case .jcb:
            self = .jcb
        case .forbrugsforeningen:
            self = .forbrugsforeningen
        case .dinersClub:
            self = .dinersClub
        case .americanExpress:
            self = .americanExpress
        case .visa:
            self = .visa
        case .solo:
            self = .solo
        case .laser:
            self = .laser
        case .dankort:
            self = .dankort
        }
    }
}

#if DEBUG
class StubbedCreditCardRepository: CreditCardRepository {
    
    enum StubError: Error {
        case testError
    }
    
    let throwError: Bool
    
    init(throwError: Bool = false) {
        self.throwError = throwError
    }
    
    var creditCards = [CreditCard]()
    
    func add(card: CreditCard) async throws {
        try throwErrorIfNeeded()
        creditCards.append(card)
    }
    
    func delete(card: CreditCard) async throws {
        try throwErrorIfNeeded()
        creditCards.removeAll { c in
            c.uid == card.uid
        }
    }
    
    func getCreditCards() async throws -> [CreditCard] {
        try throwErrorIfNeeded()
        return creditCards
    }
    
    private func throwErrorIfNeeded() throws {
        if throwError {
            throw StubError.testError
        }
    }
}
#endif
