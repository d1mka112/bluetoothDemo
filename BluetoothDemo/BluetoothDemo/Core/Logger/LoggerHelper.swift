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
