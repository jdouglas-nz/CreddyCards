//

import Foundation
import XCTest
import SwiftData
@testable import Creddy_Cards

class CreditCardMigrationTests: XCTestCase {
    
    private static let containerName = "MigrationTest"
    
    private let seedData = [
        CreddyCardSchemaV1.CreditCard(id: 1, uid: UUID(), cardNumber: "seed", expiry: Date(), type: .americanExpress)
    ]
    
    func test_migrationCreditCardsFromV1ToV2_allEndUpUnfavourited() async {
        addTeardownBlock {
            await self.deleteEverything()
        }
        await preseedContainer()
        await checkAndAssertOnMigrations()
    }
    
    
    // TODO: come back and get this working... maybe.
    // So, the idea I want to test is,
    // preseed SwiftData with a V1 version, save to disk, then reload Container using the V2 schema, and make sure all is fine.
    // I'm probably doing something silly here, or maybe you're not supposed to even do this, but all I know is Google is quiet on this topic
    // the 'better' way to do this is probably just add another layer of abstraction to the migration plan (read: pull the code out into its own class)
    // and then test it as if SwiftData wasn't part of that system.
    @MainActor
    private func checkAndAssertOnMigrations() {
        let v2Container = buildContainer(
            named: Self.containerName,
            withSchema: Schema(CreddyCardSchemaV2.models, version: CreddyCardSchemaV2.versionIdentifier),
            andMigrationPlan: CreditCardMigrationPlan.self
        )
        let migratedItems = try! v2Container.mainContext.fetch(FetchDescriptor<CreddyCardSchemaV2.CreditCard>())
        XCTAssertEqual(migratedItems.count, seedData.count)
        XCTAssertEqual(migratedItems.first?.isFavourite, false)
    }
    
    @MainActor
    private func preseedContainer() async {
        let container = buildContainer(
            named: Self.containerName,
            withSchema: Schema(CreddyCardSchemaV1.models, version: CreddyCardSchemaV1.versionIdentifier),
            andMigrationPlan: nil)
        let context = container.mainContext
        seedData.forEach({
            context.insert($0)
        })
        try? context.save() // This line here fails (flip the ? to a ! and see)
    }
    
    @MainActor
    private func deleteEverything() async {
        let container = buildContainer(
            named: Self.containerName,
            withSchema: Schema([CreddyCardSchemaV1.CreditCard.self, CreddyCardSchemaV2.CreditCard.self], version: CreddyCardSchemaV2.versionIdentifier),
            andMigrationPlan: nil)
        let context = container.mainContext
        try! context.delete(model: CreddyCardSchemaV1.CreditCard.self)
        try! context.delete(model: CreddyCardSchemaV2.CreditCard.self)

    }
    
    private func buildContainer(named name: String, withSchema schema: Schema, andMigrationPlan migrationPlan: SchemaMigrationPlan.Type? = nil) -> ModelContainer {
        let config = ModelConfiguration(name, schema: schema)
        return try! ModelContainer(for: schema, migrationPlan: migrationPlan, configurations: config)
    }
    
}
