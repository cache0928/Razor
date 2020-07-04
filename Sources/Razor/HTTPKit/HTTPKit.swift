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

public enum TrustEvaluator {
    case `default`
    case pinnedCertificates(acceptSelfSignedCertificates: Bool = true, performDefaultValidation: Bool = true)
    case publicKeys(performDefaultValidation: Bool = true)
    case revocation(performDefaultValidation: Bool = true)
    case composite(evaluators: [TrustEvaluator])
        
    var evaluating: ServerTrustEvaluating {
        switch self {
        case .default:
            return DefaultTrustEvaluator()
        case .pinnedCertificates(let acceptSelfSignedCertificates,
                                 let performDefaultValidation):
            return PinnedCertificatesTrustEvaluator(
                acceptSelfSignedCertificates: acceptSelfSignedCertificates,
                performDefaultValidation: performDefaultValidation
            )
        case .revocation(let performDefaultValidation):
            return RevocationTrustEvaluator(performDefaultValidation: performDefaultValidation)
        case .publicKeys(let performDefaultValidation):
            return PublicKeysTrustEvaluator(performDefaultValidation: performDefaultValidation)
        case .composite(let evaluators):
            return CompositeTrustEvaluator(evaluators: evaluators.map {$0.evaluating})
        }
    }
}

public struct HTTPKit {
    static private(set) var serverAddress = ""   //新地址
    static private(set) var session: Session = Session.default
    
    
    public static func load(server: String,
                            timeoutIntervalForRequest: TimeInterval = 60,
                            hostTrusts: [String: TrustEvaluator]? = nil) {
        serverAddress = server
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = timeoutIntervalForRequest
        let serverTrustManager: ServerTrustManager?
        if let trusts = hostTrusts {
            let evaluators = trusts.mapValues { $0.evaluating }
            serverTrustManager = ServerTrustManager(evaluators: evaluators)
        } else {
            serverTrustManager = nil
        }
        session = Session(configuration: config,serverTrustManager: serverTrustManager)
    }
}

