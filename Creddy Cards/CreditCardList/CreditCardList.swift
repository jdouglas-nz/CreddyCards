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
                        ForEach(creditCards) { card in
                            NavigationLink {
                                CreditCardDetails(viewModel: .init(creditCard: card, repository: viewModel.repository))
                            } label: {
                                Text("\(card.cardNumber) \(card.favouriteText)")
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
