//
//  ToggleStorage.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 05.01.2023.
//

import Foundation
import AVFoundation

enum Toggle: String, Codable, Hashable {
    case forceUpdateToggles = "force_update_toggles"
    case substituteSuccess = "substitute_success"
    case rescanWhenAppForeground = "rescan_devices_when_app_foreground"

    var isActive: Bool {
        ToggleStorage.shared.toggles.first { $0.id == self }?.value ?? false
    }
}

final class ToggleStorage {
    @Storage<[ToggleData]>(key: "com.vendista.toggles", defaultValue: ToggleStorage._defaultToggles)
    var toggles: [ToggleData]

    static let shared = ToggleStorage(forceUpdate: ToggleStorage._forceUpdateToggles)

    private static let _forceUpdateToggles: Bool = false

    private init(forceUpdate: Bool = false) {
        if forceUpdate || toggles.hashValue != ToggleStorage._defaultToggles.hashValue {
            toggles = ToggleStorage._defaultToggles
        }
    }

    private static let _defaultToggles: [ToggleData] = [
        ToggleData(
            id: .forceUpdateToggles,
            title: "Сбросить пна дефолтные значения",
            description: "Сбрасывает все тогглы, на дефолтные значения",
            value: false
        ),
        ToggleData(
            id: .substituteSuccess,
            title: "Подменить success в запросе",
            description: "Подменяет в запросе c отправкой ид устройства, значение поля success на false",
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
