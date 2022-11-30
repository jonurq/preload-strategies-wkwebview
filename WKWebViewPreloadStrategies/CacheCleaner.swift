//
//  CacheCleaner.swift
//  WKWebViewPreloadStrategies
//
//  Created by Jonatán Ezequiel Urquiza Martinez on 12/11/2022.
//

import Foundation
import WebKit

struct CacheCleaner {
    static func clean() {
        WebViewPreloader.shared.clean()
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
