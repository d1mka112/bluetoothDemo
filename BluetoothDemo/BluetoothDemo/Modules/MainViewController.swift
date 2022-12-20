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

    let scanImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Spec.Images.checkmarkCircle.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Spec.Color.secondary
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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

        setupSubviews()
    }

    private func setupSubviews() {
        view.addSubview(cardImageView)
        view.addSubview(scanImageView)
        view.addSubview(scanLabel)

        NSLayoutConstraint.activate([
            cardImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cardImageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            cardImageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),

            scanImageView.topAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: 60),
            scanImageView.centerXAnchor.constraint(equalTo: cardImageView.centerXAnchor),
            scanImageView.widthAnchor.constraint(equalToConstant: 60),
            scanImageView.heightAnchor.constraint(equalToConstant: 60),

            scanLabel.topAnchor.constraint(equalTo: scanImageView.bottomAnchor, constant: 20),
            scanLabel.centerXAnchor.constraint(equalTo: scanImageView.centerXAnchor),
            scanLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}
