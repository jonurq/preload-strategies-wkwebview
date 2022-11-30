//
//  WebViewViewController.swift
//  WKWebViewPreloadStrategies
//
//  Created by Jonatán Ezequiel Urquiza Martinez on 12/11/2022.
//

import UIKit
import WebKit
import Combine

class WebViewViewController: UIViewController {

    let urlString: String
    let customHandler: Bool

    var webview: WKWebView?

    init(url: String, customHandler: Bool = false) {
        urlString = url
        self.customHandler = customHandler
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "WKWebView"

        configureWebView()
        setupView()
        loadWebView()
    }

    private func setupView() {
        guard let webview = webview else {
            return
        }

        view.backgroundColor = .secondarySystemBackground
        view.addSubview(webview)
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            webview.topAnchor.constraint(equalTo: guide.topAnchor),
            webview.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            webview.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            webview.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
        ])
    }

    private func configureWebView() {
        let configuration = WKWebViewConfiguration()
        if customHandler {
            configuration.setURLSchemeHandler(CustomSchemeHandler(), forURLScheme: "peya-local")
        }

        let webview = WKWebView(frame: .zero, configuration: configuration)
        webview.translatesAutoresizingMaskIntoConstraints = false

        self.webview = webview
    }

    private func loadWebView() {
        guard let url = URL(string: urlString) else { return }

        let request = URLRequest(url: url)
        webview?.load(request)
    }
}
