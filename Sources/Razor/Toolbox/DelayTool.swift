//
//  DelayTool.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/1.
//

import Foundation

public typealias DelayTask = (_ cancel : Bool) -> Void

@discardableResult
public func delay(_ time: TimeInterval, task: @escaping () -> ()) -> DelayTask? {
    func dispatch_later(block: @escaping () -> ()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    
    var closure: (() -> Void)? = task
    var result: DelayTask?
    
    let delayedClosure: DelayTask = {
        cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    return result
}

public func cancel(_ task: DelayTask?) {
    task?(true)
}
