//

import Foundation
import SwiftData

typealias CreditCard = CreddyCardSchemaV2.CreditCard

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

enum CreddyCardSchemaV2: VersionedSchema {
    static let models: [any PersistentModel.Type] = [CreddyCardSchemaV2.CreditCard.self]
    
    static let versionIdentifier = Schema.Version(2, 0, 0)
    
    @Model
    final class CreditCard: CustomStringConvertible {
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
        
        var description: String {
            "card \(cardNumber) (\(type)) expires on \(expiry)"
        }
        
        var favouriteText: String {
            isFavourite ? "❤️" : "💔"
        }
        
    }
}

enum CreditCardMigrationPlan: SchemaMigrationPlan {
    
    static let migrateV1ToV2 = MigrationStage.custom(
        fromVersion: CreddyCardSchemaV1.self,
        toVersion: CreddyCardSchemaV2.self) { context in
            let existingCards = try context.fetch(FetchDescriptor<CreddyCardSchemaV1.CreditCard>())
            existingCards.forEach({
                context.delete($0)
            })
            let migratedCards = existingCards.map { old in
                CreddyCardSchemaV2.CreditCard(
                    id: old.id,
                    uid: old.uid,
                    cardNumber: old.cardNumber,
                    expiry: old.expiry,
                    type: old.type,
                    isFavourite: false
                )
            }
            migratedCards.forEach({
                context.insert($0)
            })
            try context.save()

        } didMigrate: { context in
            
        }


    static let stages: [MigrationStage] = [migrateV1ToV2]
    
    static let schemas: [any VersionedSchema.Type] = [CreddyCardSchemaV1.self, CreddyCardSchemaV2.self]
}

enum CreditCardType: String, Codable, CaseIterable {
    case `switch`
    case discover
    case maestro
    case mastercard
    case jcb
    case forbrugsforeningen
    case dinersClub
    case americanExpress
    case visa
    case solo
    case laser
    case dankort
    
    var displayText: String {
        switch self {
        case .switch:
            "Switch"
        case .discover:
            "Discover"
        case .maestro:
            "Maestro"
        case .mastercard:
            "Mastercard"
        case .jcb:
            "JCB"
        case .forbrugsforeningen:
            "Forbrugsforeningen"
        case .dinersClub:
            "Diners Club"
        case .americanExpress:
            "American Express"
        case .visa:
            "VISA"
        case .solo:
            "SOLO"
        case .laser:
            "Laser"
        case .dankort:
            "Dankort"
        }
    }
}
