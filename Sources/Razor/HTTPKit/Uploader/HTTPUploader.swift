//
//  HTTPUploader.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/3.
//

import Alamofire
import Foundation

public protocol HTTPUpLoader: HTTPNetwork {
    associatedtype Request = EmptyRequest
    associatedtype Response: HTTPResponse
    var decoder: DataDecoder { get }
    func upload(in queue: DispatchQueue, when: ((Progress) -> ())?, done: @escaping (Result<Response.Payload, Error>) -> ())
}

extension HTTPUpLoader {
    public var decoder: DataDecoder {
        return JSONDecoder()
    }
}
