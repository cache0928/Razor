//
//  StringLoader.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/2.
//

import Alamofire
import Foundation

extension String: HTTPResponse {
    public typealias Payload = Self
    public var result: Result<String, AFError> {
        return .success(self)
    }
}

public protocol StringLoader: HTTPLoader {
    associatedtype Response = String
    var encoding: String.Encoding { get}
}

extension StringLoader {
    public var encoding: String.Encoding {
        return .utf8
    }
}

extension StringLoader {
    public func load(request: Request, in queue: DispatchQueue = .main, callback: @escaping (Result<String, HTTPError>) -> ()) {
        let target: String
        if path.hasPrefix("https://") || path.hasPrefix("http://") {
            target = path
        } else {
            target = HTTPKit.serverAddress + path
        }
        HTTPKit.session.request(target,
                   method: method,
                   parameters: request.parameters,
                   encoder: request.encoder,
                   headers: headers)
            .responseString(queue: queue, encoding: encoding) { (response) in
                switch response.result {
                case .success(let str):
                    callback(.success(str))
                case .failure(let error):
                    callback(.failure(error))
                }
        }
    }
}

extension StringLoader where Request.Payload == Empty {
    public func load(in queue: DispatchQueue = .main, callback: @escaping (Result<String, HTTPError>) -> ()) {
        self.load(request: Request.empty, in: queue, callback: callback)
    }
}
