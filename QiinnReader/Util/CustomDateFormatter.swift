//
//  CustomDateFormatter.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/18.
//

import Foundation

struct CustomDateFormatter {
    static func createDateStrFromISO8601DateString(iSO8601DateString: String) -> String {
        let iso8601DateFormatter = ISO8601DateFormatter()
        let date = iso8601DateFormatter.date(from: iSO8601DateString)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
}
