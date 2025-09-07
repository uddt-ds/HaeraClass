//
//  CategoryTitle.swift
//  HaeraClass
//
//  Created by Lee on 9/8/25.
//

import Foundation

enum CategoryTitle: Int, CaseIterable {
    case total
    case develop = 101
    case design = 102
    case foreignLanguage = 201
    case life = 202
    case beauty = 203
    case moneyTech = 301
    case etc = 900

    var title: String {
        switch self {
        case .total: return "전체"
        case .develop: return "개발"
        case .design: return "디자인"
        case .foreignLanguage: return "외국어"
        case .life: return "라이프"
        case .beauty: return "뷰티"
        case .moneyTech: return "재테크"
        case .etc: return "기타"
        }
    }
}
