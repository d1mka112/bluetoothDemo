//
//  TextField.swift
//  BluetoothDemo
//
//  Created by d.leukhin on 12.03.2023.
//

import UIKit

class TextField: UITextField, UITextFieldDelegate {

    var textIntets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    var placeholderColor: UIColor? { didSet { updatePlaceholder() } }

    override var placeholder: String? { didSet { updatePlaceholder() } }

    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self

        setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textIntets)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textIntets)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textIntets)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupAppearance()
    }

    private func setupAppearance() {
        layer.cornerRadius = 10
        layer.masksToBounds = true

        backgroundColor = UIColor.white
        textIntets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        placeholderColor = UIColor.darkGray
    }

    private func updatePlaceholder() {
        guard let placeholder = placeholder else { return }
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: placeholderColor ?? .clear
            ]
        )
    }
}
