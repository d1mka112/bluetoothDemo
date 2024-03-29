//
//  Networker.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 20.12.2022.
//

import Foundation

enum Networker {
    static let snakeCaseDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    static func sendSMSCodeRequest(
        for phone: String,
        completion: @escaping (SMSCodeResponse?) -> Void
    ) {
        let phone = Phone(phone: phone, uuid: Spec.deviceId)
        let endpoint = EndpointFactory.makeSMSCodeEndpoint(from: phone)

        guard let request = makeRequestFromEndpoint(endpoint: endpoint) else { 
            completion(nil)
            return 
        }

        send(request: request, with: SMSCodeResponse.self) { response in
           completion(response)
        }
    }

    static func sendTokenRequest(
        for code: String,
        phone: String,
        completion: @escaping (TokenResponse?) -> Void
    ) {
        let phoneCode = PhoneCode(code: code, uuid: Spec.deviceId, phone: phone)
        let endpoint = EndpointFactory.makeTokenEndpoint(from: phoneCode)

        guard let request = makeRequestFromEndpoint(endpoint: endpoint) else {
            completion(nil)
            return 
        }

        send(request: request, with: TokenResponse.self) { response in
            GlobalStorage.shared.token = response?.token

            Networker.sendGetUserCards() { _ in } 

            completion(response)
        }
    }

    static func sendUserCard(
        for card: String,
        completion: @escaping (UserCardResponse?) -> Void
    ) {
        let userCard = UserCard(cardNumber: card)
        let endpoint = EndpointFactory.makeUserCardEndpoint(from: userCard)

        guard let request = makeRequestFromEndpoint(endpoint: endpoint) else {
            completion(nil)
            return
        }

        send(request: request, with: UserCardResponse.self) { response in
            completion(response)
        }
    }

    static func sendGetUserCards(
        completion: @escaping (UserCardsResponse?) -> Void
    ) {
        let endpoint = EndpointFactory.makeGetUserCardsEndpoint()

        guard let request = makeRequestFromEndpoint(endpoint: endpoint) else {
            completion(nil)
            return
        }

        send(request: request, with: UserCardsResponse.self) { response in
            GlobalStorage.shared.cards = response
            completion(response)
        }
    }

    static func sendDeleteUserCard(
        for id: Int,
        completion: @escaping (DeleteUserCardResponse?) -> Void
    ) {
        let endpoint = EndpointFactory.makeDeleteUserCardEndpoint(from: id)

        guard let request = makeRequestFromEndpoint(endpoint: endpoint) else {
            completion(nil)
            return
        }

        send(request: request, with: DeleteUserCardResponse.self) { response in
            completion(response)
        }
    }

    static func sendBleListRequest(
        for device: BluetoothTagModel,
        completion: @escaping (BleListResponse?) -> Void
    ) {
        let bleList = BleList(
            ble: [
                BleList.Ble(
                    uuid: device.name ?? "", 
                    rssi: device.rssi
                )
            ]
        )
        let endpoint = EndpointFactory.makeBleListEndpoint(from: bleList)

        guard let request = makeRequestFromEndpoint(endpoint: endpoint) else { 
            completion(nil)
            return
        }

        send(request: request, with: BleListResponse.self) { response in
            completion(response)
        }
    }

//    static func sendCardImageRequest(
//        completion: @escaping (CardImageResponse?) -> Void
//    ) {
//        let endpoint = EndpointFactory.makeCardImageEndpoint()
//
//        guard let request = makeRequestFromEndpoint(endpoint: endpoint) else {
//            completion(nil)
//            return
//        }
//    }

    static func sendTokenRequestOld(
        for user: User
    ) {
        let endpoint = EndpointFactory.makeAuthorizationEndpoint(from: user)

        guard let request = makeRequestFromEndpoint(endpoint: endpoint) else { return }

        send(request: request, with: AuthorizationResponse.self) { response in
            GlobalStorage.shared.token = response?.token
        }
    }

    private static func send<ResponseType: Codable>(
        request: URLRequest,
        with type: ResponseType.Type,
        completion: @escaping (ResponseType?)->Void
    ) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil)
                LoggerHelper.error(
                    "Произошла ошибка запроса:\n\"\(String(describing: request.url!))\"\n\(error)"
                )
            } else if let data = data {
                do {
                    LoggerHelper.success("⬅️ Код 200\nПолучен ответ на запрос \(request.url!)\nRaw data:\n\(String(data: data, encoding: .utf8) ?? String())")
                    let response = try snakeCaseDecoder.decode(ResponseType.self, from: data)
                    completion(response)
                } catch(let error) {
                    completion(nil)
                    LoggerHelper.error("Произошла ошибка при декодировании\n\(error)")
                }
                
            } else {
                completion(nil)
                LoggerHelper.error("Неопознанная ошибка")
            }
        }
        LoggerHelper.success("➡️ Отправлен запрос \(String(describing: request.url))")
        task.resume()
    }
 
    private static func makeRequestFromEndpoint(endpoint: EndpointRepresentable) -> URLRequest? {
        guard let url = URL(string: endpoint.url) else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.type.rawValue
        request.httpBody = endpoint.body
        endpoint.headerParametes.forEach { parameter in
            request.addValue(parameter.value, forHTTPHeaderField: parameter.key.rawValue)
        }

        return request
    }
}
