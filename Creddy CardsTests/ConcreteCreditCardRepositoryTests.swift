//

import Foundation
import XCTest
import SwiftData
@testable import Creddy_Cards

class ConcreteCreditCardRepositoryTests: XCTestCase {
   
    private lazy var modelContext: ModelContext! = .init(
        .init(
            try! .init(
                for: CreditCard.self,
                configurations: .init(isStoredInMemoryOnly: true)
            )
        )
    )

    private lazy var repository: ConcreteCreditCardRepository! = .init(
        modelContext: modelContext,
        network: stubbedNetwork,
        maxItemsFromNetwork: 1
    )
    
    private let stubbedNetwork = StubbedNetwork(
        expectedResource: CreditCardData(
            id: 100,
            uuid: UUID(),
            cardNumber: "randomCard",
            expiry: Date(),
            type: .americanExpress
        )
    )

    private func addExistingData() {
        modelContext.insert(CreditCard(
            id: 1,
            uid: UUID(),
            cardNumber: "existing",
            expiry: Date(),
            type: .americanExpress,
            isFavourite: false)
        )
    }
    
    func test_repository_prependsNetworkResults_toRefreshValue() async {
        addExistingData()
        let allCardNumbers = try! await repository.getCreditCards().map(\.cardNumber)
        XCTAssertEqual(allCardNumbers[0], "existing")
        XCTAssertEqual(allCardNumbers[1], "randomCard")
    }
}
