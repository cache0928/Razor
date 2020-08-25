//
//  HybridKit.swift
//  LonsidFLA
//
//  Created by 徐才超 on 2020/6/28.
//  Copyright © 2020 徐才超. All rights reserved.
//

import WebKit
import Alamofire

#if os(iOS)
import UIKit
#endif

public enum UserAgent {
    case replace(value: String)
    case append(suffix: String)
}

open class HybridKit {
    public let webView: WKWebView!
    private let resource: WebResource
    private let manager = NetworkReachabilityManager(host: "https://www.apple.com.cn")!
    
    required public init(handlers: [WebMessageHandler],
                  resource: WebResource,
                  injections: [WKUserScript] = [],
                  userAgent: UserAgent? = nil) {
        self.resource = resource
        
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        for handler in handlers {        
            userContentController.add(handler, name: handler.name)
        }
        for script in injections {
            userContentController.addUserScript(script)
        }
        config.userContentController = userContentController
        self.webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        if let userAgent = userAgent {
            modify(userAgent: userAgent)
        }
    }
    
    private func load() {
        resource.load(to: webView)
    }
    
    private func modify(userAgent: UserAgent) {
        switch userAgent {
        case .replace(let value):
            webView.customUserAgent = value
        case .append(let suffix):
            // 因为WKWebView在执行js之后就不能再修改useragent，所以弄一个临时的webView来专门获取useragent
            let tempWebView: WKWebView = WKWebView()
            tempWebView.evaluateJavaScript("navigator.userAgent") { [unowned self] (result, error) in
                if let userAgent = result as? String {
                    let newAgent = userAgent + suffix
                    self.webView.customUserAgent = newAgent
                }
            }
        }
    }
    
    #if os(iOS)
    public func fullRender(in view: UIView, navigationDelegate: WKNavigationDelegate) {
        view.insertSubview(webView, at: 0)
        let cons = [
            webView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            webView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            webView.widthAnchor.constraint(equalTo: view.widthAnchor),
            webView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ]
        view.addConstraints(cons)
        webView.navigationDelegate = navigationDelegate
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        
        manager.startListening { [unowned self] status in
            switch status {
            case .reachable(_):
                self.manager.stopListening()
                self.load()
            default:
                break
            }
        }        
    }
    #endif

}
