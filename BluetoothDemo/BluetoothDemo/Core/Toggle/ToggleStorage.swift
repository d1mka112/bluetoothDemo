//
//  ToggleStorage.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 05.01.2023.
//

import Foundation

enum Toggle: String {
    case substituteSuccess = "Toggle_Change_Success"
    case some = "Toggle_Some"

    var isActive: Bool {
        ToggleStorage.shared.toggles.first { $0.id == self }?.value ?? false
    }
}

final class ToggleStorage {
    static let shared = ToggleStorage()

    var toggles: [ToggleData] = [
        ToggleData(
            id: .substituteSuccess,
            title: "Подменить success в запросе",
            description: "Подменяет в запросе с ид устройства, значение поля success на false",
            value: false
        ),
        ToggleData(
            id: .some,
            title: "Что-то",
            description: "Какое-то описание тоггла",
            value: true
        )
    ]
}
