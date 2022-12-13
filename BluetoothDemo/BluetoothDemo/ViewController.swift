//
//  ViewController.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 13.12.2022.
//

import UIKit

class ViewController: UIViewController {
    var button: UIButton = {
        let button = UIButton()
        button.setTitle("Старт скан", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
    }

    @objc func buttonDidTapped() {
        BluetoothManager.shared.setupManager()
        BluetoothManager.shared.startScanningIfCan()
    }
}

