//

import SwiftUI

struct FavouriteCardsList: View {
    
    var body: some View {
        ContentUnavailableView(label: {
            Label("No Favourites", systemImage: "heart")
        })
    }
}
