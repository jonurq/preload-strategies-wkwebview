//
//  URLConfig.swift
//  WKWebViewPreloadStrategies
//
//  Created by Jonatán Ezequiel Urquiza Martinez on 27/11/2022.
//

import Foundation

struct URLConfig {
    static let baseURL = "http://pyara1541.local:8080/"

    static let shoplistURL = baseURL + "shoplist.html"

    static let homeURL = baseURL + "home.html"

    static let homePreloadURL = baseURL + "home-preload.html"

    static let homeLocalURL = baseURL + "local/home-local.html"

    static let preloadURL = baseURL + "preload.html"
}
