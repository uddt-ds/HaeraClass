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
    static let formatter3 = DateFormatter()
    static let relativeFormatter = RelativeDateTimeFormatter()

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

    static func getRelativeDate(value: String?) -> String {
        formatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = formatter.date(from: value ?? "") else { return "" }

        guard let distanceDate = Calendar.current.dateComponents([.day], from: date, to: Date()).day else { return "" }

        if distanceDate >= 7 {
            formatter3.dateFormat = "yyyy년 MM월 dd일 tt HH시 mm분"
            formatter3.locale = Locale(identifier: "ko_KR")
            let dateString = formatter3.string(from: date)
            return dateString
        } else {
            relativeFormatter.locale = Locale(identifier: "ko_KR")
            relativeFormatter.dateTimeStyle = .named
            relativeFormatter.unitsStyle = .short
            let dateString = relativeFormatter.localizedString(for: date, relativeTo: .now)
            return dateString
        }
    }
}
