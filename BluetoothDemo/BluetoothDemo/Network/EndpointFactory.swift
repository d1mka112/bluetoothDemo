//
//  EndpointFactory.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 21.12.2022.
//

import Foundation

enum EndpointFactory {
    enum AuthorizationParameters: String, Codable {
        case login
        case password
    }
    enum DeviceParameters: String, Codable {
        case token
        case uuid
    }
    

    static func makeAuthorizationEndpoint(from user: User) -> Endpoint<AuthorizationParameters> {
        Endpoint(
            type: .get,
            scheme: .http,
            host: Spec.Networking.host,
            port: Spec.Networking.port,
            path: "/token",
            urlParameters: [
                .login: user.login,
                .password: user.password
            ],
            bodyParameters: [ : ]
        )
    }
    static func makeDeviceEndpoint(from device: Device) -> Endpoint<DeviceParameters> {
        Endpoint(
            type: .post,
            scheme: .http,
            host: Spec.Networking.host,
            port: Spec.Networking.port,
            path: "terminals/attach",
            urlParameters: [
                .token: device.token
            ],
            bodyParameters: [
                .uuid:device.uuid
            ]
        )
    }
}
