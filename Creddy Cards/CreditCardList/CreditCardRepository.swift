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
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func add(card: CreditCard) async throws {
        modelContext.insert(card)
    }
    
    func delete(card: CreditCard) async throws {
        modelContext.delete(card)
    }
    
    func getCreditCards() async throws -> [CreditCard] {
        let descriptor = FetchDescriptor<CreditCard>(sortBy: [SortDescriptor(\.cardNumber, order: .forward)])
        return try modelContext.fetch(descriptor)
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
