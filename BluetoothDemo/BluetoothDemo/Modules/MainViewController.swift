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
        let imageView = UIImageView().prepareForConstrains()
        imageView.image = Spec.Images.card
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    let removeCardButton: UIButton = {
        let button = HighlightingButton().prepareForConstrains()
//        button.setTitle("-", for: .normal)
//        button.backgroundColor = .red
        button.setImage(.remove, for: .normal)
        button.tintColor = .white
        return button
    }()

    let cardNumberLabel: UILabel = {
        let label = UILabel().prepareForConstrains()
        label.textColor = .white
        return label
    }()

    let payView: GIFImageView = {
        let gifImageView = GIFImageView()
        gifImageView.contentMode = .scaleAspectFit
        gifImageView.animationRepeatCount = 0
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        return gifImageView
    }()

    let emptyLabel: UILabel = {
        let label = UILabel().prepareForConstrains()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "У вас пока нет карт для оплаты"
        label.textColor = Spec.Color.gray
        return label
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

    lazy var cardBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(
            barButtonSystemItem: .add, 
            target: self, 
            action: #selector(cardBarButtonDidTapped)
        )
        return barButton
    }()

    lazy var logoutBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(
            title: "Выйти", 
            style: .plain, 
            target: self, 
            action: #selector(logoutBarButtonDidTapped)
        )
        return barButton
    }()

    var queueTasks: [()->Void] = []

    var isAccessGranted: Bool = false {
        didSet {
            guard !queueTasks.isEmpty else {
                return
            }
            queueTasks.last?()
            queueTasks.removeAll()
        }
    }

    var shouldScan: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Spec.Color.primary
        BluetoothManager.shared.setDelegate(delegate: self)
        BluetoothManager.shared.setNeedsToStartScanning()

        // TODO: Fix Костыль
        let group = DispatchGroup()
        group.enter()
        Networker.sendGetUserCards() { _ in
            group.leave()
        } 
        group.wait()

//        if let items = GlobalStorage.shared.cards?.items {
//            for card in items {
//                Networker.sendDeleteUserCard(for: card.id) { _ in
//                    GlobalStorage.shared.cards?.items.removeAll { item in
//                        item.id == card.id
//                    }
//                }
//            }
//        }

        setupSubviews()
        setupCardView()
        setupNotifications()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupCardView()
        startScan()

        navigationItem.title = "Tugan Pay"

        navigationItem.rightBarButtonItem = cardBarButton
        navigationItem.leftBarButtonItem = logoutBarButton

        navigationController?.navigationBar.standardAppearance = NavigationBarAppearance.main()
        navigationController?.navigationBar.scrollEdgeAppearance = NavigationBarAppearance.main()
        navigationController?.navigationBar.compactAppearance = NavigationBarAppearance.main()

        navigationController?.navigationBar.tintColor = Spec.Color.secondary
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func startScan() {
        if GlobalStorage.shared.cards?.items.isEmpty == false && shouldScan {
            BiometricsManager.checkBiometrics { result, error in
                defer { BluetoothManager.shared.startScanningIfCan() }
                if result {
                    self.isAccessGranted = result
                } else {
                    SuspendHelper.suspend()
                }
            }
        }
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appMovedToForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appMovedToBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    @objc func appMovedToBackground() { 
        isAccessGranted = false
    }

    @objc func appMovedToForeground() {
        if GlobalStorage.shared.cards?.items.isEmpty == false && shouldScan {
            if !isAccessGranted {
                defer { BluetoothManager.shared.startScanningIfCan() }
                BiometricsManager.checkBiometrics { result, error in
                    if result {
                        self.isAccessGranted = result
                    } else {
                        SuspendHelper.suspend()
                    }
                }
            }
        }
    }

    @objc func cardBarButtonDidTapped() {
        navigationController?.pushViewController(AddCardController(), animated: true)
    }

    @objc func logoutBarButtonDidTapped() {
        GlobalStorage.shared.token = nil
        GlobalStorage.shared.cards = nil
        navigationController?.setViewControllers([AuthorizationController()], animated: true)
    }

    @objc func removeCardButtonDidTapped() {
        guard let card = GlobalStorage.shared.cards?.items.first else { return }

        Networker.sendDeleteUserCard(for: card.id) { _ in
            GlobalStorage.shared.cards?.items.removeAll { item in
                item.id == card.id
            }
            self.setupCardView()
        }
    }

    private func setupCardView() {
        DispatchQueue.main.async {
            if GlobalStorage.shared.cards?.items.isEmpty != false {
                self.cardImageView.isHidden = true
                self.payView.isHidden = true
                self.emptyLabel.isHidden = false
            } else if let cardNubmer = GlobalStorage.shared.cards?.items.first?.cardNumber {
                self.cardNumberLabel.text = 
                cardNubmer.replacingOccurrences(of: "*", with: "•")
                self.cardImageView.isHidden = false
                self.payView.isHidden = false
                self.emptyLabel.isHidden = true
            }
        }
    }

    private func setupSubviews() {
        removeCardButton.addTarget(self, action: #selector(removeCardButtonDidTapped), for: .touchUpInside)

        view.addSubview(cardImageView)
        view.addSubview(payView)
        view.addSubview(emptyLabel)

        cardImageView.addSubview(cardNumberLabel)
        cardImageView.addSubview(removeCardButton)
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

            cardNumberLabel.bottomAnchor.constraint(
                equalTo: cardImageView.bottomAnchor, constant: -16
            ),
            cardNumberLabel.leftAnchor.constraint(
                equalTo: cardImageView.leftAnchor, constant: 16
            ),

            removeCardButton.topAnchor.constraint(
                equalTo: cardImageView.topAnchor, constant: 16
            ),
            removeCardButton.rightAnchor.constraint(
                equalTo: cardImageView.rightAnchor, constant:  -16
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

            emptyLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            emptyLabel.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
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

    private func doSuccess() {
        DispatchQueue.main.async {
            FeedbackGenerator.success()
            GlobalPlayer.paySuccess()
            self.payView.animate(
                withGIFNamed: Spec.GIFs.success,
                loopCount: 1
            )
        }

        if Toggle.shutDownWhenSuccess.isActive {
            SuspendHelper.suspend(after: 2)
        }
    }

    private func doError() {
        DispatchQueue.main.async {
            FeedbackGenerator.error()
            self.payView.animate(
                withGIFNamed: Spec.GIFs.reject,
                loopCount: 1,
                animationBlock:  {
//                    BluetoothManager.shared.startScanningIfCan()
                }
            )
        }
    }
}

extension MainViewController: BluetoothManagerDelegate {
    func didStartScanning() {
        DispatchQueue.main.async {
            self.payView.animate(withGIFNamed: Spec.GIFs.bringDeviceToReader)
    //        scanLabel.text = Spec.Text.bringDeviceToTerminal
        }
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
        shouldScan = false
        if Toggle.sendBleListRequest.isActive {
            Networker.sendBleListRequest(for: model) { [weak self] response in
                guard let response = response else { return }
                if response.result == 1 {
                    LoggerHelper.success("Оплата прошла успешно")
                    self?.doSuccess()

                    guard 
                        Toggle.shouldShowTransaction.isActive,
                        let item = response.item, 
                        let price = response.price 
                    else {
                        self?.shouldScan = true
                        return 
                    }
                    ControllerHelper.pushAlert(
                        title: "Покупка!", 
                        message: "Товар: \(item) - Цена: \(price)"
                    ) {
                        self?.shouldScan = true
//                        BluetoothManager.shared.startScanningIfCan()
                    }
                } else {
                    self?.doError()
                    LoggerHelper.error("Оплата отклонена")
                    ControllerHelper.pushAlert(
                        title: "Ошибка \(response.result)", 
                        message: response.error ?? ""
                    ) {
                        self?.shouldScan = true
//                        BluetoothManager.shared.startScanningIfCan()
                    }
                }
            }
        } else {
            LoggerHelper.success("Оплата прошла успешно")
            shouldScan = true
            doSuccess()
        }
    }
}
