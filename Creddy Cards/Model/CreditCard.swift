//

import Foundation
import SwiftData

/// The 'Model' that is used widely within the app. Note that (as per the fact this is a typealias) - this is a versioned model.
typealias CreditCard = CreddyCardSchemaV2.CreditCard

enum CreditCardType: String, Codable, CaseIterable {
    case `switch`
    case discover
    case maestro
    case mastercard
    case jcb
    case forbrugsforeningen
    case dinersClub
    case americanExpress
    case visa
    case solo
    case laser
    case dankort
    
    var displayText: String {
        switch self {
        case .switch:
            "Switch"
        case .discover:
            "Discover"
        case .maestro:
            "Maestro"
        case .mastercard:
            "Mastercard"
        case .jcb:
            "JCB"
        case .forbrugsforeningen:
            "Forbrugsforeningen"
        case .dinersClub:
            "Diners Club"
        case .americanExpress:
            "American Express"
        case .visa:
            "VISA"
        case .solo:
            "SOLO"
        case .laser:
            "Laser"
        case .dankort:
            "Dankort"
        }
    }
}
