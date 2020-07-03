//
//  HTTPLoader.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/3.
//

import Foundation

public protocol HTTPLoader: HTTPNetwork {
    associatedtype Response: HTTPResponse
    func load(request: Request, in queue: DispatchQueue, callback: @escaping (Result<Response.Payload, Error>) -> ())
}
