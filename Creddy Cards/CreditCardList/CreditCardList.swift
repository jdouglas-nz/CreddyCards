//

import SwiftUI

struct CreditCardList: View {
        
    var viewModel: ViewModel
    
    var body: some View {
        NavigationSplitView {
            VStack {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                case let .loaded(creditCards):
                    List {
                        ForEach(Array(creditCards.keys).sorted(by: sortedBy), id: \.hashValue) { type in
                            Section {
                                ForEach(creditCards[type]!) { card in
                                    NavigationLink {
                                        CreditCardDetails(viewModel: .init(creditCard: card, repository: ConcreteFavouriteCardsRepository(modelContext: CreddyCards.modelContext)))
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
                    .refreshable {
                        refresh()
                    }
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
    
    private func sortedBy(this: CreditCardType, that: CreditCardType) -> Bool {
        this.rawValue > that.rawValue
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
