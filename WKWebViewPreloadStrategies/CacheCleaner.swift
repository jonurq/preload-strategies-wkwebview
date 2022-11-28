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
    }
}
