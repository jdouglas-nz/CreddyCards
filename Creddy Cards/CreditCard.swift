//
//  Item.swift
//  Creddy Cards
//
//  Created by John Douglas on 11/11/23.
//

import Foundation
import SwiftData

@Model
final class CreditCard: CustomStringConvertible {
    let id: Int
    let uid: UUID
    let cardNumber: String
    let expiry: Date
    let type: CreditCardType
    
    init(id: Int, uid: UUID, cardNumber: String, expiry: Date, type: CreditCardType) {
        self.id = id
        self.uid = uid
        self.cardNumber = cardNumber
        self.expiry = expiry
        self.type = type
    }
    
    var description: String {
        "card \(cardNumber) (\(type)) expires on \(expiry)"
    }
}

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
}
