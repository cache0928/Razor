//
//  Date+.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/1.
//

import Foundation

extension Date: RazorCompatibleValue {}
extension RazorWrapper where Base == Date {
    /*
     返回日期的描述文字，
     1分钟内：刚刚，
     1小时内：xx分钟前，
     1天内：HH:mm，
     昨天：昨天 HH:mm，
     1年内：MM-dd HH:mm，更早时间：yyyy-MM-dd HH:mm
     */
    public var cuteTime: String {
        let calendar = Calendar.current
        var dateFormat = "HH:mm"
        // 如果是一天之内
        if calendar.isDateInToday(base) {
            let since = Date().timeIntervalSince(base)
            //一分钟内
            if since < 60.0 {
                return "刚刚"
            }
            if since < 3600.0 {
                return "\(Int(since/60))分钟前"
            }
            return "\(Int(since/3600.0))小时前"
        }
        // 如果是昨天
        if calendar.isDateInYesterday(base) {
            dateFormat = "昨天 " + dateFormat
        } else {
            dateFormat = "MM-dd " + dateFormat
            let component = calendar.dateComponents([Calendar.Component.year], from: base, to: Date())
            if let year = component.year, year > 1 {
                dateFormat = "yyyy-" + dateFormat
            }
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: base)
    }
}
