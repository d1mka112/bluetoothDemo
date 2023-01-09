//
//  ModalDebugViewController.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 05.01.2023.
//
#if DEBUG
import UIKit

final class ModalDebugViewController: UIViewController {
    let offset: CGFloat = 8
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = Spec.Color.primary
        label.textAlignment = .center
        return label
    }()

    func with(title: String, viewController: UIViewController) -> UIViewController {
        view.backgroundColor = Spec.Color.primary
        titleLabel.text = title
        viewController.view.translatesAutoresizingMaskIntoConstraints = false

        addChild(viewController)
        view.addSubview(viewController.view)
        view.addSubview(titleLabel)
        viewController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offset),
            titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: offset),
            titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -offset),

            viewController.view.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: offset),
            viewController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: offset),
            viewController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -offset),
            viewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -offset)
        ])
        return self
    }
}
#endif
