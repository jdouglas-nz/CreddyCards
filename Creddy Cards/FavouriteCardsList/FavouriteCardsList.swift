//

import SwiftUI

struct FavouriteCardsList: View {
    
    var viewModel: ViewModel
    
    var body: some View {
        NavigationSplitView {
            VStack {
                switch viewModel.viewState {
                case .loading:
                    ProgressView()
                case .error(let errorVm):
                    contentUnavailable(title: errorVm.title, systemImageName: "heart", description: errorVm.description)
                case .loaded(let creditCards):
                    List {
                        ForEach(creditCards) { card in
                            NavigationLink {
                                Text("\(card.description)")
                            } label: {
                                Text(card.cardNumber)
                            }
                        }
                    }
                case .empty(let title, let description):
                    contentUnavailable(title: title, systemImageName: "heart", description: description)
                }
            }
            .navigationTitle("Favourites")
        } detail: {
            Text("Select an item")
        }
    }
    
    private func contentUnavailable(title: String, systemImageName: String, description: String) -> ContentUnavailableView<some View, some View, some View> {
        ContentUnavailableView(label: {
            Label(title, systemImage: systemImageName)
        },
        description: {
            Text(description)
        })
    }
}
