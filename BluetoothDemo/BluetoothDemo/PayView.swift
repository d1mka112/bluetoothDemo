//
//  PayView.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 22.12.2022.
//

import UIKit

final class PayView: UIView {
    var checkMark: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var circle: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var xmark: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark")
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var isAnimating: Bool = false

    override var intrinsicContentSize: CGSize {
        CGSize(width: 80, height: 80)
    }

    init() {
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startAnimating() {
        isAnimating = true
        xmark.isHidden = true
        xmark.alpha = 0
        firstAnimationBlock()
    }

    func stopAnimating() {
        isAnimating = false
    }

    func animateSuccess() {
        UIView.animate(withDuration: 0.5) {
            self.xmark.alpha = 0
            self.checkMark.isHidden = false
            self.checkMark.alpha = 1
            self.checkMark.tintColor = .systemBlue
            self.circle.tintColor = .systemBlue
        }
    }

    func animateError() {
        UIView.animate(withDuration: 0.5) {
            self.xmark.isHidden = false
            self.xmark.alpha = 1
            self.checkMark.alpha = 0
            self.xmark.tintColor = .systemRed
            self.circle.tintColor = .systemRed
        }
    }

    private func firstAnimationBlock() {
        guard isAnimating else { return }
        UIView.animate(withDuration: 0.5) {
            self.checkMark.alpha = 1
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.secondAnimationBlock()
            }
        }
    }

    private func secondAnimationBlock() {
        guard isAnimating else { return }
        UIView.animate(withDuration: 0.5) {
            self.checkMark.alpha = 0
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.firstAnimationBlock()
            }
        }
    }

    private func setupSubviews() {
        addSubview(circle)
        circle.addSubview(checkMark)
        circle.addSubview(xmark)

        NSLayoutConstraint.activate([
            circle.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            circle.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 10),
            circle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            circle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),

            checkMark.topAnchor.constraint(equalTo: circle.topAnchor, constant: 15),
            checkMark.leftAnchor.constraint(equalTo: circle.leftAnchor,constant: 15),
            checkMark.rightAnchor.constraint(equalTo: circle.rightAnchor, constant: -15),
            checkMark.bottomAnchor.constraint(equalTo: circle.bottomAnchor, constant: -15),

            xmark.topAnchor.constraint(equalTo: circle.topAnchor, constant: 15),
            xmark.leftAnchor.constraint(equalTo: circle.leftAnchor,constant: 15),
            xmark.rightAnchor.constraint(equalTo: circle.rightAnchor, constant: -15),
            xmark.bottomAnchor.constraint(equalTo: circle.bottomAnchor, constant: -15)
        ])
    }
}
