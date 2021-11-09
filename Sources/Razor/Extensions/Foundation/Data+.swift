//
//  Data+.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/30.
//

import Foundation
import CryptoKit


public enum HMACAlgorithm {
    case md5
    case sha1
    case sha256
    case sha384
    case sha512
}

public enum EncryptAlgorithm {
    case aes_gcm
    case chachapoly
}

extension Data: RazorCompatibleValue {}
extension RazorWrapper where Base == Data {
    public var md5Data: Base {
      return Data(Insecure.MD5.hash(data: base))
    }
    
    public var md5String: String {
        return md5Data.reduce("") {
            $0 + String(format:"%02x", $1)
        }
    }
    
    public var sha1Data: Base {
      return Data(Insecure.SHA1.hash(data: base))
    }
    
    public var sha1String: String {
        return sha1Data.reduce("") {
            $0 + String(format:"%02x", $1)
        }
    }
    
    public var sha256Data: Base {
      return Data(SHA256.hash(data: base))
    }
    
    public var sha256String: String {
        return sha256Data.reduce("") {
            $0 + String(format:"%02x", $1)
        }
    }
    
    public var sha384Data: Base {
      return Data(SHA384.hash(data: base))

    }
    
    public var sha384String: String {
        return sha384Data.reduce("") {
            $0 + String(format:"%02x", $1)
        }
    }
    
    public var sha512Data: Base {
      return Data(SHA512.hash(data: base))
    }
    
    public var sha512String: String {
        return sha512Data.reduce("") {
            $0 + String(format:"%02x", $1)
        }
    }
    
    public func hmacData(key: Data, using algorithm: HMACAlgorithm) -> Base {
      let key = SymmetricKey(data: key)
      switch algorithm {
      case .md5:
          return Data(HMAC<Insecure.MD5>.authenticationCode(for: base, using: key))
      case .sha1:
          return Data(HMAC<Insecure.SHA1>.authenticationCode(for: base, using: key))
      case .sha256:
          return Data(HMAC<SHA256>.authenticationCode(for: base, using: key))
      case .sha384:
          return Data(HMAC<SHA384>.authenticationCode(for: base, using: key))
      case .sha512:
          return Data(HMAC<SHA512>.authenticationCode(for: base, using: key))
      }
    }
    
    public func hmacString(key: Data, using algorithm: HMACAlgorithm) -> String {
        return hmacData(key: key, using: algorithm).reduce("") {
            $0 + String(format:"%02x", $1)
        }
    }
    
    @available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *)
    public func encryptWith(key: Data, using algorithm: EncryptAlgorithm) -> Result<Data, Error> {
        let key = SymmetricKey(data: key)
        do {
            let data: Data?
            switch algorithm {
            case .aes_gcm:
                data = try AES.GCM.seal(base, using: key).combined
            case .chachapoly:
                data = try ChaChaPoly.seal(base, using: key).combined
            }
            return .success(data!)
        } catch {
            return .failure(error)
        }
    }
    
    public func decryptWith(key: Data, using algorithm: EncryptAlgorithm) -> Result<Data, Error> {
        let key = SymmetricKey(data: key)
        do {
            let data: Data?
            switch algorithm {
            case .aes_gcm:
                let sealedBox = try AES.GCM.SealedBox(combined: base)
                data = try AES.GCM.open(sealedBox, using: key)
            case .chachapoly:
                let sealedBox = try ChaChaPoly.SealedBox(combined: base)
                data = try ChaChaPoly.open(sealedBox, using: key)
            }
            return .success(data!)
        } catch {
            return .failure(error)
        }
    }
    
    public var hexString: String {
        return base.reduce("") {
            $0 + String(format:"%02x", $1)
        }
    }
    
    public var utf8String: String? {
        return String(data: base, encoding: .utf8)
    }
    
    public static func from(hexString: String) -> Base? {
        guard hexString.count.isMultiple(of: 2) else {
            return nil
        }
        let len = hexString.count / 2
        var data = Data(capacity: len)
        for i in 0 ..< len {
            let j = hexString.index(hexString.startIndex, offsetBy: i * 2)
            let k = hexString.index(j, offsetBy: 2)
            let bytes = hexString[j ..< k]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        return data
    }
}






