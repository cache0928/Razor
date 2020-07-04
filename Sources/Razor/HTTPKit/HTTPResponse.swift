//
//  HTTPResponse.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/2.
//

import Foundation
import Alamofire

public protocol HTTPResponse: Decodable {
    associatedtype Payload: Decodable
    var result: Result<Payload, AFError> { get }
}

extension HTTPResponse where Payload == Empty {
    var result: Result<Payload, Error> {
        return .success(Empty.empty)
    }
}
