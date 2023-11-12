//

import SwiftUI
import SwiftData

@main
struct CreddyCards: App {
    
    static var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CreditCard.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: CreditCard.self,
                                      migrationPlan: CreditCardMigrationPlan.self,
                                      configurations: modelConfiguration)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            TabView {
                cardsList(context: Self.sharedModelContainer.mainContext)
                favouritesList(context: Self.sharedModelContainer.mainContext)
            }
        }
    }
    
    @ViewBuilder
    func cardsList(context: ModelContext) -> some View {
        let jsonDecoder: JSONDecoder = {
            let d = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-DD"
            d.dateDecodingStrategy = .formatted(formatter)
            return d
        }()
        
        CreditCardList(
            viewModel: .init(
                repository: ConcreteCreditCardRepository(
                    modelContext: context,
                    network: ConcreteJSONBasedNetwork(
                        jsonDecoder: jsonDecoder,
                        baseUrl: URL(string: "https://random-data-api.com")!
                    ),
                    maxItemsFromNetwork: 100
                )
            )
        )
        .tabItem {
            Label("Cards", systemImage: "creditcard")
        }
    }
    
    @ViewBuilder
    func favouritesList(context: ModelContext) -> some View {
        FavouriteCardsList(
            viewModel: .init(
                repository: ConcreteFavouriteCardsRepository(
                    modelContext: context
                )
            )
        )
        .tabItem {
            Label("Favourites", systemImage: "heart")
        }
    }
}
