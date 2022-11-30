//
//  CustomSchemeHandler.swift
//  WKWebViewPreloadStrategies
//
//  Created by Jonatán Ezequiel Urquiza Martinez on 28/11/2022.
//

import Foundation
import WebKit
import UniformTypeIdentifiers

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

