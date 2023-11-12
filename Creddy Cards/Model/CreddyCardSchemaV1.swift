//

import Foundation
import SwiftData

enum CreddyCardSchemaV1: VersionedSchema {
    static let models: [any PersistentModel.Type] = [CreddyCardSchemaV1.CreditCard.self]
    
    static let versionIdentifier = Schema.Version(1, 0, 0)
    
    @Model
    final class CreditCard: CustomStringConvertible {
        let id: Int
        let uid: UUID
        let cardNumber: String
        let expiry: Date
        let type: CreditCardType
        
        init(id: Int, uid: UUID, cardNumber: String, expiry: Date, type: CreditCardType) {
            self.id = id
            self.uid = uid
            self.cardNumber = cardNumber
            self.expiry = expiry
            self.type = type
        }
        
        var description: String {
            "card \(cardNumber) (\(type)) expires on \(expiry)"
        }
    }
}
