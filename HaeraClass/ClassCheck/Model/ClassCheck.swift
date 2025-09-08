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
    let price: Int?
    let salePrice: Int?
    let imageUrl: String
    let createdAt: String
    let isLiked: Bool
    let creator: Creator

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

extension Data {
    var bindImageUrl: URL? {
        return URL(string: BaseURL.url + "/v1" + imageUrl)
    }

    var categoryTitle: String {
        return CategoryTitle(rawValue: category)?.title ?? ""
    }

    var bindSalePrice: String {
        guard let salePrice else {
            return "무료"
        }
        return salePrice.demical
    }

    var bindPrice: String {
        guard let price else {
            return "무료"
        }
        return price.demical
    }

    var persent: String {
        if let price, let salePrice {
            return "\((salePrice * 100) / price)%"
        }
        return ""
    }
}

struct Creator: Decodable {
    let userID: String
    let nick: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick
        case profileImage
    }
}

extension Creator {
    var bindImageUrl: URL? {
        return URL(string: BaseURL.url + "/v1" + (profileImage ?? ""))
    }
}


