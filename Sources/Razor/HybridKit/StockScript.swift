//
//  StockScript.swift
//  LonsidFLA
//
//  Created by 徐才超 on 2020/6/28.
//  Copyright © 2020 徐才超. All rights reserved.
//

import WebKit

public struct StockScript {
    public static var disableWebKitInteractive: WKUserScript = {
        let css = "body { -webkit-user-select:none;-webkit-user-drag:none; }"
        let js = """
                 var style = document.createElement('style');
                 style.type = 'text/css';
                 var cssContent = document.createTextNode('\(css)');
                 style.appendChild(cssContent);
                 document.body.appendChild(style);
                 document.documentElement.style.webkitTouchCallout='none';
                 """
        return WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }()
    
    public static var disableZoom: WKUserScript = {
        let js = """
                 var script = document.createElement('meta');
                 script.name = 'viewport';
                 script.content="width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no";
                 document.getElementsByTagName('head')[0].appendChild(script);
                 """
        return WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }()
}
