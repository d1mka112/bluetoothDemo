//
//  LogsViewController.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 03.01.2023.
//
#if PRODUCT
import UIKit

final class LogsViewController: UIViewController {
    let logLabel: LogLabel = {
        let logLabel = LogLabel()
        logLabel.translatesAutoresizingMaskIntoConstraints = false
        return logLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Spec.Color.primary
        setupSubviews()
        setupLogLabel()
    }

    private func setupSubviews() {
        view.addSubview(logLabel)
    }

    private func setupLogLabel() {
        NSLayoutConstraint.activate([
            logLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16
            ),
            logLabel.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16
            ),
            logLabel.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16
            ),
            logLabel.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16
            )
        ])
    }
}
#endif
