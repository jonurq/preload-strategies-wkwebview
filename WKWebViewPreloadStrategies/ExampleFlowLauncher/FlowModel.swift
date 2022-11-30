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
         homeWebWithoutPreload,
         homeWebViewWithoutPreload,
         homeNativeWithoutPreload,
         homeNativeWithPreload,
         homeWebViewCustomHandler

    var title: String {
        switch self {
        case .clearCache:
            return "Clear Cache"
        case .preloadWebView:
            return "Preload Web View"
        case .homeWebWithoutPreload:
            return "Demo 1: Web Home without Preload"
        case .homeWebViewWithoutPreload:
            return "Demo 1: Web Home with Preload"
        case .homeNativeWithoutPreload:
            return "Demo 2: Native Home without Preload"
        case .homeNativeWithPreload:
            return "Demo 2: Native Home with Preload"
        case .homeWebViewCustomHandler:
            return "Bonus: Web Home Local Resources"
        }
    }
}
