//
//  MainViewController.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 21.12.2022.
//

import UIKit

final class MainViewController: UIViewController {
    let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Spec.Images.card
        imageView.contentMode = .scaleAspectFill
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Spec.Color.primary
        // TODO: Удалить, пока только демонстрация
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.payView.stopAnimating()
            self.payView.animateError()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.payView.animateSuccess()
            }
        }
        setupSubviews()
    }

    private func setupSubviews() {
        view.addSubview(cardImageView)
        view.addSubview(payView)
        view.addSubview(scanLabel)

        NSLayoutConstraint.activate([
            cardImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cardImageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            cardImageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),

            payView.topAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: 60),
            payView.centerXAnchor.constraint(equalTo: cardImageView.centerXAnchor),

            scanLabel.topAnchor.constraint(equalTo: payView.bottomAnchor, constant: 20),
            scanLabel.centerXAnchor.constraint(equalTo: payView.centerXAnchor),
            scanLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}
