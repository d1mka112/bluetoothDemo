//
//  MainViewController.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 21.12.2022.
//

import UIKit
import AVFoundation
import Gifu

final class MainViewController: VendistaViewController {
    let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Spec.Images.card
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let payView: GIFImageView = {
        let gifImageView = GIFImageView()
        gifImageView.contentMode = .scaleAspectFit
        gifImageView.animationRepeatCount = 0
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        return gifImageView
    }()

//    let scanLabel: UILabel = {
//        let label = UILabel()
//        label.tintColor = Spec.Color.primary
//        label.text = Spec.Text.bringDeviceToTerminal
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()

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
//        view.addSubview(scanLabel)

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
                equalTo: cardImageView.bottomAnchor
            ),
            payView.centerXAnchor.constraint(
                equalTo: cardImageView.centerXAnchor
            ),
            payView.widthAnchor.constraint(
                equalTo: cardImageView.widthAnchor, multiplier: 0.8
            ),
            payView.heightAnchor.constraint(
                equalTo: payView.widthAnchor, multiplier: 3/4
            ),

//            scanLabel.topAnchor.constraint(
//                equalTo: payView.bottomAnchor, constant: 20
//            ),
//            scanLabel.leftAnchor.constraint(
//                equalTo: view.safeAreaLayoutGuide.leftAnchor, constant:  16
//            ),
//            scanLabel.rightAnchor.constraint(
//                equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16
//            )
        ])
    }
}

extension MainViewController: BluetoothManagerDelegate {
    func didStartScanning() {
        payView.animate(withGIFNamed: Spec.GIFs.bringDeviceToReader)
//        scanLabel.text = Spec.Text.bringDeviceToTerminal
    }

    func didStopScanning() {
//        scanLabel.text = Spec.Text.scanStopped
    }

    func didUpdateModels(models: [BluetoothTagModel]) {
    }

    func didReceiveDeviceWithRSSI(model: BluetoothTagModel) {
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
                DispatchQueue.main.async {
                    FeedbackGenerator.success()
                    GlobalPlayer.paySuccess()
                    self.payView.animate(withGIFNamed: Spec.GIFs.success, loopCount: 1)
//                    self.scanLabel.text = Spec.Text.scanDeviceSuccess
                }
                if Toggle.shutDownWhenSuccess.isActive {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        UIControl().sendAction(
                            #selector(NSXPCConnection.suspend),
                            to: UIApplication.shared, for: nil
                        )
                    }
                }
            } else {
                DispatchQueue.main.async {
                    FeedbackGenerator.error()
                    self.payView.animate(
                        withGIFNamed: Spec.GIFs.reject,
                        loopCount: 1,
                        animationBlock:  {
                            BluetoothManager.shared.startScanningIfCan()
//                              self.scanLabel.text = Spec.Text.bringDeviceToTerminal
                    })
//                      self.scanLabel.text = Spec.Text.scanDeviceError
                }
            }
        }
    }
}
