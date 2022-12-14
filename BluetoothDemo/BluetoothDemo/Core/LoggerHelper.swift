//
//  LoggerHelper.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 14.12.2022.
//

import os

enum LoggerHelper {
    private static var logger = Logger()

    private static let infoPrefix = "✅"
    private static let warningPrefix = "⚡️"
    private static let errorPrefix = "⛔️"

    static func success(_ text: String) {
        logger.info("\(infoPrefix) \(text)")
    }

    static func info(_ text: String) {
        logger.info("\(text)")
    }

    static func warning(_ text: String) {
        logger.warning("\(warningPrefix) \(text)")
    }

    static func error(_ text: String) {
        logger.error("\(errorPrefix) \(text)")
    }
}
