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
    var token: String?

    // For debug only
    var _simulateSuccessFalse: Bool = false
}
