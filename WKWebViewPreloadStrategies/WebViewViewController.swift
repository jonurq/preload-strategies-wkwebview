//
//  WebViewViewController.swift
//  WKWebViewPreloadStrategies
//
//  Created by Jonatán Ezequiel Urquiza Martinez on 12/11/2022.
//

import UIKit
import WebKit
import UniformTypeIdentifiers
import Combine

class WebViewViewController: UIViewController {

    private var subscriptions = Set<AnyCancellable>()

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

        webview.publisher(for: \.isLoading).dropFirst().sink { isLoading in
            print("//// is loading:", isLoading)
        }.store(in: &subscriptions)




        self.webview = webview
    }

    private func loadWebView() {
        guard let url = URL(string: urlString) else { return }

        let request = URLRequest(url: url)
        webview?.load(request)
    }
}


class CustomSchemeHandler: NSObject, WKURLSchemeHandler {
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        guard let url = urlSchemeTask.request.url,
              let filePath = filePath(from: url),
              let mimeType = mimeType(of: filePath),
              let data = try? Data(contentsOf: filePath) else {
            urlSchemeTask.didFailWithError(NSError(domain: "File not found locally", code: 404))
            return
        }

        let response = HTTPURLResponse(url: url,
                                       mimeType: mimeType,
                                       expectedContentLength: data.count, textEncodingName: nil)

        urlSchemeTask.didReceive(response)
        urlSchemeTask.didReceive(data)
        urlSchemeTask.didFinish()
    }



    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        print("Stop urlSchemeTask")
    }

    private func filePath(from url: URL) -> URL? {
        let assetName = url.lastPathComponent
        print("Searching asset:", assetName)
        return Bundle.main.url(forResource: assetName,
                               withExtension: "")

    }

    private func mimeType(of url: URL) -> String? {
        guard let type = UTType(filenameExtension: url.pathExtension) else {
            return nil
        }
        return type.preferredMIMEType
    }
}

