//
//  HomeViewController.swift
//  WKWebViewPreloadStrategies
//
//  Created by Jonatán Ezequiel Urquiza Martinez on 27/11/2022.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var shouldPreload = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home Screen"

        configureButton()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if shouldPreload {
            WebViewPreloader.shared.preload()
        }
    }

    private func setupView() {
        view.backgroundColor = .darkGray
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func configureButton() {
        button.setTitle("Go to Shoplist", for: .normal)
        button.addTarget(self, action: #selector(navigateToShopList), for: .touchUpInside)
    }

    @objc
    private func navigateToShopList() {
        let vc = WebViewViewController(url: URLConfig.shoplistURL)
        navigationController?.pushViewController(vc, animated: true)
    }
}
