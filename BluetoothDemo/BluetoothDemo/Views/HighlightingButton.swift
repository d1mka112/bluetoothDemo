//
//  HighlightingButton.swift
//  BluetoothDemo
//
//  Created by d.leukhin on 15.03.2023.
//

import UIKit

class HighlightingButton: UIButton {

    // MARK: - Constants

    private enum Constants {
        static let durationAfterHighlight: CGFloat = 0.1
        static let durationBeforeHighlight: CGFloat = 0.2
        static let alphaHighlighted: CGFloat = 0.6
        static let alphaDefault: CGFloat = 1

        static let cornerRadius: CGFloat = 10
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: isHighlighted ? 0.1 : 0.2) {
                self.alpha = self.isHighlighted ? 0.6 : 1
            }
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupAppearance()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAppearance() {
        layer.cornerRadius = Constants.cornerRadius
        backgroundColor = Spec.Color.accent
    }
}
