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
     ]
}
