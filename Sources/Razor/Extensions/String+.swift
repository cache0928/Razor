//
//  String+.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/8.
//

import Foundation

extension String: RazorCompatibleValue {}
extension RazorWrapper where Base == String {
    func versionCompare(with version: String) -> ComparisonResult {
        return base.compare(version, options: .numeric, range: nil, locale: nil)
    }
    
    public func versionNewer(than aVersionString: String) -> Bool {
        return versionCompare(with: aVersionString) == .orderedDescending
    }
    
    public func versionOlder(than aVersionString: String) -> Bool {
        return versionCompare(with: aVersionString) == .orderedAscending
    }
    
    public func versionSame(to aVersionString: String) -> Bool {
        return versionCompare(with: aVersionString) == .orderedSame
    }
}

