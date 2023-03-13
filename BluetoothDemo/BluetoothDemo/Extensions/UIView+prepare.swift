//
//  UIView+prepare.swift
//  BluetoothDemo
//
//  Created by d.leukhin on 12.03.2023.
//

import UIKit

extension UIView {
    func prepareForConstrains() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
