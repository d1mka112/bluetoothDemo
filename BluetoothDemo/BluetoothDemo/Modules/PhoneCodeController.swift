//
//  PhoneCodeController.swift
//  BluetoothDemo
//
//  Created by r.mustafin on 14.03.2023.
//

import Foundation
import UIKit

class PhoneCodeController: VendistaViewController {
    
    enum Constants {
        static let insets: UIEdgeInsets = UIEdgeInsets(top: 60, left: 0, bottom: 60, right: 0)
    }
    
    let topView: UIView = {
        let view = UIView().prepareForConstrains()
        view.backgroundColor = Spec.Color.background
        return view
    }()

    let logoImageView: UIView = {
        let imageView = UIImageView(image: Spec.Images.logo).prepareForConstrains()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let descriptionImageView: UIImageView = {
        let imageView = UIImageView(image: Spec.Images.speechBubble).prepareForConstrains()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel().prepareForConstrains()
        label.text = "Авторизация"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel().prepareForConstrains()
        label.text = "SMS с кодом отправлен на телефона"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    let inputTextField: UITextField = {
        let textField = TextField().prepareForConstrains()
        textField.placeholder = "Введите код из SMS"
        textField.textColor = UIColor.black
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton().prepareForConstrains()
        button.setTitle("Отправить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Spec.Color.accent
        button.layer.cornerRadius = 10
        return button
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView().prepareForConstrains()
        return scrollView
    }()

    let vStackView: UIStackView = {
        let stackView = UIStackView().prepareForConstrains()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    @objc func handleKeyboardShowing(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }

        var contentInset = Constants.insets
        contentInset.bottom = contentInset.bottom + keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }

    @objc func handleKeyboardHiding(notification: NSNotification) {
    }
    
    override func viewDidLoad() {
        view.backgroundColor = Spec.Color.lightGray
        setupSubviews()

        scrollView.contentInset = Constants.insets

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowing(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowing(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.titleView = logoImageView

        navigationController?.navigationBar.standardAppearance = NavigationBarAppearance.main()
        navigationController?.navigationBar.scrollEdgeAppearance = NavigationBarAppearance.main()
        navigationController?.navigationBar.compactAppearance = NavigationBarAppearance.main()

        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupSubviews() {
        //sendButton.addTarget(self, action: #selector(sendButtonDidTapped), for: .touchUpInside)

        view.addSubview(scrollView)
        scrollView.addSubview(vStackView)

        vStackView.addArrangedSubview(titleLabel)
        vStackView.setCustomSpacing(60, after: titleLabel)
        vStackView.addArrangedSubview(descriptionImageView)
        vStackView.setCustomSpacing(60, after: descriptionImageView)
        vStackView.addArrangedSubview(descriptionLabel)
        vStackView.addArrangedSubview(inputTextField)
        vStackView.addArrangedSubview(sendButton)

        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 35),

            sendButton.heightAnchor.constraint(equalTo: inputTextField.heightAnchor),

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            vStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            vStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16),
            vStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16),
            vStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32)
        ])
    }
    
}


