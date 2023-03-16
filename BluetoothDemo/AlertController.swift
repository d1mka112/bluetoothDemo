//
//  AlertController.swift
//  BluetoothDemo
//
//  Created by d.leukhin on 17.03.2023.
//

import UIKit

final class LoaderController: UIViewController {
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large).prepareForConstrains()
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        preferredContentSize = CGSize(width: 150, height: 150)
    }

    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
    }

    override func viewWillDisappear(_ animated: Bool) {
        activityIndicator.stopAnimating()
    }

    func setupSubviews() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

final class AlertController: UIAlertController {

    // MARK: - Constants 

    private enum Constants {
        static let cornerRadius: CGFloat = 18
    }

    convenience init(viewController: UIViewController) {
        self.init(style: .alert)

        setCornerRadius(Constants.cornerRadius)
        setViewController(viewController: viewController)
    }
}

extension UIAlertController {
    convenience init(style: UIAlertController.Style, title: String? = nil, message: String? = nil) {
        self.init(title: title, message: message, preferredStyle: style)
    }

    func setViewController(viewController: UIViewController) {
        setValue(viewController, forKey: "contentViewController")
        view.backgroundColor = .clear
    }

    func setCornerRadius(_ vaule: CGFloat) {
        view.traverseRadius(vaule)
    }
}

private extension UIView {
    func traverseRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius

        for subview: UIView in subviews {
            subview.traverseRadius(radius)
        }
    }
}
