//
//  FeedbackGenerator.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 14.12.2022.
//

import UIKit

enum FeedbackGenerator {
    private static let generator = UINotificationFeedbackGenerator()

    static func prepare() {
        generator.prepare()
    }
    static func success() {
        generator.notificationOccurred(.success)
    }

    static func error() {
        generator.notificationOccurred(.error)
    }
}
