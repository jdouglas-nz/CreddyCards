//

import Foundation

struct CreditCardResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case uuid = "uid"
        case cardNumber = "credit_card_number"
        case expiry = "credit_card_expiry_date"
        case type = "creidt_card_type"
    }
    
    let id: Int
    let uuid: UUID
    let cardNumber: String
    let expiry: Date
    let type: CreditCardTypeResponse
}

enum CreditCardTypeResponse: String, Decodable {
    case `switch`
    case discover
    case maestro
    case mastercard
    case jcb
    case forbrugsforeningen
    case dinersClub = "diners_club"
    case americanExpress = "american_express"
    case visa
    case solo
    case laser
    case dankort
}
