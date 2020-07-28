//
//  NetworkResource.swift
//  SwiftyNetwork
//
//  Created by 徐才超 on 2017/9/21.
//  Copyright © 2017年 徐才超. All rights reserved.
//

import Alamofire
import Foundation

public protocol DecodableLoader: HTTPLoader {    
    var decoder: DataDecoder { get }
}

extension DecodableLoader {
    public var decoder: DataDecoder {
        return JSONDecoder()
    }
}

extension DecodableLoader {
    public func load(request: Request,
                     in queue: DispatchQueue = .main,
                     callback: @escaping (Result<Response.Payload, HTTPError>) -> ()) {
        let target: String
        if path.hasPrefix("https://") || path.hasPrefix("http://") {
            target = path
        } else {
            target = HTTPKit.serverAddress + path
        }
        let dataReq: DataRequest
        switch authentication {
        case .basic(let username, let password, let persistence):
            dataReq = HTTPKit.session.request(target,
                                              method: method,
                                              parameters: request.parameters,
                                              encoder: request.encoder,
                                              headers: headers).authenticate(username: username, password: password, persistence: persistence)
        case .header(let header):
            var authHeaders = headers
            authHeaders.add(header)
            dataReq = HTTPKit.session.request(target,
                                              method: method,
                                              parameters: request.parameters,
                                              encoder: request.encoder,
                                              headers: authHeaders)
        case .clientCertificate(let fileURL, let password):
            guard let credential = TrustTool.getP12Credential(location: fileURL, password: password) else {
                fallthrough
            }
            dataReq = HTTPKit.session.request(target,
                                              method: method,
                                              parameters: request.parameters,
                                              encoder: request.encoder,
                                              headers: headers).authenticate(with: credential)
        default:
            dataReq = HTTPKit.session.request(target,
                                              method: method,
                                              parameters: request.parameters,
                                              encoder: request.encoder,
                                              headers: headers)
        }

        dataReq.responseDecodable(of: Response.self, queue: queue, decoder: decoder) { response in
            switch response.result {
            case .success(let base):
                callback(base.result)
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
}

extension DecodableLoader where Request.Payload == Empty {
    public func load(in queue: DispatchQueue = .main,
                     callback: @escaping (Result<Response.Payload, HTTPError>) -> ()) {
        self.load(request: Request.empty, in: queue, callback: callback)
    }
}

