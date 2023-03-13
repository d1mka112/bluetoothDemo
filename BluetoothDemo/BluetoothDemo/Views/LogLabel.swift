//
//  LogLabel.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 28.12.2022.
//

import Foundation
import UIKit

final class LogLabel: UITextView {

    init() {
        super.init(frame: .zero, textContainer: nil)
        isEditable = false
        alwaysBounceVertical = true
        contentInset = .zero
        backgroundColor = Spec.Color.primary
        LoggerStorage.shared.add(delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LogLabel: LoggerStorageDelegate {
    func didLogged(text: String) {
        DispatchQueue.main.async {
            self.text = text
        }
    }

    func clear() {
        DispatchQueue.main.async {
            self.text = nil
        }
    }
}
