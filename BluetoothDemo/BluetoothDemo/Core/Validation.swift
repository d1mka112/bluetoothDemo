//
//  Validation.swift
//  BluetoothDemo
//
//  Created by d.leukhin on 15.03.2023.
//

import Foundation

enum Validation {
    static func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9]{11}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }

    static func isValidCode(code: String) -> Bool {
        let phoneRegex = "^[0-9]{6}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: code)
    }
}
