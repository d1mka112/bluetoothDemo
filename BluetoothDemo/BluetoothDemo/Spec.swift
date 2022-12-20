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
        static let deviceUUID: String = "UUID Устройства"
        static let startScanButton: String = "Нажмите, чтобы начать сканирование"
    }

    enum Color {
        static let primary: UIColor = UIColor.white
        static let secondary: UIColor = UIColor.black
    }

    enum Images {
        static let checkmark: UIImage = UIImage(named: "checkmark")!
        static let checkmarkCircle: UIImage = UIImage(named: "checkmark.circle")!
    }

    enum Sound {
        static let paySuccess: String = "paySuccess"
    }
}
