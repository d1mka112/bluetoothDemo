//
//  ToggleTableViewCell.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 05.01.2023.
//

import UIKit

#if DEBUG
final class ToggleTableViewCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = Spec.Color.primary
        label.textAlignment = .left
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Spec.Color.gray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()

    private let toggleSwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.isOn = false
        toggleSwitch.addTarget(self, action: #selector(toggleSwitchDidTouch), for: .allEvents)
        return toggleSwitch
    }()

    private var model: ToggleData?

    override var reuseIdentifier: String? {
        return "ToggleTableViewCell"
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        accessoryView = toggleSwitch
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(toggleSwitch)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 8),

            toggleSwitch.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 2),
            toggleSwitch.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 2),
            toggleSwitch.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -2),

            descriptionLabel.topAnchor.constraint(equalTo: toggleSwitch.bottomAnchor, constant: 8),
            descriptionLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 8),
            descriptionLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }

    func configure(model: ToggleData) {
        self.model = model
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        toggleSwitch.isOn = model.value
    }

    @objc func toggleSwitchDidTouch() {
        model?.value.toggle()
    }
}
#endif
