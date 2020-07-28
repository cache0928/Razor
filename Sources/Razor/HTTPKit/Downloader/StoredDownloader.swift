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
    
    public func download(request: Request, in queue: DispatchQueue, when: ((Progress) -> ())?, done: @escaping (Result<URL, HTTPError>) ->()) {
        defaultDownload(request: request, in: queue, when: when, done: done)
    }
    
    @discardableResult
    func defaultDownload(request: Request,
                         in queue: DispatchQueue,
                         when: ((Progress) -> ())?,
                         done: @escaping (Result<URL, HTTPError>) ->()) -> DownloadRequest {
        let target: String
        if path.hasPrefix("https://") || path.hasPrefix("http://") {
            target = path
        } else {
            target = HTTPKit.serverAddress + path
        }
        let dataReq: DownloadRequest
        switch authentication {
        case .basic(let username, let password, let persistence):
            dataReq = HTTPKit.session.download(target,
                                               method: method,
                                               parameters: request.parameters,
                                               encoder: request.encoder,
                                               headers: headers,
                                               to: destination).authenticate(username: username, password: password, persistence: persistence)
        case .header(let header):
            var authHeaders = headers
            authHeaders.add(header)
            dataReq = HTTPKit.session.download(target,
                                               method: method,
                                               parameters: request.parameters,
                                               encoder: request.encoder,
                                               headers: authHeaders,
                                               to: destination)
        case .clientCertificate(let fileURL, let password):
            guard let credential = TrustTool.getP12Credential(location: fileURL, password: password) else {
                fallthrough
            }
            dataReq = HTTPKit.session.download(target,
                                               method: method,
                                               parameters: request.parameters,
                                               encoder: request.encoder,
                                               headers: headers,
                                               to: destination).authenticate(with: credential)
        default:
            dataReq = HTTPKit.session.download(target,
                                               method: method,
                                               parameters: request.parameters,
                                               encoder: request.encoder,
                                               headers: headers,
                                               to: destination)
        }
        return dataReq.downloadProgress(queue: queue) { progress in when?(progress) }.response(queue: queue) { response in
            guard case let Result.success(url) = response.result,
                let fileURL = url else {
                    guard let error = response.error else {
                        return
                    }
                    done(.failure(error))
                    return
            }
            done(.success(fileURL))
        }
    }
}

extension StoredDownloader where Request.Payload == Empty {
    public func download(in queue: DispatchQueue = .main,
                         when: ((Progress) -> ())? = nil,
                         done: @escaping (Result<URL, HTTPError>) ->()) {
        self.download(request: Request.empty, in: queue, when: when, done: done)
    }
}
