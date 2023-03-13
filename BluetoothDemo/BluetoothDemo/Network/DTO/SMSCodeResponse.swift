//
//  SMSCodeResponse.swift
//  BluetoothDemo
//
//  Created by d.leukhin on 13.03.2023.
//

import Foundation

struct SMSCodeResponse: Codable {
    var result: Bool
    var error: String?
}
