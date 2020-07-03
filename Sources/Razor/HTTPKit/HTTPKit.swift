//
//  NormalResponse.swift
//  AdTaxi
//
//  Created by 徐才超 on 2017/12/11.
//  Copyright © 2017年 温州电子信息研究院. All rights reserved.
//

import Foundation
import Alamofire

public struct Empty: Codable {
    private init() {}
    static let empty = Empty()
    
    public init(from decoder: Decoder) throws {}
    public func encode(to encoder: Encoder) throws {}
}

struct HTTPKit {
    static let serverAddress = "http://112.124.15.71"   //新地址
    static let manager: Session = {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 60
        let manager = Session(configuration: config)
//        manager.delegate.taskDidReceiveChallenge = HTTPNetworkManager.https
        return manager
    }()
}

