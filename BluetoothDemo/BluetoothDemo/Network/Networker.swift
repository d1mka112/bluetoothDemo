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

    static func sendTokenRequest(
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
                LoggerHelper.error("Произошла ошибка запроса:\n\"\(request.url)\"\n\(error)")
            } else if let data = data {
                do {
                    let response = try snakeCaseDecoder.decode(ResponseType.self, from: data)
                    completion(response)
                    LoggerHelper.success("Успешный ответ на запрос\n\(response)")
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
        guard let url = URL(string: endpoint.url) else { return nil}

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.type.rawValue

        return request
    }
}