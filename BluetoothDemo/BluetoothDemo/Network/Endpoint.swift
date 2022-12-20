//
//  Endpoint.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 21.12.2022.
//

import Foundation

enum RequestType: String {
    case get = "GET"
    case post = "POST"
}

enum RequestScheme: String {
    case https
    case http
}

protocol EndpointRepresentable {
    var type: RequestType { get set }
    var scheme: RequestScheme { get set }
    var url: String { get }
}
struct Endpoint<ParameterType: Hashable & RawRepresentable>: EndpointRepresentable {
    var type: RequestType
    var scheme: RequestScheme
    var host: String
    var port: Int?
    var path: String
    var parameters: [ParameterType: String]

    var url: String {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host
        components.path = path
        components.port = port

        components.queryItems = parameters.compactMap {
            guard let key = $0.key.rawValue as? String else { return nil }

            return URLQueryItem(name: key, value: $0.value)
        }

        return components.string ?? String()
    }
}
