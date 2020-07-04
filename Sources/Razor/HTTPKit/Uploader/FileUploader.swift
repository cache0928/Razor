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
        HTTPKit.session.upload(data, to: target,
                  method: method,
                  headers: headers)
            .uploadProgress { (progress) in when?(progress) }
            .responseDecodable(of: Response.self, queue: queue, decoder: decoder) { response in
                switch response.result {
                case .success(let base):
                    done(base.result)
                case .failure(let error):
                    done(.failure(error))
                }
        }
    }
}
