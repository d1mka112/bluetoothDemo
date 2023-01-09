//
//  ToggleStorage.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 05.01.2023.
//

import Foundation

enum Toggle: String, Codable {
    case substituteSuccess = "substitute_success"
    case rescanWhenAppForeground = "rescan_devices_when_app_foreground"

    var isActive: Bool {
        ToggleStorage.shared.toggles.first { $0.id == self }?.value ?? false
    }
}

final class ToggleStorage {
    static let shared = ToggleStorage()

    @Storage<[ToggleData]>(key: "com.vendista.toggles", defaultValue: ToggleStorage._defaultToggles)
    var toggles: [ToggleData]

    private static let _defaultToggles: [ToggleData] = [
        ToggleData(
            id: .substituteSuccess,
            title: "Подменить success в запросе",
            description: "Подменяет в запросе с ид устройства, значение поля success на false",
            value: false
        ),
        ToggleData(
            id: .rescanWhenAppForeground,
            title: "Перезапускать сканирование при выходе из фона",
            description: "Перезапускает сканирование устройств, когда приложение ушло в бекграунд и из него вернулось",
            value: true
        )
     ]
}
