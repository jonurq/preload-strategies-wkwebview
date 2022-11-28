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
    private let navDelegate = WebViewPreloaderDelegate()
    private var subscriptions = Set<AnyCancellable>()

    private init() { }

    func preload() {
        Task { @MainActor in
            let webview = webview()
            let request = request()

            webview.load(request)
        }
    }

    private func request() -> URLRequest {
        return URLRequest(url: URL(string: URLConfig.preloadURL)!)
    }

    private func webview() -> WKWebView {
        if let webview = _webview {
            return webview
        }

        let webview = WKWebView()
        webview.navigationDelegate = navDelegate


        webview.publisher(for: \.isLoading).dropFirst().sink { isLoading in
            print("//// is loading:", isLoading)
        }.store(in: &subscriptions)

        webview.publisher(for: \.estimatedProgress).sink { estimatedProgress in
            print("/// Estimated progress:", estimatedProgress)
        }.store(in: &subscriptions)

        _webview = webview
        return webview
    }

    func clean() {
        _webview = nil
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        let dataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let store = WKWebsiteDataStore.default()
        store.fetchDataRecords(ofTypes: dataTypes) { records in
            records.forEach { record in
                store.removeData(
                    ofTypes: record.dataTypes,
                    for: [record],
                    completionHandler: {
                        print("webview cache cleaned")
                    }
                )
            }
        }
    }
}

class WebViewPreloaderDelegate: NSObject, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished")
        print("Web view is loading", webView.isLoading)
    }
}
