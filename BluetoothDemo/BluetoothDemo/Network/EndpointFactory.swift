//
//  EndpointFactory.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 21.12.2022.
//

import Foundation

enum EndpointFactory {
    enum AuthorizationParameters: String {
        case login
        case password
    }

    static func makeAuthorizationEndpoint(from user: User) -> Endpoint<AuthorizationParameters> {
        Endpoint(
            type: .get,
            scheme: .http,
            host: Spec.Networking.host,
            port: Spec.Networking.port,
            path: "/token",
            parameters: [
                .login: user.login,
                .password: user.password
            ]
        )
    }
}
