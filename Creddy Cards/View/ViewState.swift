//

import Foundation

enum ViewState<LoadedContent> {
    case loading
    case error(ErrorViewStateViewModel)
    case loaded(LoadedContent)
    case empty(title: String, description: String)
}

struct ErrorViewStateViewModel {
    
    public let title: String
    public let description: String
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}
