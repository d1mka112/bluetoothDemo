//
//  ViewController.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 13.12.2022.
//

import UIKit

class ViewController: UIViewController {
    var infoLabel: UILabel = {
        let label = UILabel()
        label.text = Spec.Text.deviceUUID
        label.textColor = .black
        label.backgroundColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    var logLabel: UILabel = {
        let label = UILabel()
        label.text = Spec.Text.deviceUUID
        label.textColor = .black
        label.backgroundColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var modelsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()

    var button: UIButton = {
        let button = UIButton()
        button.setTitle(Spec.Text.startScanButton, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.maximumValue = 0
        stepper.minimumValue = -200
        stepper.value = Double(GlobalStorage.shared.minimalRSSI)
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()

    var rssiValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(GlobalStorage.shared.minimalRSSI)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        Networker.sendTokenRequest(for: Spec.Networking.user)
        BluetoothManager.shared.setDelegate(delegate: self)
        BluetoothManager.shared.setupManager()

        setupView()
        setupSubviews()
    }

    private func setupView() {
        view.backgroundColor = Spec.Color.primary
    }

    private func setupSubviews() {
        view.addSubview(button)
        view.addSubview(infoLabel)
        view.addSubview(logLabel)
        view.addSubview(modelsLabel)
        view.addSubview(stepper)
        view.addSubview(rssiValueLabel)
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            infoLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            infoLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            infoLabel.heightAnchor.constraint(equalToConstant: 100)
        ])

        NSLayoutConstraint.activate([
            logLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            logLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            logLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            logLabel.heightAnchor.constraint(equalToConstant: 20)
        ])

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: logLabel.bottomAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: infoLabel.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 20)
        ])

        NSLayoutConstraint.activate([
            stepper.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            stepper.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            stepper.heightAnchor.constraint(equalToConstant: 30)
        ])

        NSLayoutConstraint.activate([
            rssiValueLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            rssiValueLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            rssiValueLabel.heightAnchor.constraint(equalToConstant: 20)
        ])

        NSLayoutConstraint.activate([
            modelsLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            modelsLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            modelsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            modelsLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
        ])
    }

    @objc func buttonDidTapped() {
        BluetoothManager.shared.startScanningIfCan()
        self.infoLabel.text = nil
        self.infoLabel.backgroundColor = .clear
    }

    @objc func stepperValueChanged() {
        GlobalStorage.shared.minimalRSSI = Int(stepper.value)
        rssiValueLabel.text = String(stepper.value)
    }
}

extension ViewController: BluetoothManagerDelegate {
    func didReceiveDeviceWithRSSI(model: BluetoothTagModel) {
        DispatchQueue.main.async {
            self.logLabel.text = nil
            self.logLabel.backgroundColor = .clear

            self.infoLabel.backgroundColor = .green
            self.infoLabel.text = model.description
        }
    }

    func didUpdateModels(models: [BluetoothTagModel]) {
        let models = models.sorted { lModel, rModel in
            lModel.rssi > rModel.rssi
        }

        let str = models.map { $0.description }.joined(separator: "\n")
        DispatchQueue.main.async {
            self.modelsLabel.text = str
        }

        guard let topModel = models.first else { return }
        DispatchQueue.main.async {
            let color = (100.0 + Double(topModel.rssi)) / 100.0
            self.logLabel.text = topModel.name
            self.logLabel.backgroundColor = UIColor(red: 1.0 - CGFloat(color), green: CGFloat(color), blue: 0, alpha: 1)
        }
    }
}
