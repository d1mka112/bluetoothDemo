//
//  BluetoothModel.swift
//  BluetoothDemo
//
//  Created by d.leukhin on 19.03.2023.
//

import Foundation

struct BleList: Codable {
    struct Ble: Codable {
        var uuid: String
        var rssi: Int
    }

    var ble: [Ble]
}

