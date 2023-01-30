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
//        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
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

    private lazy var toggleSwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.isOn = false
        toggleSwitch.addTarget(self, action: #selector(toggleSwitchDidTouch), for: .allEvents)
        return toggleSwitch
    }()

    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        return stackView
    }()
 
    private let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        return stackView
    }()

    override var reuseIdentifier: String? {
        return "ToggleTableViewCell"
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
//        accessoryView = toggleSwitch
//        addSubview(titleLabel)
//        addSubview(descriptionLabel)
//        addSubview(toggleSwitch)
        addSubview(vStackView)
        vStackView.addArrangedSubview(hStackView)
        vStackView.addArrangedSubview(descriptionLabel)

        hStackView.addArrangedSubview(titleLabel)
        hStackView.addArrangedSubview(toggleSwitch)

        NSLayoutConstraint.activate([
            vStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            vStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            vStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            vStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
//            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
//            titleLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 8),
//            titleLabel.rightAnchor.constraint(lessThanOrEqualTo: toggleSwitch.leftAnchor, constant: -4),
//
//            toggleSwitch.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
//            toggleSwitch.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -4),
//
//            descriptionLabel.topAnchor.constraint(equalTo: toggleSwitch.bottomAnchor, constant: 8),
//            descriptionLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 8),
//            descriptionLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -8),
//            descriptionLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }

    func updateCellByTag() {
        guard let model = ToggleStorage.shared.toggles[safe: tag] else { return }
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        toggleSwitch.isOn = model.value
    }

    @objc func toggleSwitchDidTouch() {
        toggleSwitch.setOn(!toggleSwitch.isOn, animated: true)
        ToggleStorage.shared.toggles[tag].value.toggle()
    }
}
#endif
