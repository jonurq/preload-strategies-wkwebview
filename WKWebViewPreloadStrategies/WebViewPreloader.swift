//
//  WebViewPreloader.swift
//  WKWebViewPreloadStrategies
//
//  Created by Jonatán Ezequiel Urquiza Martinez on 15/11/2022.
//

import Foundation
import WebKit
import Combine

protocol Preloader {
    func preload()
    func clean()
}

class WebViewPreloader: Preloader {
    static let shared = WebViewPreloader()

    private var _webview: WKWebView?

    private init() { }

    func preload() {
        guard let request = makeRequest() else { return }
        Task { @MainActor in
            let webview = makeWebview()
            webview.load(request)
        }
    }

    private func makeRequest() -> URLRequest? {
        guard let url = URL(string: URLConfig.preloadURL) else { return nil }
        return URLRequest(url: url)
    }

    private func makeWebview() -> WKWebView {
        if let webview = _webview { return webview }

        let webview = WKWebView()

        _webview = webview
        return webview
    }

    func clean() {
        _webview = nil
    }
}
