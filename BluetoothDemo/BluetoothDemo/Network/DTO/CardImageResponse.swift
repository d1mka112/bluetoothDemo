//
//  CardImageResponse.swift
//  BluetoothDemo
//
//  Created by d.leukhin on 19.03.2023.
//

import Foundation

struct CardImageResponse: Codable {
    var result: Bool?
    var error: Bool?
    var cardImage: String?
}
