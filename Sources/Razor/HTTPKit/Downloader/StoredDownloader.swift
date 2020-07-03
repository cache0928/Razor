//
//  HTTPDownloader.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/3.
//

import Alamofire
import Foundation

public protocol StoredDownloader: HTTPDownloader {}

extension StoredDownloader {
    public var destination: DownloadRequest.Destination {
        return DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
    }
    
    public func download(request: Request, in queue: DispatchQueue, when: ((Progress) -> ())?, done: @escaping (Result<URL, Error>) ->()) {
        defaultDownload(request: request, in: queue, when: when, done: done)
    }
    
    @discardableResult
    func defaultDownload(request: Request,
                         in queue: DispatchQueue,
                         when: ((Progress) -> ())?,
                         done: @escaping (Result<URL, Error>) ->()) -> DownloadRequest {
        let target: String
        if path.hasPrefix("https://") || path.hasPrefix("http://") {
            target = path
        } else {
            target = HTTPKit.serverAddress + path
        }
        return AF.download(target,
                    method: method,
                    parameters: request.parameters,
                    encoder: request.encoder,
                    headers: headers,
                    to: destination)
            .downloadProgress(queue: queue) { progress in when?(progress) }
            .response(queue: queue) { response in
                guard case let Result.success(url) = response.result,
                    let fileURL = url else {
                        // TODO: 转换Error类型
                        fatalError()
                }
                done(.success(fileURL))
        }
    }
}

extension StoredDownloader where Request.Payload == Empty {
    public func download(in queue: DispatchQueue = .main,
                         when: ((Progress) -> ())? = nil,
                         done: @escaping (Result<URL, Error>) ->()) {
        self.download(request: Request.empty, in: queue, when: when, done: done)
    }
}
