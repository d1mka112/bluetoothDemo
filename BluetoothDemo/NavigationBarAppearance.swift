//
//  NavigationBarAppearance.swift
//  BluetoothDemo
//
//  Created by d.leukhin on 13.03.2023.
//

import UIKit

enum NavigationBarAppearance {
    static func main() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Spec.Color.background
        return appearance
    }
}
