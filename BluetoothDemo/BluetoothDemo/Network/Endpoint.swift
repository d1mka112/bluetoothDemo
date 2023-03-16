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
    var headerParametes: [HeaderParameters: String] { get }
}

enum HeaderParameters: String, Hashable, RawRepresentable, Encodable {
    case contentType = "Content-Type"
    case token = "token"
}

struct Endpoint<ParameterType: Hashable & RawRepresentable & Encodable>: EndpointRepresentable {
    var type: RequestType
    var scheme: RequestScheme
    var host: String
    var port: Int?
    var path: String
    var headerParametes: [HeaderParameters: String]
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

        let dict = bodyParameters.reduce([String:String]()) { (dict, parameter) in
            guard let key = parameter.key.rawValue as? String else { return dict}
            var dict = dict
            dict[key] = parameter.value
            return dict
        }

        if let jsonData = try? JSONSerialization.data(withJSONObject: dict) {
            LoggerHelper.success("Converted into json:\n\(String(data: jsonData, encoding: .utf8) ?? String())")
            return jsonData
        }
        return nil
    }
}
