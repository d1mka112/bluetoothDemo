//
//  EndpointFactory.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 21.12.2022.
//

import Foundation

enum EndpointFactory {
    enum EmptyParameters: String, Codable { 
        case none
    }
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
    enum BleListParameters: String, Codable {
        case ble
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

    static func makeGetUserCardsEndpoint() -> Endpoint<EmptyParameters> {
        Endpoint(
            type: .get,
            scheme: .https, 
            host: Spec.Networking.tuganHost, 
            port: Spec.Networking.tuganPort,
            path: "/usercards", 
            headerParametes: [
                .token: GlobalStorage.shared.token ?? "",
                .accept: "text/plain"
            ],
            urlParameters: [:],
            bodyParameters: [:]
        )
    }

    static func makeDeleteUserCardEndpoint(from id: Int) -> Endpoint<EmptyParameters> {
        Endpoint(
            type: .delete,
            scheme: .https, 
            host: Spec.Networking.tuganHost, 
            port: Spec.Networking.tuganPort,
            path: "/usercards/\(id)", 
            headerParametes: [
                .token: GlobalStorage.shared.token ?? "",
                .accept: "text/plain"
            ],
            urlParameters: [:],
            bodyParameters: [:]
        )
    }

    static func makeBleListEndpoint(from bleList: BleList) -> Endpoint<EmptyParameters> {
        Endpoint(
            type: .post,
            scheme: .https, 
            host: Spec.Networking.tuganHost, 
            port: Spec.Networking.tuganPort,
            path: "/blelist", 
            headerParametes: [
                .token: GlobalStorage.shared.token ?? "",
                .contentType: "application/json",
                .accept: "text/plain"
            ],
            urlParameters: [:],
            bodyParameters: [:],
            codableParameter: bleList
        )
    }

    static func makeCardImageEndpoint() -> Endpoint<EmptyParameters> {
        Endpoint(
            type: .get,
            scheme: .https, 
            host: Spec.Networking.tuganHost, 
            port: Spec.Networking.tuganPort,
            path: "/cardimage", 
            headerParametes: [
                .token: GlobalStorage.shared.token ?? "",
                .accept: "text/plain"
            ],
            urlParameters: [:],
            bodyParameters: [:]
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
