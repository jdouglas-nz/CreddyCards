//

import Foundation
import SwiftData

enum CreddyCardSchemaV2: VersionedSchema {
    static let models: [any PersistentModel.Type] = [CreddyCardSchemaV2.CreditCard.self]
    
    static let versionIdentifier = Schema.Version(2, 0, 0)
    
    @Model
    final class CreditCard {
        let id: Int
        @Attribute(.unique)
        let uid: UUID
        var cardNumber: String
        let expiry: Date
        let type: CreditCardType
        var isFavourite: Bool
        
        init(id: Int, uid: UUID, cardNumber: String, expiry: Date, type: CreditCardType, isFavourite: Bool) {
            self.id = id
            self.uid = uid
            self.cardNumber = cardNumber
            self.expiry = expiry
            self.type = type
            self.isFavourite = isFavourite
        }
        
        var summarizedText: String {
            "\(cardNumber)"
        }
        
        var favouriteText: String {
            isFavourite ? "❤️" : "💔"
        }
    }
}

