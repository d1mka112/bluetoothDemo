//
//  LoggerHelper.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 14.12.2022.
//

import os
import Foundation

enum LoggerHelper {
    class Timestamp {
        lazy var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "
            return formatter
        }()

        var current: String {
            dateFormatter.string(from: Date())
        }
    }

    private static var logger = Logger()
    private static var timesstamp = Timestamp()

    private static let infoPrefix = "✅"
    private static let warningPrefix = "⚡️"
    private static let errorPrefix = "⛔️"

    private static func log(_ text: String) {
        let info: String = "[\(timesstamp.current)]\n\(text)"
        logger.info("\(info)")
        LoggerStorage.shared.log(info)
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
