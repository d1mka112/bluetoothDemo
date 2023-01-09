//
//  TogglesViewController.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 03.01.2023.
//

import UIKit

#if DEBUG
final class ToggleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ToggleTableViewCell.self, forCellReuseIdentifier: "ToggleTableViewCell")

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ToggleStorage.shared.toggles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleTableViewCell") as? ToggleTableViewCell,
            ToggleStorage.shared.toggles[safe: indexPath.row] != nil
        else {
            return UITableViewCell()
        }
        cell.tag = indexPath.row
        cell.prepareForReuse()
        return cell
    }
}
#endif
