//
//  AuthorizationResponse.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 21.12.2022.
//

import Foundation

struct AuthorizationResponse: Codable {
    var token: String?
    var ownerId: Int?
    var roleId: Int?
    var name: String?
}
