//
//  GlobalSettings.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 13.12.2022.
//

import UIKit

enum Spec {
    enum Constant {
        static let minimalRSSI: Int = -40
    }

    enum Text {
        static let deviceUUID: String = "UUID Устройства"
        static let startScanButton: String = "Нажмите, чтобы начать сканирование"
    }

    enum Color {
        static let primary: UIColor = UIColor.white
    }
    enum Images {
        static let checkmark: UIImage = UIImage(named: "checkmark")!
    }
}
