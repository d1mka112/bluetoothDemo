//
//  UserCardResponse.swift
//  BluetoothDemo
//
//  Created by d.leukhin on 17.03.2023.
//

import Foundation

struct UserCardResponse: Codable {
    var result: Bool?
    var error: String?
    var attachUrl: String?
}
