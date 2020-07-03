//
//  Encodable+.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/1.
//

import Foundation

//extension Encodable {
//    public var rz: RazorWrapper<Self> {
//        return RazorWrapper(self)
//    }
//}

//extension RazorWrapper where Base: Encodable {
//    public var dictionary: [String: Any]? {
//        guard let data = try? SpecialJSONEncoder().encode(base) else { return nil }
//        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
//    }
//}
