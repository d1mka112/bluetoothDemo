//
//  LoggerStorage.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 05.01.2023.
//

import Foundation

protocol LoggerStorageDelegate {
    func didLogged(text: String)
    func clear()
}

final class LoggerStorage {
    static let shared = LoggerStorage()

    private let loggerQueue = DispatchQueue(label: "logger_queue")
    private var _delegates: [LoggerStorageDelegate?] = []
    @Atomic private var message: String = String()

    func log(_ text: String) {
        loggerQueue.async { [weak self, text] in
            guard let self = self else { return }
            self.message = "\(self.message)\n\n\(text)"
            self._delegates.forEach {
                $0?.didLogged(text: self.message)
            }
        }
    }

    func clear() {
        loggerQueue.async { [weak self] in
            guard let self = self else { return }
            self._delegates.forEach {
                $0?.clear()
            }
        }
    }

    func add(delegate: LoggerStorageDelegate) {
        _delegates.append(delegate)
        loggerQueue.async { [weak self] in
            guard let self = self else { return }
            delegate.didLogged(text: self.message)
        }
    }
}
