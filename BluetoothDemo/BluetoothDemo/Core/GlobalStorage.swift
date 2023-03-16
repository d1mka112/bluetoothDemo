//
//  GlobalStorage.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 21.12.2022.
//

import Foundation

final class GlobalStorage {
    static let shared = GlobalStorage()

    var minimalRSSI: Int = -40
    @Storage(key: "com.vendista.token", defaultValue: nil) var token: String?
}
