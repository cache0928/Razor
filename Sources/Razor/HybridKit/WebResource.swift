//
//  HybridResource.swift
//  LonsidFLA
//
//  Created by 徐才超 on 2020/6/28.
//  Copyright © 2020 徐才超. All rights reserved.
//

import WebKit

public protocol WebResource {
    func load(to webView: WKWebView)
}

public struct LocalResource: WebResource {
    private let bundle: String
    // (文件名, 路由点)
    private let entry: (String, String)
    
    public init(resourceBundle: String, entryPoint: (String, String)) {
        self.bundle = resourceBundle
        self.entry = entryPoint
    }
    
    public func load(to webView: WKWebView) {
        let localResourcePackageURL = Bundle.main.url(forResource: bundle, withExtension: nil)!
        let indexPath = localResourcePackageURL.appendingPathComponent(entry.0).absoluteString + entry.1
        let indexURL = URL(string: indexPath)!
        webView.loadFileURL(indexURL, allowingReadAccessTo: localResourcePackageURL)
    }
}

public struct HostResource: WebResource {
    private let resourceURL: URL
    public init(resourceURL: URL) {
        self.resourceURL = resourceURL
    }
    public func load(to webView: WKWebView) {
        webView.load(URLRequest(url: resourceURL))
    }
}
