//
//  RegexTool.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/1.
//

import Foundation

fileprivate struct RegexHelper {
    
    let regex: NSRegularExpression
    
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(_ input: String) -> Bool {
        let matches = regex.matches(in: input, options: [], range: NSMakeRange(0, input.utf16.count))
        return matches.count > 0
        
    }
    
}

precedencegroup MatchPrecedence {
    associativity: none
    higherThan: DefaultPrecedence
}

infix operator =~: MatchPrecedence

public func =~(lhs: String, rhs: String) -> Bool {
    
    do {
        return try RegexHelper(rhs).match(lhs)
    } catch _ {
        return false
    }
    
}
