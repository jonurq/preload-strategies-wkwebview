//
//  FlowModel.swift
//  WKWebViewPreloadStrategies
//
//  Created by Jonatán Ezequiel Urquiza Martinez on 27/11/2022.
//

import Foundation

enum FlowModel: CaseIterable {
    case clearCache,
         preloadWebView,
         homeNativeWithoutPreload,
         homeNativeWithPreload,
         homeWebWithoutPreload,
         homeWebViewWithoutPreload,
         homeWebViewCustomHandler

    var title: String {
        switch self {
        case .clearCache:
            return "Clear Cache"
        case .preloadWebView:
            return "Preload Web View"
        case .homeNativeWithoutPreload:
            return "Native Home without Preload"
        case .homeNativeWithPreload:
            return "Native Home with Preload"
        case .homeWebWithoutPreload:
            return "Web Home without Preload"
        case .homeWebViewWithoutPreload:
            return "Web Home with Preload"
        case .homeWebViewCustomHandler:
            return "Web Home Local Resources"
        }
    }
}
