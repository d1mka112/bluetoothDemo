//
//  NFCManager.swift
//  BluetoothDemo
//
//  Created by d.leukhin on 20.03.2023.
//

import Foundation
import CoreNFC

//typealias NFCReadingCompletion = (Result<NFCNDEFMessage?, Error>) -> Void

protocol NFCManagerDelegate {
    func didDetectNFC(message: String)
}

@objc final class NFCManager: NSObject {
    static let shared: NFCManager = NFCManager()

    var session: NFCNDEFReaderSession?

//    var session: NFCTagReaderSession?
    var delegate: NFCManagerDelegate?

    func startScanningIfCan() {
//        session = NFCTagReaderSession(
//            pollingOption: [.iso15693], 
//            delegate: self
//        )
        session = NFCNDEFReaderSession(
            delegate: self, 
            queue: DispatchQueue.main, 
            invalidateAfterFirstRead: false
        )
        session?.begin()
    }

    func set(delegate: NFCManagerDelegate) {
        self.delegate = delegate
    }
}

extension NFCManager: NFCNDEFReaderSessionDelegate {
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        LoggerHelper.info(session.description)
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var messagesStirng: String = ""
        for message in messages {
            for record in message.records {
                if let string = String(data: record.payload, encoding: .ascii) {
                    LoggerHelper.info(string)
                    messagesStirng.append(string)
                }
            }
        }
        delegate?.didDetectNFC(message: messagesStirng)
    }
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        LoggerHelper.info(tags.description)
    }
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        LoggerHelper.error(error.localizedDescription)
    }
}

extension NFCManager: NFCTagReaderSessionDelegate {
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        LoggerHelper.info(session.description)
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        LoggerHelper.error(error.localizedDescription)
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        LoggerHelper.info(tags.description)
    }
}
