//
//  DateManager.swift
//  HaeraClass
//
//  Created by Lee on 9/4/25.
//

import Foundation

final class DateManager {
    
    static let formatter = DateFormatter()
    static let formatter2 = DateFormatter()

    private init() { }

    static func setupDate(value: String?) -> String {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = formatter.date(from: value ?? "") else { return "미정" }
        formatter2.dateFormat = "YYYY년 MM월 dd일 HH시 mm분"
        formatter2.locale = Locale(identifier: "ko_KR")
        let dateString = formatter2.string(from: date)
        return dateString
    }
}
