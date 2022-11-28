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

    private let cache = NSCache<NSString, WKWebView>()
    private let navDelegate = WebViewPreloaderDelegate()
    private let cacheDelegate = WebViewCacheDelegate()
    private var subscriptions = Set<AnyCancellable>()

    private init() {
        cache.delegate = cacheDelegate
    }

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
        if let cachedWebView = cache.object(forKey: Constants.cacheKey) {
            return cachedWebView
        }

        let webView = WKWebView()
        webView.navigationDelegate = navDelegate


        webView.publisher(for: \.isLoading).dropFirst().sink { isLoading in
            print("//// is loading:", isLoading)
        }.store(in: &subscriptions)

        webView.publisher(for: \.estimatedProgress).sink { estimatedProgress in
            print("/// Estimated progress:", estimatedProgress)
        }.store(in: &subscriptions)

        cache.setObject(webView, forKey: Constants.cacheKey)
        return webView
    }

    func clean() {
        cache.removeAllObjects()
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

    func removeWebView() {
        cache.removeAllObjects()



    }

    enum Constants {
        static let cacheKey: NSString = "cache_webview_key"
    }
}

class WebViewPreloaderDelegate: NSObject, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished")
        print("Web view is loading", webView.isLoading)
        
        //WebViewPreloader.shared.removeWebView()

    }
}

class WebViewCacheDelegate: NSObject, NSCacheDelegate {
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        print("Will evict object")
    }
}
