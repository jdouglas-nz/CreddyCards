//

import Foundation
import SwiftData

extension CreditCardList {
 
    @Observable
    class ViewModel {
        private(set) var modelContext: ModelContext
        private(set) var creditCards = [CreditCard]()
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }
        
        func addCreditCard() {
            let newItem = CreditCard(
                id: (0...10000).randomElement()!,
                uid: UUID(),
                cardNumber: UUID().uuidString,
                expiry: Date().addingTimeInterval(TimeInterval(-(0...100000).randomElement()!)),
                type: CreditCardType.allCases.randomElement()!
            )
            modelContext.insert(newItem)
            refresh()
        }
        
        func deleteItems(at offsets: IndexSet) {
            for index in offsets {
                modelContext.delete(creditCards[index])
            }
            refresh()
        }
        
        func refresh() {
            do {
                let descriptor = FetchDescriptor<CreditCard>(sortBy: [SortDescriptor(\.cardNumber, order: .forward)])
                creditCards = try modelContext.fetch(descriptor)
            } catch {
                print("oops!")
            }
        }
    }
}
