//
//  AlertHelper.swift
//  BluetoothDemo
//
//  Created by d.leukhin on 15.03.2023.
//

import UIKit

enum AlertHelper {
    static func make(title: String = "Ошибка", message: String = "Неизвестная ошибка") {
        DispatchQueue.main.async {
            guard let controller = UIApplication.shared.keyWindow?.rootViewController else {
                return
            }

            var alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

            alertController.addAction(
                UIAlertAction(title: "OK", style: .default)
            )

            controller.present(alertController, animated: true)
        }
    }
}

extension UIViewController {
    var topMostViewController: UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController
            }
            return tab.topMostViewController
        }
        return self.presentedViewController!.topMostViewController
    }
}
