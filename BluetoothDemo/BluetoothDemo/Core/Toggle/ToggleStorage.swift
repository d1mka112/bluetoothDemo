//
//  ToggleStorage.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 05.01.2023.
//

import Foundation
import AVFoundation

enum Toggle: String, Codable, Hashable {
    case sendBleListRequest = "send_ble_list_request"
    case shutDownWhenSuccess = "shut_down_when_success"
    case shouldScanAppleDevices = "should_scan_apple_devices"
    case shouldShowTransaction = "should_show_transaction"

    var isActive: Bool {
        ToggleStorage.shared.toggles.first { $0.id == self }?.value ?? false
    }
}

final class ToggleStorage {
    @Storage<[ToggleData]>(key: "com.vendista.toggles", defaultValue: ToggleStorage._defaultToggles)
    var toggles: [ToggleData]

    static let shared = ToggleStorage()

    private init() {
        var shouldResetToggles: Bool = toggles.count != Self._defaultToggles.count

        toggles.forEach { toggle in
            let hasChanges = 
                !Self._defaultToggles.contains { $0.title == toggle.title } ||
                !Self._defaultToggles.contains { $0.description == toggle.description }
            shouldResetToggles = shouldResetToggles || hasChanges
        }

        if shouldResetToggles {
            toggles = ToggleStorage._defaultToggles
        }
    }

    private static let _defaultToggles: [ToggleData] = [
        ToggleData(
            id: .sendBleListRequest, 
            title: "Отправлять запрос bleList", 
            description: "Включает отправку запроса bleList, как только было прочитано bluetooth устройство",
            value: true
        ),
        ToggleData(
            id: .shutDownWhenSuccess,
            title: "Скрывать приложение, когда оплата прошла успешно",
            description: "Эмулирует двойное нажатие home и скрывает приложение",
            value: false
        ),
        ToggleData(
            id: .shouldScanAppleDevices, 
            title: "Сканировать Apple устройства", 
            description: "Разрешает считать Apple Watch и AirPods - bluetooth устройством, который можно будет отправить в запросе",
            value: true
        ),
        ToggleData(
            id: .shouldShowTransaction, 
            title: "Показывать покупку", 
            description: "Включает отображение покупки, после успешной оплаты",
            value: true
        )
     ]
}
