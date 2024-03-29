//
//  NetworkUploader.swift
//  SwiftyNetwork
//
//  Created by 徐才超 on 2017/9/21.
//  Copyright © 2017年 徐才超. All rights reserved.
//

import Alamofire
import Foundation

public struct MultipartFormEnty {
    public let name: String
    public let data: Data
    public let fileName: String?
    public let mimeType: String?
    
    public init(name: String, data: Data, fileName: String? = nil, mimeType: String? = nil) {
        self.name = name
        self.data = data
        self.fileName = fileName
        self.mimeType = mimeType
    }
}

public protocol MultipartFormUploader: HTTPUpLoader {
    var entries: [MultipartFormEnty] { get }
    func build(multipartFormData: MultipartFormData)
}

extension MultipartFormUploader {
    public func build(multipartFormData: MultipartFormData) {
        for entry in entries {
            multipartFormData.append(entry.data, withName: entry.name, fileName: entry.fileName, mimeType: entry.mimeType)
        }
    }
    
    public func upload(in queue: DispatchQueue = .main, when: ((Progress) -> ())? = nil, done: @escaping (Result<Response.Payload, HTTPError>) -> ()) {
        let target: String
        if path.hasPrefix("https://") || path.hasPrefix("http://") {
            target = path
        } else {
            target = HTTPKit.serverAddress + path
        }
        let dataReq: UploadRequest
        switch authentication {
        case .basic(let username, let password, let persistence):
            dataReq = HTTPKit.session.upload(multipartFormData: build,
                                             to: target,
                                             method: method,
                                             headers: headers).authenticate(username: username, password: password, persistence: persistence)
        case .header(let header):
            var authHeaders = headers
            authHeaders.add(header)
            dataReq = HTTPKit.session.upload(multipartFormData: build,
                                             to: target,
                                             method: method,
                                             headers: authHeaders)
        case .clientCertificate(let fileURL, let password):
            guard let credential = TrustTool.getP12Credential(location: fileURL, password: password) else {
                fallthrough
            }
            dataReq = HTTPKit.session.upload(multipartFormData: build,
                                             to: target,
                                             method: method,
                                             headers: headers).authenticate(with: credential)
        default:
            dataReq = HTTPKit.session.upload(multipartFormData: build,
                                             to: target,
                                             method: method,
                                             headers: headers)
        }
        dataReq.uploadProgress { (progress) in when?(progress) }.responseDecodable(of: Response.self, queue: queue, decoder: decoder) { response in
                switch response.result {
                case .success(let base):
                    done(base.result)
                case .failure(let error):
                    done(.failure(error))
                }
        }
    }
}
