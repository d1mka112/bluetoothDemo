//
//  BluetoothTagModel.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 13.12.2022.
//

import Foundation

struct BluetoothTagModel {
    let rssi: Int
    let name: String?
    let deviceName: String?

    var description: String {
        "RSSI: \(rssi)\nDeviceName: \(deviceName ?? "none")\nUUID: \(name ?? "none")"
    }
}
