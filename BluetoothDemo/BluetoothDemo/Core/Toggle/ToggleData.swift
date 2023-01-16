//
//  ToggleData.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 05.01.2023.
//

import Foundation

struct ToggleData: Codable, Hashable {
    var id: Toggle
    var title: String
    var description: String
    var value: Bool

    init(id: Toggle, title: String, description: String, value: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.value = value
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(description)
    }
}
