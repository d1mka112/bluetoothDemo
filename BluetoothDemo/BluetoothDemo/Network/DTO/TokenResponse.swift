//
//  TokenResponse.swift
//  BluetoothDemo
//
//  Created by d.leukhin on 13.03.2023.
//

import Foundation

struct TokenResponse: Codable {
    var result: Bool
    var token: String?
    var error: String?
}
