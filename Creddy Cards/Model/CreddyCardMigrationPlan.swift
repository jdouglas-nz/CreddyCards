//

import Foundation
import SwiftData

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
