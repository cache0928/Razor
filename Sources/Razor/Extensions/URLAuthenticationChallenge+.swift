//
//  URLAuthenticationChallenge+.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/8.
//

import Foundation

extension URLAuthenticationChallenge: RazorCompatible {}
extension RazorWrapper where Base: URLAuthenticationChallenge {
    public func evaluate(by tool: TrustTool,
                         present credential: URLCredential? = nil) -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        switch base.protectionSpace.authenticationMethod {
        case NSURLAuthenticationMethodServerTrust:
            let host = base.protectionSpace.host
            guard let trust = base.protectionSpace.serverTrust else {
                return (.performDefaultHandling, nil)
            }
            do {
                try tool.evaluator.evaluate(trust, forHost: host)
                return (.useCredential, URLCredential(trust: trust))
            } catch {
                return (.cancelAuthenticationChallenge, nil)
            }
        case NSURLAuthenticationMethodHTTPBasic,
             NSURLAuthenticationMethodHTTPDigest,
             NSURLAuthenticationMethodNTLM,
             NSURLAuthenticationMethodNegotiate,
             NSURLAuthenticationMethodClientCertificate:
            guard base.previousFailureCount == 0 else {
                return (.rejectProtectionSpace, nil)
            }
            guard let credential = credential else {
                return (.performDefaultHandling, nil)
            }
            return (.useCredential, credential)
        default:
            return (.performDefaultHandling, nil)
        }
        
    }
}
