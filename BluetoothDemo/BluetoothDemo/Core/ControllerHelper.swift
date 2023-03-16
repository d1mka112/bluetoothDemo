//
//  AlertHelper.swift
//  BluetoothDemo
//
//  Created by d.leukhin on 15.03.2023.
//

import UIKit
import SafariServices

enum ControllerHelper {

    static var topController: UIViewController? {
        UIApplication.shared.keyWindow?.rootViewController?.topMostViewController
    }

    static func pushSafari(url: String) {
        guard  let url = URL(string: url) else { return }

        DispatchQueue.main.async {
            guard let controller = topController else { return }
            let safariController = SFSafariViewController(url: url)
            controller.present(safariController, animated: true)
        }
    }

    static func pushAlert(title: String = "Ошибка", message: String = "Неизвестная ошибка") {
        DispatchQueue.main.async {
            guard let controller = topController else { return }

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
