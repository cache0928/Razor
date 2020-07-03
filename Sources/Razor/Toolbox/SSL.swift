//
//  SSLUtil.swift
//  SwiftyNetwork
//
//  Created by 徐才超 on 2017/9/21.
//  Copyright © 2017年 徐才超. All rights reserved.
//

import Foundation

fileprivate let serverCertPath = Bundle.main.url(forResource: "app_client", withExtension: "cer")
fileprivate let clientCertPath = Bundle.main.url(forResource: "app_client", withExtension: "p12")

struct CertificateUtil {
    
    static func anwser(challenge: URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        // 认证服务器证书
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            var disposition: URLSession.AuthChallengeDisposition = URLSession.AuthChallengeDisposition.performDefaultHandling
            var credential: URLCredential? = nil
            // 获取服务器的trust object
            let serverTrust: SecTrust = challenge.protectionSpace.serverTrust!
            if self.verifySelfSignedSSLCertificateTrust(serverTrust) {
                // 认证成功
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: serverTrust)
            } else {
                disposition = URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge
            }
            // 回调凭证，传递给服务器
            return (disposition, credential)
        } else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
            // 客户端证书认证
            // 获取客户端证书相关信息
            let identityAndTrust: IdentityAndTrust = self.extractIdentity()
            let urlCredential: URLCredential = URLCredential(identity: identityAndTrust.identityRef, certificates: identityAndTrust.certArray as? [AnyObject], persistence: URLCredential.Persistence.forSession)
            return (.useCredential, urlCredential)
        } else {
            return (.cancelAuthenticationChallenge, nil)
        }
    }
    
    /// 检查证书
    ///
    /// - Parameter serverTrust: 服务端信任凭证
    /// - Returns: 证书链验证结果是否通过
    static func verifySelfSignedSSLCertificateTrust(_ serverTrust: SecTrust) -> Bool {
        var err: OSStatus
        var trustResult: SecTrustResultType = .invalid
        // 导入本地的服务端证书
        if let cerPath = serverCertPath {
            let data = try! Data(contentsOf: cerPath)
            let policy = SecPolicyCreateBasicX509()
            SecTrustSetPolicies(serverTrust, policy)
            let certificate = SecCertificateCreateWithData(nil, data as CFData)
            let trustedCertArr = [certificate!]
            // 将读取的证书设置为serverTrust的根证书
            err = SecTrustSetAnchorCertificates(serverTrust, trustedCertArr as CFArray)
            SecTrustSetAnchorCertificatesOnly(serverTrust, true)
            if (err == noErr) {
                // 通过本地导入的证书来验证服务器的证书是否可信
                err = SecTrustEvaluate(serverTrust, &trustResult)
            }
        } else {
            err = SecTrustEvaluate(serverTrust, &trustResult)
        }
        if (err == errSecSuccess && (trustResult == .proceed || trustResult == .unspecified)) {
            //认证成功，则创建一个凭证返回给服务器
            return true
        } else {
            //            let errors = SecTrustCopyProperties(serverTrust)
            //            print(errors)
            return false
        }
    }
    
    // 定义一个结构体，存储认证相关信息
    private struct IdentityAndTrust {
        var identityRef: SecIdentity
        var trust: SecTrust
        var certArray: AnyObject
    }
    
    // 获取客户端证书
    private static func extractIdentity() -> IdentityAndTrust {
        var identityAndTrust: IdentityAndTrust!
        var securityError: OSStatus = errSecSuccess
        if let cerPath = clientCertPath {
            let PKCS12Data = try! Data(contentsOf: cerPath)
            let options = [kSecImportExportPassphrase: "123456"] //客户端证书密码
            var items: CFArray?
            securityError = SecPKCS12Import(PKCS12Data as CFData, options as CFDictionary, &items)
            if securityError == errSecSuccess {
                let certItemsArray: Array = items as! [[String: AnyObject]]
                if let certEntry = certItemsArray.first {
                    // identity
                    let secIdentityRef: SecIdentity = certEntry["identity"] as! SecIdentity
                    // trust
                    let trustRef: SecTrust = certEntry["trust"] as! SecTrust
                    // cert
                    let chainPointer: AnyObject = certEntry["chain"]!
                    
                    identityAndTrust = IdentityAndTrust(identityRef: secIdentityRef, trust: trustRef, certArray:  chainPointer)
                }
            }
        }
        return identityAndTrust
    }
}
