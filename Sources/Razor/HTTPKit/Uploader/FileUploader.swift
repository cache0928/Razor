//
//  FileUploader.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/3.
//

import Alamofire
import Foundation

public protocol FileUploader: HTTPUpLoader {
    var data: Data { get }
}

extension FileUploader {
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
            dataReq = HTTPKit.session.upload(data, to: target,
                                             method: method,
                                             headers: headers).authenticate(username: username, password: password, persistence: persistence)
        case .header(let header):
            var authHeaders = headers
            authHeaders.add(header)
            dataReq = HTTPKit.session.upload(data, to: target,
                                             method: method,
                                             headers: authHeaders)
        case .clientCertificate(let fileURL, let password):
            guard let credential = TrustTool.getP12Credential(location: fileURL, password: password) else {
                fallthrough
            }
            dataReq = HTTPKit.session.upload(data, to: target,
                                             method: method,
                                             headers: headers).authenticate(with: credential)
        default:
            dataReq = HTTPKit.session.upload(data, to: target,
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
