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

    var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()

    var isAnimating: Bool = false

    override var intrinsicContentSize: CGSize {
        CGSize(width: 80, height: 80)
    }

    init() {
        super.init(frame: .zero)
        setupSubviews()
        xmark.isHidden = true
        xmark.alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func resetViews() {
        xmark.alpha = 0
        checkMark.alpha = 0
        circle.tintColor = .black
    }

    func startAnimating() {
        resetViews()
        activityIndicatorView.startAnimating()
    }

    func stopAnimating() {
        resetViews()
        activityIndicatorView.stopAnimating()
    }

    func animateSuccess() {
        stopAnimating()
        UIView.animate(withDuration: 0.5) {
            self.resetViews()
            self.checkMark.alpha = 1
            self.checkMark.tintColor = .systemBlue
            self.circle.tintColor = .systemBlue
        }
    }

    func animateError() {
        self.stopAnimating()
        UIView.animate(withDuration: 0.5) {
            self.resetViews()
            self.checkMark.alpha = 0
            self.xmark.tintColor = .systemRed
            self.circle.tintColor = .systemRed
        }
    }

    private func firstAnimationBlock() {
        guard isAnimating else { return }
        UIView.animate(withDuration: 0.5) {
            self.xmark.tintColor = .black
            self.xmark.alpha = 0

            self.circle.tintColor = .black
    
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
            self.xmark.tintColor = .black
            self.xmark.alpha = 0

            self.circle.tintColor = .black

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
        circle.addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            circle.topAnchor.constraint(
                equalTo: self.topAnchor, constant: 10
            ),
            circle.leftAnchor.constraint(
                equalTo: self.leftAnchor,constant: 10
            ),
            circle.rightAnchor.constraint(
                equalTo: self.rightAnchor, constant: -10
            ),
            circle.bottomAnchor.constraint(
                equalTo: self.bottomAnchor, constant: -10
            ),

            checkMark.topAnchor.constraint(
                equalTo: circle.topAnchor, constant: 15
            ),
            checkMark.leftAnchor.constraint(
                equalTo: circle.leftAnchor,constant: 15
            ),
            checkMark.rightAnchor.constraint(
                equalTo: circle.rightAnchor, constant: -15
            ),
            checkMark.bottomAnchor.constraint(
                equalTo: circle.bottomAnchor, constant: -15
            ),

            xmark.topAnchor.constraint(
                equalTo: circle.topAnchor, constant: 15
            ),
            xmark.leftAnchor.constraint(
                equalTo: circle.leftAnchor,constant: 15
            ),
            xmark.rightAnchor.constraint(
                equalTo: circle.rightAnchor, constant: -15
            ),
            xmark.bottomAnchor.constraint(
                equalTo: circle.bottomAnchor, constant: -15
            ),

            activityIndicatorView.topAnchor.constraint(
                equalTo: circle.topAnchor, constant: 15
            ),
            activityIndicatorView.leftAnchor.constraint(
                equalTo: circle.leftAnchor,constant: 15
            ),
            activityIndicatorView.rightAnchor.constraint(
                equalTo: circle.rightAnchor, constant: -15
            ),
            activityIndicatorView.bottomAnchor.constraint(
                equalTo: circle.bottomAnchor, constant: -15
            ),
        ])
    }
}
