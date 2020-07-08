//
//  NormalResponse.swift
//  AdTaxi
//
//  Created by 徐才超 on 2017/12/11.
//  Copyright © 2017年 温州电子信息研究院. All rights reserved.
//

import Foundation
import Alamofire

public typealias HTTPHeaders = Alamofire.HTTPHeaders
public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias DataDecoder = Alamofire.DataDecoder
public typealias HTTPError = Alamofire.AFError

public struct HTTPKit {
    static private(set) var serverAddress = ""
    static private(set) var session: Session = Session.default
    
    
    public static func load(server: String,
                            timeoutIntervalForRequest: TimeInterval = 60,
                            hostTrusts: [String: TrustTool]? = nil) {
        serverAddress = server
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = timeoutIntervalForRequest
        let serverTrustManager: ServerTrustManager?
        if let trusts = hostTrusts {
            let evaluators = trusts.mapValues { $0.evaluator }
            serverTrustManager = ServerTrustManager(evaluators: evaluators)
        } else {
            serverTrustManager = nil
        }
        session = Session(configuration: config,serverTrustManager: serverTrustManager)
    }
}

