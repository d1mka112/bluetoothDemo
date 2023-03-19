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
        static let insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        static let offset: CGFloat = 64
        static let format: String = "N (NNN) NNN NN-NN"
    }
    
    let descriptionImageView: UIImageView = {
        let imageView = UIImageView(image: Spec.Images.speechBubble).prepareForConstrains()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel().prepareForConstrains()
        label.text = "SMS с кодом отправлен на номер телефона \n\(self.phoneNumber.format(Constants.format, oldString: self.phoneNumber))"
        label.textColor = Spec.Color.gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let inputTextField: UITextField = {
        let textField = TextField().prepareForConstrains()
        textField.placeholder = "Введите код из SMS"
        textField.textColor = Spec.Color.secondary
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = TuganButton().prepareForConstrains()
        button.setTitle("Отправить", for: .normal)
        button.setTitleColor(.white, for: .normal)
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

    var phoneNumber: String

    var tapGesture: UIGestureRecognizer?

    init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func sendButtonDidTapped() {
        guard 
            let code = inputTextField.text,
            Validation.isValidCode(code: code) 
        else {
            ControllerHelper.pushAlert(title: "Ошибка", message: "Код набран неправильно")
            return
        }

        Networker.sendTokenRequest(for: code, phone: phoneNumber) { [weak self] response in 
            guard let response = response else {
                ControllerHelper.pushAlert()
                return
            }

            if response.result {
                DispatchQueue.main.async {
                    self?.navigationController?.setViewControllers([MainViewController()], animated: true)
                }
            } else if let error = response.error {
                ControllerHelper.pushAlert(title: "Ошибка", message: error)
            } 
        }
    }

    @objc func didTapOnScreen() {
        view.endEditing(true)
    }
    
    @objc func handleKeyboardShowing(notification: NSNotification) {
        tapGesture?.isEnabled = true
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }

        let convertFrame = vStackView.convert(inputTextField.frame, to: scrollView)
        let visibleOffset = scrollView.frame.height - keyboardFrame.height
        let offset = convertFrame.maxY + 64 - visibleOffset - 18
        if offset < 0 {
            scrollView.setContentOffset(.init(x: .zero, y: offset), animated: true)
        }
    }

    @objc func handleKeyboardHiding(notification: NSNotification) {
        tapGesture?.isEnabled = false
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = Spec.Color.lightGray
        setupSubviews()

        scrollView.contentInset = Constants.insets

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnScreen))
        view.addGestureRecognizer(tapGesture!)

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowing(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHiding(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "SMS Код"

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = NavigationBarAppearance.other()
        navigationController?.navigationBar.scrollEdgeAppearance = NavigationBarAppearance.other()
        navigationController?.navigationBar.compactAppearance = NavigationBarAppearance.other()

        navigationController?.navigationBar.tintColor = Spec.Color.secondary
    }
    
    private func setupSubviews() {
        sendButton.addTarget(self, action: #selector(sendButtonDidTapped), for: .touchUpInside)

        view.addSubview(scrollView)
        scrollView.addSubview(vStackView)

        vStackView.addArrangedSubview(descriptionImageView)
        vStackView.setCustomSpacing(30, after: descriptionImageView)
        vStackView.addArrangedSubview(descriptionLabel)
        vStackView.addArrangedSubview(inputTextField)
        vStackView.addArrangedSubview(sendButton)

        NSLayoutConstraint.activate([
            sendButton.heightAnchor.constraint(equalTo: inputTextField.heightAnchor),

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            vStackView.bottomAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: Constants.offset),
            vStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16),
            vStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16),
            vStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32)
        ])
    }
    
}


