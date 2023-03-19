//
//  UserCardsResponse.swift
//  BluetoothDemo
//
//  Created by d.leukhin on 18.03.2023.
//

import Foundation

struct UserCardsResponse: Codable {
    struct CardItem: Codable {
        var id: Int
        var cardNumber: String
        var cardPaymentSystem: String
    }

    var items: [CardItem]
}
