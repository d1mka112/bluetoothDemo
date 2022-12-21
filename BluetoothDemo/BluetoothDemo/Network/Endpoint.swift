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
    var body: Data? { get }
}
struct Endpoint<ParameterType: Hashable & RawRepresentable & Encodable>: EndpointRepresentable {
    var type: RequestType
    var scheme: RequestScheme
    var host: String
    var port: Int?
    var path: String
    var urlParameters: [ParameterType: String]
    var bodyParameters: [ParameterType: String]

    var url: String {
        
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host
        components.path = path
        components.port = port

        components.queryItems = urlParameters.compactMap {
            guard let key = $0.key.rawValue as? String else { return nil }
            return URLQueryItem(name: key, value: $0.value)
        }
        return components.string ?? String()
    }
        
    var body: Data? {
        guard !bodyParameters.isEmpty else { return nil }
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(bodyParameters) {
                return jsonData
        }
        return nil
    }
}
