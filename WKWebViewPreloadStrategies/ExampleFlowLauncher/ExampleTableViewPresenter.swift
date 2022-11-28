//
//  ExampleTableViewPresenter.swift
//  WKWebViewPreloadStrategies
//
//  Created by Jonatán Ezequiel Urquiza Martinez on 27/11/2022.
//

import Foundation
import UIKit

protocol ExampleTableViewDelegate: AnyObject {
    func pushViewController(vc: UIViewController)
}

class ExampleTableViewPresenter {
    weak var delegate: ExampleTableViewDelegate?

    let rows: [FlowModel] = FlowModel.allCases

    func didSelectRow(_ flow: FlowModel) {
        switch flow {
        case .clearCache:
            CacheCleaner.clean()
        case .preloadWebView:
            WebViewPreloader.shared.preload()
        case .homeNativeWithoutPreload:
            let vc = HomeViewController()
            delegate?.pushViewController(vc: vc)
        case .homeNativeWithPreload:
            let vc = HomeViewController()
            vc.shouldPreload = true
            delegate?.pushViewController(vc: vc)
        case .homeWebWithoutPreload:
            let vc = WebViewViewController(url: URLConfig.homeURL, customHandler: true)
            delegate?.pushViewController(vc: vc)
        case .homeWebViewWithoutPreload:
            let vc = WebViewViewController(url: URLConfig.homePreloadURL, customHandler: true)
            delegate?.pushViewController(vc: vc)
        case .homeWebViewCustomHandler:
            let vc = WebViewViewController(url: URLConfig.homeLocalURL, customHandler: true)
            delegate?.pushViewController(vc: vc)
        }
    }
}
