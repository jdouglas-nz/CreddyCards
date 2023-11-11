//

import SwiftUI
import SwiftData

@main
struct CreddyCards: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CreditCard.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var jsonDecoder: JSONDecoder = {
        let d = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        d.dateDecodingStrategy = .formatted(formatter)
        return d
    }()

    var body: some Scene {
        WindowGroup {
            CreditCardList(viewModel: .init(
                repository: ConcreteCreditCardRepository(
                    modelContext: sharedModelContainer.mainContext,
                    network: ConcreteJSONBasedNetwork(
                        jsonDecoder: jsonDecoder,
                        baseUrl: URL(string: "https://random-data-api.com")!
                    ),
                    maxItemsFromNetwork: 100
                    )
                )
            )
        }
    }
}
