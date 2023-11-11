//

import Foundation
import XCTest
@testable import Creddy_Cards

class CreditCardListViewModelTests: XCTestCase {
    
    private var repository: StubbedCreditCardRepository! = .init()
    private lazy var viewModel: CreditCardList.ViewModel! = .init(repository: repository)
    
    func test_addCreditCard_increasesNumber() async {
        XCTAssertEqual(repository.creditCards.count, 0)
        await viewModel.addCreditCard()
        XCTAssertEqual(repository.creditCards.count, 1)
    }
    
    func test_deleteCreditCard_decreasesNumber() async {
        repository.creditCards.append(.init(id: 1, uid: UUID(), cardNumber: "", expiry: Date(), type: .americanExpress))
        XCTAssertEqual(repository.creditCards.count, 1)
        await viewModel.refresh()
        await viewModel.deleteItems(at: .init(integer: 0))
        XCTAssertEqual(repository.creditCards.count, 0)
    }
    
    func test_refresh_updatesViewModel() async {
        repository.creditCards.append(.init(id: 1, uid: UUID(), cardNumber: "", expiry: Date(), type: .americanExpress))
        XCTAssertEqual(viewModel.creditCards.count, 0)
        await viewModel.refresh()
        XCTAssertEqual(viewModel.creditCards.count, 1)
    }
}
