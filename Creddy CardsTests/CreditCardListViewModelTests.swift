//

import Foundation
import XCTest
@testable import Creddy_Cards

class CreditCardListViewModelTests: XCTestCase {
    
    private var repository: StubbedCreditCardRepository! = .init()
    private lazy var viewModel: CreditCardList.ViewModel! = .init(repository: repository)
    
    func test_refresh_updatesViewModel() async {
        repository.creditCards.append(.init(id: 1, uid: UUID(), cardNumber: "", expiry: Date(), type: .americanExpress, isFavourite: false))
        XCTAssertEqual(viewModel.state, .loading)
        await viewModel.refresh()
        guard case let .loaded(creditCards) = viewModel.state else { fatalError("View should be loaded after calling refresh in tests") }
        XCTAssertEqual(creditCards.count, 1)
    }
    
    func test_refresh_noCards_stateBecomesEmpty() async {
        XCTAssertEqual(viewModel.state, .loading)
        await viewModel.refresh()
        XCTAssertEqual(viewModel.state, .empty(title: "Yo", description: "You got no cards to see my friend"))
    }
    
    func test_refresh_errors_stateBecomesEmpty() async {
        repository = .init(throwError: true)
        await viewModel.refresh()
        XCTAssertEqual(viewModel.state, .error(.init(title: "oof", description: "something went wrong. please try again.")))
    }
}


extension ViewState: Equatable where LoadedContent == [CreditCard] {
    
    public static func == (lhs: Creddy_Cards.ViewState<LoadedContent>, rhs: Creddy_Cards.ViewState<LoadedContent>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case let (.empty(lT, lD), .empty(rT, rD)):
            return lT == rT && lD == rD
        case let (.error(lVm), .error(rVm)):
            return lVm == rVm
        case let (.loaded(lC), .loaded(rC)):
            return lC == rC
        default:
            return false
        }
    }
}

extension ErrorViewStateViewModel: Equatable {
    
    public static func == (lhs: ErrorViewStateViewModel, rhs: ErrorViewStateViewModel) -> Bool {
        lhs.title == rhs.title && lhs.description == rhs.description
    }
}
