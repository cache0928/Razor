//
//  DispatchQueue+.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/1.
//

import Foundation

fileprivate var _onceTracker: [String] = []


extension DispatchQueue: RazorCompatible {}
extension RazorWrapper where Base: DispatchQueue {
    public static func once(token: String, block: () -> Void) {
        objc_sync_enter(Base.self)
        defer { objc_sync_exit(Base.self) }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}
