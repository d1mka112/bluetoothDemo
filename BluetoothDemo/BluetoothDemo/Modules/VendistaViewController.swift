//
//  VendistaViewController.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 03.01.2023.
//

import Foundation
import UIKit


internal class VendistaViewController: UIViewController {
    #if PRODUCT
    override var canBecomeFirstResponder: Bool {
        true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        becomeFirstResponder()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }

        presentDebugAlert()
    }

    private func presentDebugAlert() {
        let alert = UIAlertController(
            title: "Список экранов для дебага",
            message: "Пожалуйста, выберите экран, на который будете переходить",
            preferredStyle: .actionSheet
        )

        alert.addAction(UIAlertAction(title: "Логи", style: .default , handler:{ (UIAlertAction) in
            self.present(
                ModalDebugViewController().with(
                    title: "Логи",
                    viewController: LogsViewController()
                ),
                animated: true
            )
        }))

        alert.addAction(UIAlertAction(title: "Тогглы", style: .default , handler:{ (UIAlertAction) in
            self.present(
                ModalDebugViewController().with(
                    title: "Тогглы",
                    viewController: ToggleViewController()
                ),
                animated: true
            )
        }))
        present(alert, animated: true, completion: nil)
    }
    #endif
}
