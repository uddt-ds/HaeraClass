//
//  ClassCheck.swift
//  HaeraClass
//
//  Created by Lee on 9/2/25.
//

import Foundation

struct ClassCheck: Decodable {
    let data: [Data]
}

struct Data: Decodable {
    let classId: String
    let category: Int
    let title: String
    let description: String
    let price: Int
    let salePrice: Int
    let imageUrl: String
    let createdAt: String
    let isLiked: Bool
    let creator: [Creator]

    enum CodingKeys: String, CodingKey {
        case classId = "class_id"
        case category
        case title
        case description
        case price
        case salePrice = "sale_price"
        case imageUrl = "image_url"
        case createdAt = "created_at"
        case isLiked = "is_liked"
        case creator
    }
}

struct Creator: Decodable {
    let userID: String
    let nick: String
    let profileImage: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick
        case profileImage
    }
}


