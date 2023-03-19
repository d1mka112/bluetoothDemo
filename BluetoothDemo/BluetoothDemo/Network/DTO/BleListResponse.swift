//
//  BleListResponse.swift
//  BluetoothDemo
//
//  Created by d.leukhin on 19.03.2023.
//

import Foundation

struct BleListResponse: Codable {
    var result: Int
    var error: String?
    var item: String?
    var price: String?
}
