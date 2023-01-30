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
    case shutDownWhenSuccess = "shut_down_when_success"
    case gifTest = "gif_test"

    var isActive: Bool {
        ToggleStorage.shared.toggles.first { $0.id == self }?.value ?? false
    }
}

final class ToggleStorage {
    @Storage<[ToggleData]>(key: "com.vendista.toggles", defaultValue: ToggleStorage._defaultToggles)
    var toggles: [ToggleData]

    static let shared = ToggleStorage(forceUpdate: ToggleStorage._forceUpdateToggles)

    #if DEBUG
    private static let _forceUpdateToggles: Bool = true
    #else
    private static let _forceUpdateToggles: Bool = false
    #endif

    private init(forceUpdate: Bool = false) {
        if forceUpdate || toggles.hashValue != ToggleStorage._defaultToggles.hashValue {
            toggles = ToggleStorage._defaultToggles
            #if DEBUG
            if !toggles.contains(where: { $0.id == .gifTest}) {
                toggles.append(
                    ToggleData(
                        id: .gifTest,
                        title: "Тестирование GIF",
                        description: "Включает GIF для проверки работы прозрачного фона"
                    )
                )
            }
            #endif
        }
    }

    private static let _defaultToggles: [ToggleData] = [
        ToggleData(
            id: .forceUpdateToggles,
            title: "Сбросить на дефолтные значения",
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
        ),
        ToggleData(
            id: .shutDownWhenSuccess,
            title: "Скрывать приложение, когда оплата прошла успешно",
            description: "Эмулирует двойное нажатие home и скрывает приложение",
            value: false
        ),
     ]
}
