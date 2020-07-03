//
//  HTTPRequest.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/2.
//

import Alamofire
import Foundation

public protocol HTTPRequest {
    associatedtype Payload: Encodable
    var parameters: Payload { get }
    var encoder: ParameterEncoder { get }
    init(parameters: Payload, encoder: ParameterEncoder)
}

public struct ParametersRequest<T: Encodable>: HTTPRequest {
    public let parameters: T
    public let encoder: ParameterEncoder
    
    public init(parameters: T, encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default) {
        self.parameters = parameters
        self.encoder = encoder
    }
}

public typealias EmptyRequest = ParametersRequest<Empty>

extension HTTPRequest where Payload == Empty {
    static var empty: Self {
        return Self.init(parameters: Empty.empty, encoder: URLEncodedFormParameterEncoder.default)
    }
}
