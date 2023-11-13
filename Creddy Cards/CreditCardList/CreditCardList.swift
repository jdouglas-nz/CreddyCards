//

import SwiftUI
import SwiftData

struct CreditCardList: View {
        
    var viewModel: ViewModel
    @State private var sortGroupsAscending = false
    
    var body: some View {
        NavigationSplitView {
            VStack {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                case let .loaded(creditCards):
                    groupedList(creditCards: creditCards, context: CreddyCards.sharedModelContainer.mainContext)
                case let .error(errorVm):
                    contentUnavailable(title: errorVm.title,
                                       systemImageName: "exclamationmark.warninglight.fill",
                                       description: errorVm.description
                    )
                case let .empty(title: title, description: description):
                    contentUnavailable(title: title,
                                       systemImageName: "creditcard",
                                       description: description
                    )
                }
            }
            .navigationTitle("Cards")
        } detail: {
            Text("Select an item")
        }.task {
            refresh()
        }
    }
    
    @ViewBuilder
    private func groupedList(creditCards: [CreditCardType: [CreditCard]], context: ModelContext) -> some View {
        List {
            ForEach(Array(creditCards.keys).sorted(by: sortedBy), id: \.hashValue) { type in
                Section {
                    ForEach(creditCards[type]!) { card in
                        NavigationLink {
                            CreditCardDetails(viewModel: .init(creditCard: card, repository: ConcreteFavouriteCardsRepository(modelContext: context)))
                        } label: {
                            Text(card.summarizedText)
                                .font(.body)
                        }
                    }
                } header: {
                    Text(type.displayText)
                        .font(.headline)
                }

            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    sortGroupsAscending.toggle()
                } label: {
                    Label("Sort groups",
                          systemImage: sortGroupsAscending ? "arrow.down" : "arrow.up"
                    )
                    .labelStyle(IconOnlyLabelStyle())
                }
                .contentTransition(.symbolEffect(.replace))
            }
        }
        .refreshable {
            refresh()
        }
    }
    
    private func sortedBy(this: CreditCardType, that: CreditCardType) -> Bool {
        return if sortGroupsAscending {
            this.rawValue < that.rawValue
        } else {
            this.rawValue > that.rawValue
        }
    }
    
    private func contentUnavailable(title: String, systemImageName: String, description: String) -> ContentUnavailableView<some View, some View, some View> {
        ContentUnavailableView(label: {
            Label(title, systemImage: systemImageName)
        },
        description: {
            Text(description)
        },
        actions: {
            Button("refresh") {
                refresh()
            }
        })
    }
    
    private func refresh() {
        Task {
            await viewModel.refresh()
        }
    }
}

#Preview {
    CreditCardList(
        viewModel: .init(
            repository: StubbedCreditCardRepository()
        )
    )
}
