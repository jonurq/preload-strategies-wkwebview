//
//  ExampleTableViewController.swift
//  WKWebViewPreloadStrategies
//
//  Created by Jonatán Ezequiel Urquiza Martinez on 15/11/2022.
//

import UIKit

class ExampleTableViewController: UITableViewController {
    let presenter: ExampleTableViewPresenter
    let cellIdentifier = "reuseIdentifier"

    required init(presenter: ExampleTableViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Example Flows"

        self.presenter.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        cell.textLabel?.text = presenter.rows[indexPath.row].title

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        presenter.didSelectRow(presenter.rows[indexPath.row])
    }
}

extension ExampleTableViewController: ExampleTableViewDelegate {
    func pushViewController(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}
