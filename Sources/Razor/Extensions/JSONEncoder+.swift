//
//  JSONEncoder+.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/1.
//

import Foundation


extension JSONEncoder: RazorCompatible {}
extension RazorWrapper where Base: JSONEncoder {
    public func customize(dateFormat: String) -> Base {
        let customDateHandler: (Date, Encoder) throws -> Void = { date, encoder in
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            let dateStr = formatter.string(from: date)
            try dateStr.encode(to: encoder)
        }
        base.dateEncodingStrategy = JSONEncoder.DateEncodingStrategy.custom(customDateHandler)
        return base
    }
}

extension JSONDecoder: RazorCompatible {}
extension RazorWrapper where Base: JSONDecoder {
    public func customize(dateFormat: String) -> Base {
        let customDateHandler: (Decoder) throws -> Date = { decoder in
            let substring = try decoder.singleValueContainer().decode(String.self).split(separator: ".").first!
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            if let date = formatter.date(from: String(substring)) {
                return date
            } else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "时间解析异常"))
            }
        }
        base.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.custom(customDateHandler)
        return base
    }
}
