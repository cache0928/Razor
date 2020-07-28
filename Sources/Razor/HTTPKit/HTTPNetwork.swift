//
//  HTTPNetwork.swift
//  SwiftyNetwork
//
//  Created by 徐才超 on 2017/9/21.
//  Copyright © 2017年 徐才超. All rights reserved.
//

import Alamofire
import Foundation

public protocol HTTPNetwork {
    associatedtype Request: HTTPRequest

    var authentication: HTTPAuthentication { get }
    var headers: HTTPHeaders { get }
    var method: HTTPMethod { get }
    var path: String { get }
}

public enum HTTPAuthentication {
    case none
    case basic(username: String, password: String, persistence: URLCredential.Persistence = .forSession)
    case header(_ header: HTTPHeader)
    case clientCertificate(p12File: URL, password: String? = nil)
}

extension HTTPNetwork {
    public var authentication: HTTPAuthentication {
        return .none
    }
}

public struct Empty: Codable {
    private init() {}
    static let empty = Empty()
    
    public init(from decoder: Decoder) throws {}
    public func encode(to encoder: Encoder) throws {}
}

