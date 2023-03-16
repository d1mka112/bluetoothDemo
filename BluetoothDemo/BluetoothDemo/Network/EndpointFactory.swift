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
    enum SMSCodeParameters: String, Codable {
        case phone
        case uuid
    }
    enum PhoneCodeParameters: String, Codable {
        case code
        case uuid
        case phone
    }
    enum UserCardsParameters: String, Codable {
        case cardNumber
    }

    static func makeSMSCodeEndpoint(from phone: Phone) -> Endpoint<SMSCodeParameters> {
        Endpoint(
            type: .post, 
            scheme: .https, 
            host: Spec.Networking.tuganHost, 
            port: Spec.Networking.tuganPort,
            path: "/smscode", 
            headerParametes: [:], 
            urlParameters: [
                .phone: phone.phone,
                .uuid: phone.uuid
            ], 
            bodyParameters: [:]
        )
    }

    static func makeTokenEndpoint(from code: PhoneCode) -> Endpoint<PhoneCodeParameters> {
        Endpoint(
            type: .post, 
            scheme: .https, 
            host: Spec.Networking.tuganHost, 
            port: Spec.Networking.tuganPort,
            path: "/token", 
            headerParametes: [:], 
            urlParameters: [
                .code: code.code,
                .phone: code.phone,
                .uuid: code.uuid
            ], 
            bodyParameters: [:]
        )
    }

    static func makeUserCardEndpoint(from userCard: UserCard) -> Endpoint<UserCardsParameters> {
        Endpoint(
            type: .post, 
            scheme: .https, 
            host: Spec.Networking.tuganHost, 
            port: Spec.Networking.tuganPort,
            path: "/usercards", 
            headerParametes: [
                .contentType: "application/json",
                .token: GlobalStorage.shared.token ?? ""
            ], 
            urlParameters: [:], 
            bodyParameters: [
                .cardNumber: userCard.cardNumber
            ]
        )
    }

    static func makeAuthorizationEndpoint(from user: User) -> Endpoint<AuthorizationParameters> {
        Endpoint(
            type: .get,
            scheme: .http,
            host: Spec.Networking.host,
            port: Spec.Networking.port,
            path: "/token",
            headerParametes: [:],
            urlParameters: [
                .login: user.login,
                .password: user.password
            ],
            bodyParameters: [:]
        )
    }

    static func makeDeviceEndpoint(from device: Device) -> Endpoint<DeviceParameters> {
        Endpoint(
            type: .post,
            scheme: .http,
            host: Spec.Networking.host,
            port: Spec.Networking.port,
            path: "/terminals/attach",
            headerParametes: [
                .contentType: "application/json-patch+json"
            ],
            urlParameters: [
                .token: device.token
            ],
            bodyParameters: [
                .uuid: device.uuid
            ]
        )
    }
}
