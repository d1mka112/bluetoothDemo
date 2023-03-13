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
        for code: PhoneCode,
        completion: @escaping (TokenResponse?) -> Void
    ) {
        let endpoint = EndpointFactory.makeTokenEndpoint(from: code)

        guard let request = makeRequestFromEndpoint(endpoint: endpoint) else {
            completion(nil)
            return 
        }

        send(request: request, with: TokenResponse.self) { response in
            GlobalStorage.shared.token = response?.token
            completion(response)
        }
    }

    static func sendTokenRequestOld(
        for user: User
    ) {
        let endpoint = EndpointFactory.makeAuthorizationEndpoint(from: user)

        guard let request = makeRequestFromEndpoint(endpoint: endpoint) else { return }

        send(request: request, with: AuthorizationResponse.self) { response in
            GlobalStorage.shared.token = response?.token
        }
    }

    static func sendDeviceRequest(
        for device: Device,
        completion: @escaping (DeviceResponse?) -> Void
    ) {
        let endpoint = EndpointFactory.makeDeviceEndpoint(from: device)

        guard let request = makeRequestFromEndpoint(endpoint: endpoint) else { return }

        if Toggle.substituteSuccess.isActive {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(DeviceResponse(item: "fake-00id", success: false))
            }
        } else {
            send(request: request, with: DeviceResponse.self) { response in
                completion(response)
            }
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
                    LoggerHelper.success("Успешный ответ на запрос \(request.url!)\nRaw data:\n\(String(data: data, encoding: .utf8) ?? String())")
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
