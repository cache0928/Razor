//
//  UIApplication+.swift
//  Razor
//
//  Created by 徐才超 on 2020/8/1.
//

#if canImport(UIKit)
import UIKit

extension UIApplication: RazorCompatible {}
extension RazorWrapper where Base: UIApplication {
    public var appBundleName: String {
        return Bundle.main.infoDictionary?["CFBundleName"] as! String
    }
    
    public var appBundleID: String {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as! String
    }
    
    public var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    public var appBuildVersion: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
    
    public var documentsURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }
    
    public var documentPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    
    public var cachesURL: URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last!
    }
    
    public var cachesPath: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    }
    
    public var libraryURL: URL {
        return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last!
    }
    
    public var libraryPath: String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
    }
}
#endif
