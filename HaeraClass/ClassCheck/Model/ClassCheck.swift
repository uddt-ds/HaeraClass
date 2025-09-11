//
//  ClassCheck.swift
//  HaeraClass
//
//  Created by Lee on 9/11/25.
//

import Foundation

struct ClassCheck {
    let categoryTitle: String
    let category: Int  // UI 미사용 : 필터용
    let title: String
    let description: String
    let price: String
    let salePrice: String
    let createdAt: String // UI 미사용 : 정렬용
    let imageUrl: URL?
    let persent: String
    let isLiked: Bool
    let creator: Creator
}

// 
