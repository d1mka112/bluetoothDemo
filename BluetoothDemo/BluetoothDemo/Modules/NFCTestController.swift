//
//  NFCTestController.swift
//  BluetoothDemo
//
//  Created by d.leukhin on 20.03.2023.
//

import UIKit

final class NFCTestController: VendistaViewController {

    let logsViewController = LogsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        NFCManager.shared.set(delegate: self)
        NFCManager.shared.startScanningIfCan()
    }

    private func setupSubviews() {
        addChild(logsViewController)
        view.addSubview(logsViewController.view)
        logsViewController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            logsViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            logsViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            logsViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            logsViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension NFCTestController: NFCManagerDelegate {
    func didDetectNFC(message: String) {
    }
}
