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
    public func upload(in queue: DispatchQueue = .main, when: ((Progress) -> ())? = nil, done: @escaping (Result<Response.Payload, Error>) -> ()) {
        let target: String
        if path.hasPrefix("https://") || path.hasPrefix("http://") {
            target = path
        } else {
            target = HTTPKit.serverAddress + path
        }
        AF.upload(data, to: target,
                  method: method,
                  headers: headers)
            .uploadProgress { (progress) in when?(progress) }
            .responseDecodable(of: Response.self, queue: queue, decoder: decoder) { response in
                switch response.result {
                case .success(let base):
                    done(base.result)
                case .failure(let error):
                    // TODO: 转换Error类型
                    done(.failure(error))
                }
        }
    }
}
