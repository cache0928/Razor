//
//  HTTPDownloader.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/3.
//

import Alamofire
import Foundation

public protocol HTTPDownloader: HTTPNetwork {
    /// 下载路径配置
    ///
    /// **示例**
    ///
    ///     let destination: DownloadRequest.Destination = { _, _ in
    ///         let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    ///         let fileURL = documentsURL.appendingPathComponent("image.png")
    ///         return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
    ///     }
    ///
    ///
    var destination: DownloadRequest.Destination { get }
    func download(request: Request, in queue: DispatchQueue, when: ((Progress) -> ())?, done: @escaping (Result<URL, HTTPError>) ->())
}

extension HTTPDownloader {
    public var method: HTTPMethod { return .get }
}
