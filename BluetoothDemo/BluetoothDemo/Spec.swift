//
//  GlobalSettings.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 13.12.2022.
//

import UIKit

enum Spec {
    enum Networking {
        static let user: User = User(login: "part", password: "part")
        static let host: String = "178.57.218.210"
        static let port: Int = 198
    }

    enum Text {
        static let biometricReasonForUser: String = "Пожалуйста, подтвердите личность, чтобы продолжить"
        static let deviceUUID: String = "UUID Устройства"
        static let startScanButton: String = "Нажмите, чтобы начать сканирование"
        static let bringDeviceToTerminal: String = "Поднесите устройство к терминалу"
        static let scanDeviceError: String = "Не удалось считать терминал\nповторите снова"
        static let scanDeviceSuccess: String = "Успешно!"
        static let switchSimulate: String = "Симулировать success = false"
    }

    enum Color {
        static let primary: UIColor = UIColor.white
        static let gray: UIColor = UIColor.gray
        static let secondary: UIColor = UIColor.black
        static let success: UIColor = UIColor(red: 0.27, green: 0.75, blue: 0.47, alpha: 1)
    }

    enum Images {
        static let checkmark: UIImage = UIImage(named: "b.checkmark")!
        static let checkmarkCircle: UIImage = UIImage(named: "b.checkmark.circle")!
        static let card: UIImage = UIImage(named: "sberCard")!
    }

    enum GIFs {
//        static let bluetoothTagRead: UIImage.gifImageWith
    }

    enum Sound {
        static let paySuccess: String = "paySuccess"
    }
}
