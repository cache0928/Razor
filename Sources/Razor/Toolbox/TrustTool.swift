//
//  TrustTool.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/4.
//

import Foundation
import Alamofire

public enum TrustTool {
    case `default`
    case pinnedCertificates(acceptSelfSignedCertificates: Bool = true, performDefaultValidation: Bool = true)
    case publicKeys(performDefaultValidation: Bool = true)
    case revocation(performDefaultValidation: Bool = true)
    case composite(evaluators: [TrustTool])
        
    var evaluator: ServerTrustEvaluating {
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
            return CompositeTrustEvaluator(evaluators: evaluators.map {$0.evaluator})
        }
    }
    
    public static func getP12Credential(location: URL, password: String? = nil) -> URLCredential? {
        var securityError: OSStatus = errSecSuccess
        let p12Data: Data
        do {
            p12Data = try Data(contentsOf: location)
        } catch {
            return nil
        }
        var options: [CFString: Any] = [:]
        if let password = password {
            options[kSecImportExportPassphrase] = password // 客户端证书口令
        }
        var items: CFArray?
        securityError = SecPKCS12Import(p12Data as CFData, options as CFDictionary, &items)
        guard securityError == errSecSuccess,
              let itemArray = items as? [CFDictionary],
              let entry = itemArray.first as? [CFString: Any]  else {
            return nil
        }
        let secIdentityRef = entry[kSecImportItemIdentity] as! SecIdentity
//        let trustRef = entry[kSecImportItemTrust] as! SecTrust
        let chainPointer = entry[kSecImportItemCertChain] as! [Any]
        return URLCredential(identity: secIdentityRef,
                             certificates: chainPointer,
                             persistence: URLCredential.Persistence.forSession)
    }
}
