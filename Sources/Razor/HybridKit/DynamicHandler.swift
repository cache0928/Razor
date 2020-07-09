//
//  DynamicHandler.swift
//  LonsidFLA
//
//  Created by 徐才超 on 2020/6/29.
//  Copyright © 2020 徐才超. All rights reserved.
//

import WebKit

public class DynamicMessage: NSObject {
    public let source: WKWebView
    fileprivate let call: Selector
    
    init(source: WKWebView, method: String) {
        self.source = source
        self.call = Selector(method + ":")
    }
}

public class DynamicPayloadMessage: DynamicMessage {
    private let payload: Any
    
    public func represent<T: Codable>(as target: T.Type) -> T? {
        do {
            let data = try JSONSerialization.data(withJSONObject: payload, options: .fragmentsAllowed)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            return nil
        }
    }
    
    init(source: WKWebView, method: String, payload: Any) {
        self.payload = payload
        super.init(source: source, method: method)
    }
}

open class DynamicHandler: AbstractHandler {
    open override func handle(message: WKScriptMessage) {
        guard
            let msg = convert(message: message),
            self.responds(to: msg.call) else {
            return
        }
        performSelector(onMainThread: msg.call, with: msg, waitUntilDone: true)
    }
    private func convert(message: WKScriptMessage) -> DynamicMessage? {
        guard let dic = message.body as? [String: Any],
              let method = dic["method"] as? String,
              let webView = message.webView else {
            return nil
        }
        if let params = dic["params"], !(params is NSNull) {
            return DynamicPayloadMessage(source: webView, method: method, payload: params)
        } else {
            return DynamicMessage(source: webView, method: method)
        }
    }
}
