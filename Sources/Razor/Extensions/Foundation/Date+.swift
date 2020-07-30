//
//  Date+.swift
//  Razor
//
//  Created by 徐才超 on 2020/7/1.
//

import Foundation

extension Date: RazorCompatibleValue {}
extension RazorWrapper where Base == Date {
    
    public var year: Int {
        return Calendar.current.component(.year, from: base)
    }
    
    public var month: Int {
        return Calendar.current.component(.month, from: base)
    }
    
    public var day: Int {
        return Calendar.current.component(.day, from: base)
    }
    
    public var hour: Int {
        return Calendar.current.component(.hour, from: base)
    }
    
    public var minute: Int {
        return Calendar.current.component(.minute, from: base)
    }
    
    public var second: Int {
        return Calendar.current.component(.second, from: base)
    }
    
    public var nanosecond: Int {
        return Calendar.current.component(.nanosecond, from: base)
    }
    
    public var weekday: Int {
        return Calendar.current.component(.weekday, from: base)
    }
    
    public var weekdayOrdinal: Int {
        return Calendar.current.component(.weekdayOrdinal, from: base)
    }
    
    public var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: base)
    }
    
    public var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: base)
    }
    
    public var yearForWeekOfYear: Int {
        return Calendar.current.component(.yearForWeekOfYear, from: base)
    }
    
    public var quarter: Int {
        return Calendar.current.component(.quarter, from: base)
    }
    
    public var isLeapYear: Bool {
        return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)))
    }
    
    public var isLeapMonth: Bool {
        return Calendar.current.dateComponents([.year, .month, .day], from: base).isLeapMonth!
    }
    
    public var isToday: Bool {
        return Calendar.current.isDateInToday(base)
    }
    
    public var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(base)
    }
    
    public var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(base)
    }
    
    public var isWeekend: Bool {
        return Calendar.current.isDateInWeekend(base)
    }
    
    public func dateByAdd(years: Int) -> Base {
        return Calendar.current.date(byAdding: .year, value: years, to: base)!
    }
    
    public func dateByAdd(months: Int) -> Base {
        return Calendar.current.date(byAdding: .month, value: months, to: base)!
    }
    
    public func dateByAdd(weeks: Int) -> Base {
        return Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: base)!
    }
    
    public func dateByAdd(days: Int) -> Base {
        return Calendar.current.date(byAdding: .day, value: days, to: base)!
    }
    
    public func dateByAdd(hours: Int) -> Base {
        return Calendar.current.date(byAdding: .hour, value: hours, to: base)!
    }
    
    public func dateByAdd(minutes: Int) -> Base {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: base)!
    }
    
    public func dateByAdd(seconds: Int) -> Base {
        return Calendar.current.date(byAdding: .second, value: seconds, to: base)!
    }
    
    public func stringWith(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        return formatter.string(from: base)
    }
    
    public var stringWithISOFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: base)
    }
    
    public static func dateWith(string: String, format: String, timeZone: TimeZone? = nil, locale: Locale? = nil) -> Base? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let tz = timeZone {
            formatter.timeZone = tz
        }
        if let lc = locale {
            formatter.locale = lc
        }
        return formatter.date(from: string)
    }
    
    public static func dateWithISOFormat(string: String) -> Base? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: string)
    }
    
    public var cuteDescription: String {
        let calendar = Calendar.current
        // 如果是一天之内
        if isToday {
            let since = Date().timeIntervalSince(base)
            if since < 60.0 {
                return "刚刚"
            }
            if since < 3600.0 {
                return "\(Int(since/60))分钟前"
            }
            return "\(Int(since/3600.0))小时前"
        }
        let dateFormat: String
        if isYesterday {
            dateFormat = "昨天 HH:mm"
        } else {
            let component = calendar.dateComponents([.year], from: base, to: Date())
            if let year = component.year, year > 1 {
                dateFormat = "yyyy-MM-dd HH:mm"
            } else {
                dateFormat = "MM-dd HH:mm"
            }
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: base)
    }
}
