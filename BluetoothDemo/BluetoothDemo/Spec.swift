//
//  GlobalSettings.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 13.12.2022.
//

import UIKit

enum Spec {
    static var deviceId: String { 
        UIDevice.current.identifierForVendor?.uuidString ?? ""
    }

    enum Networking {
        static let user: User = User(login: "part", password: "part")

        static let host: String = "178.57.218.210"
        static let port: Int = 198

        static let tuganHost: String = "t.vendista.ru"
        static let tuganPort: Int = 2112
    }

    enum Text {
        static let biometricReasonForUser: String = "Пожалуйста, подтвердите личность, чтобы продолжить"
        static let deviceUUID: String = "UUID Устройства"
        static let startScanButton: String = "Нажмите, чтобы начать сканирование"
        static let bringDeviceToTerminal: String = "Поднесите устройство к считывателю"
        static let scanDeviceError: String = "Отказ"
        static let scanStopped: String = "Сканирование завершено"
        static let scanDeviceSuccess: String = "Успешная оплата"
    }

    enum Color {
        static let primary: UIColor = UIColor(white: 0.89, alpha: 1)
        static let gray: UIColor = UIColor.gray
        static let secondary: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        static let success: UIColor = UIColor(red: 0.27, green: 0.75, blue: 0.47, alpha: 1)
        static let accent: UIColor = UIColor(red: 0.384, green: 0.702, blue: 0.655, alpha: 1)
        static let background: UIColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        static let lightGray: UIColor = UIColor(red: 0.965, green: 0.969, blue: 0.988, alpha: 1)
    }

    enum Images {
        static let checkmark: UIImage = UIImage(named: "b.checkmark")!
        static let checkmarkCircle: UIImage = UIImage(named: "b.checkmark.circle")!
        static let card: UIImage = UIImage(named: "sberCard")!
        static let logo: UIImage = UIImage(named: "logo")!
        static let logoBlack: UIImage = UIImage(named: "logo.black")!
        static let device: UIImage = UIImage(named: "device")!
        static let speechBubble: UIImage = UIImage(named: "speech.bubble")!
    }

    enum GIFs {
        static var bringDeviceToReader: String {
            if Toggle.gifTest.isActive {
                return "bring_debug"
            } else {
                return "bringDeviceToReader"
            }
        }
        static var success: String {
            if Toggle.gifTest.isActive {
                return "success_debug"
            } else {
                return "success"
            }
        }
        static let reject: String = "reject"
    }

    enum Sound {
        static let paySuccess: String = "paySuccess"
    }
}

extension Optional where Wrapped: UIColor {
    var cgColor: CGColor {
        self != nil ? self.cgColor : UIColor.black.cgColor
    }
}
