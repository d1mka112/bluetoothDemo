//
//  MainViewController.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 21.12.2022.
//

import UIKit
import AVFoundation

final class MainViewController: VendistaViewController {
    let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Spec.Images.card
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let payView: PayView = {
        let payView = PayView()
        payView.startAnimating()
        payView.translatesAutoresizingMaskIntoConstraints = false
        return payView
    }()

    let scanLabel: UILabel = {
        let label = UILabel()
        label.tintColor = Spec.Color.primary
        label.text = Spec.Text.bringDeviceToTerminal
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var queueTasks: [()->Void] = []

    var isAccessGranted: Bool = false {
        didSet {
            guard !queueTasks.isEmpty else {
                return
            }
            queueTasks.forEach { $0() }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Spec.Color.primary
        BluetoothManager.shared.setDelegate(delegate: self)
        BluetoothManager.shared.setNeedsToStartScanning()
        BluetoothManager.shared.startScanningIfCan()
        setupSubviews()

        BiometricsManager.checkBiometrics { result, error in
            self.isAccessGranted = result
        }
    }

    private func setupSubviews() {
        view.addSubview(cardImageView)
        view.addSubview(payView)
        view.addSubview(scanLabel)

        NSLayoutConstraint.activate([
            cardImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16
            ),
            cardImageView.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16
            ),
            cardImageView.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16
            ),
            cardImageView.heightAnchor.constraint(
                equalTo: cardImageView.widthAnchor, multiplier: 13/20
            ),

            payView.topAnchor.constraint(
                equalTo: cardImageView.bottomAnchor, constant: 60
            ),
            payView.centerXAnchor.constraint(
                equalTo: cardImageView.centerXAnchor
            ),

            scanLabel.topAnchor.constraint(
                equalTo: payView.bottomAnchor, constant: 20
            ),
            scanLabel.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor, constant:  16
            ),
            scanLabel.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16
            )
        ])
    }
}

extension MainViewController: BluetoothManagerDelegate {
    func didUpdateModels(models: [BluetoothTagModel]) {
    }
    
    func didReceiveDeviceWithRSSI(model: BluetoothTagModel) {
        payView.stopAnimating()

        if isAccessGranted {
            sendUUID(model: model)
        } else {
            queueTasks.append { [weak self] in
                self?.sendUUID(model: model)
            }
        }
    }

    func sendUUID(model: BluetoothTagModel) {
        Networker.sendDeviceRequest(
            for: Device(
                uuid: model.name!,
                token: GlobalStorage.shared.token ?? ""
            )
        ) { [weak self] response in
            guard
                let self = self,
                let isSuccess = response?.success
            else { return }

            if isSuccess {
                FeedbackGenerator.success()
                GlobalPlayer.paySuccess()
                DispatchQueue.main.async {
                    self.payView.animateSuccess()
                    self.scanLabel.text = Spec.Text.scanDeviceSuccess
                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    UIControl().sendAction(
//                        #selector(NSXPCConnection.suspend),
//                        to: UIApplication.shared, for: nil
//                    )
//                }
            } else {
                FeedbackGenerator.error()
                BluetoothManager.shared.startScanningIfCan()
                DispatchQueue.main.async {
                    self.payView.animateError()
                    self.scanLabel.text = Spec.Text.scanDeviceError
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.scanLabel.text = Spec.Text.bringDeviceToTerminal
                    self.payView.startAnimating()
                }
            }
        }
    }
}
