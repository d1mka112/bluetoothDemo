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
        appearance.backgroundColor = Spec.Color.primary
        appearance.titleTextAttributes =  [
            .foregroundColor: Spec.Color.secondary
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: Spec.Color.secondary
        ]
        return appearance
    }

    static func other() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .clear
        return appearance
    }
}
