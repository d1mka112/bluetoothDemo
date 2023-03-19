//
//  TuganButton.swift
//  BluetoothDemo
//
//  Created by d.leukhin on 18.03.2023.
//

import UIKit

class TuganButton: HighlightingButton {

    enum Constants {
        static let cornerRadius: CGFloat = 10
        static let backgroundColor: UIColor = Spec.Color.accent
    }

    override func setupAppearance() {
        layer.cornerRadius = Constants.cornerRadius
        backgroundColor = Constants.backgroundColor
    }
}
