//
//  LoggerHelper.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 14.12.2022.
//

import os
import Foundation

enum LoggerHelper {
    private static var logger = Logger()

    private static let infoPrefix = "✅"
    private static let warningPrefix = "⚡️"
    private static let errorPrefix = "⛔️"

    private static func log(_ text: String) {
        logger.info("\(text)")
        LoggerStorage.shared.log(text)
    }

    static func success(_ text: String) {
        log("\(infoPrefix) \(text)")
    }

    static func info(_ text: String) {
        log( "\(text)")
    }

    static func warning(_ text: String) {
        log("\(warningPrefix) \(text)")
    }

    static func error(_ text: String) {
        log("\(errorPrefix) \(text)")
    }
}

protocol LoggerStorageDelegate {
    func didLogged(text: String)
}

final class LoggerStorage {
    static let shared = LoggerStorage()

    private let loggerQueue = DispatchQueue(label: "logger_queue")
    private var _delegates: [LoggerStorageDelegate?] = []

    func log(_ text: String) {
        loggerQueue.async { [weak self, text] in
            guard let self = self else { return }
            self._delegates.forEach {
                $0?.didLogged(text: text)
            }
        }
    }

    func add(delegate: LoggerStorageDelegate) {
        _delegates.append(delegate)
    }
}
