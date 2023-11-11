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
                                Text("\(card.description)")
                            } label: {
                                Text(card.cardNumber)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .refreshable {
                        refresh()
                    }
                case let .error(errorVm):
                    ContentUnavailableView(label: {
                        Label(errorVm.title, systemImage: "exclamationmark.warninglight.fill")
                    },
                    description: {
                        Text(errorVm.description)
                    }, 
                    actions: {
                        Button("Try again") {
                            refresh()
                        }
                    })
                    
                case let .empty(title: title, description: description):
                    ContentUnavailableView(label: {
                        Label(title, systemImage: "creditcard")
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
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }.task {
            refresh()
        }
    }
    
    private func refresh() {
        Task {
            await viewModel.refresh()
        }
    }

    private func addItem() {
        Task {
            await viewModel.addCreditCard()
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        Task {
            await viewModel.deleteItems(at: offsets)
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
