//
//  NetworkDownloader.swift
//  SwiftyNetwork
//
//  Created by 徐才超 on 2017/9/21.
//  Copyright © 2017年 徐才超. All rights reserved.
//

import Alamofire
import Foundation

public protocol ResumableDownloader: StoredDownloader {
    func cancel()
    func resume() -> Bool
}

fileprivate var taskKey: Void?
fileprivate var progressKey: Void?
fileprivate var completeKey: Void?

extension ResumableDownloader {
    fileprivate var task: DownloadRequest? {
        get { return getAssociatedObject(self, &taskKey) }
        set { setRetainedAssociatedObject(self, &taskKey, newValue) }
    }
    
    fileprivate var progress: ((Progress) -> ())? {
        get { return getAssociatedObject(self, &progressKey) }
        set { setRetainedAssociatedObject(self, &progressKey, newValue) }
    }
    
    fileprivate var complete: ((Result<URL, HTTPError>) ->())? {
        get { return getAssociatedObject(self, &completeKey) }
        set { setRetainedAssociatedObject(self, &completeKey, newValue) }
    }
    
    public mutating func download(request: Request,
                                  in queue: DispatchQueue = .main,
                                  when: ((Progress) -> ())? = nil,
                                  done: @escaping (Result<URL, HTTPError>) ->()) {
        progress = when
        complete = done
        task = defaultDownload(request: request, in: queue, when: when, done: done)
    }
    
    public func cancel() {
        guard let task = task else {
            return
        }
        task.cancel(producingResumeData: true)
    }
    
    public mutating func resume(in queue: DispatchQueue = .main) -> Bool {
        guard let resumeData = task?.resumeData else {
            return false
        }
        let when = self.progress
        let done = self.complete
        task = HTTPKit.session.download(resumingWith: resumeData, to: destination)
            .downloadProgress(queue: queue) { progress in when?(progress) }
            .response(queue: queue) { response in
                guard case let Result.success(url) = response.result,
                    let fileURL = url else {
                        guard let error = response.error else {
                            return
                        }
                        done?(.failure(error))
                        return
                }
                done?(.success(fileURL))
        }
        return true
    }
}


