//
//  HybridHandler.swift
//  LonsidFLA
//
//  Created by 徐才超 on 2020/6/28.
//  Copyright © 2020 徐才超. All rights reserved.
//

import WebKit

public protocol WebMessageHandler: class, WKScriptMessageHandler {
    var name: String { get }
    func handle(message: WKScriptMessage)
}

open class AbstractHandler: NSObject, WebMessageHandler {
    public let name: String
    
    public init(name: String) {
        self.name = name
        super.init()
    }
    
    open func handle(message: WKScriptMessage) {
        fatalError("must override this method")
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == name else {
            return
        }
        handle(message: message)
    }
}
