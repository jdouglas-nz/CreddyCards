//

import SwiftUI
import SwiftData

struct CreditCardList: View {
    var viewModel: ViewModel
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(viewModel.creditCards) { card in
                    NavigationLink {
                        Text("\(card.description)")
                    } label: {
                        Text(card.cardNumber)
                    }
                }
                .onDelete(perform: deleteItems)
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
            viewModel.refresh()
        }
    }

    private func addItem() {
        withAnimation {
            viewModel.addCreditCard()
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        withAnimation {
            viewModel.deleteItems(at: offsets)
        }
    }
}

#Preview {
    CreditCardList(
        viewModel: .init(
            modelContext: .init(
                try! ModelContainer(
                    for: CreditCard.self,
                    configurations: ModelConfiguration(
                        isStoredInMemoryOnly: true
                    )
                )
            )
        )
    )
}
