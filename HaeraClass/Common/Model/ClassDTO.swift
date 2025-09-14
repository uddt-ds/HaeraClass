//
//  Class.swift
//  HaeraClass
//
//  Created by Lee on 9/3/25.
//

import Foundation

struct ClassDTO: Decodable {
    let data: [ClassDataDTO]
}

struct ClassDataDTO: Decodable {
    let classId: String
    let category: Int
    let title: String
    let description: String
    let imageUrl: String
    let createdAt: String
    let isLiked: Bool
    let creator: ClassCreatorDTO

    enum CodingKeys: String, CodingKey {
        case classId = "class_id"
        case category
        case title
        case description
        case imageUrl = "image_url"
        case createdAt = "created_at"
        case isLiked = "is_liked"
        case creator
    }
}

struct ClassCreatorDTO: Decodable {
    let userId: String
    let nick: String
    let profileImage: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
    }
}
