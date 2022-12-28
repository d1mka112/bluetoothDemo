//
//  LogLabel.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 28.12.2022.
//

import Foundation
import UIKit

final class LogLabel: UIScrollView {
    private let label: UILabel = {
        let label = UILabel()
        label.tintColor = Spec.Color.primary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init() {
        super.init(frame: .zero)
        LoggerStorage.shared.add(delegate: self)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leftAnchor.constraint(equalTo: self.leftAnchor),
            label.rightAnchor.constraint(equalTo: self.rightAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
}

extension LogLabel: LoggerStorageDelegate {
    func didLogged(text: String) {
        DispatchQueue.main.async {
            let labelText = self.label.text ?? ""
            self.label.text = labelText + "\n" + text
        }
    }
}
