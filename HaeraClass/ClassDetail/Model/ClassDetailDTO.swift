//
//  ClassDetailModel.swift
//  HaeraClass
//
//  Created by Lee on 9/4/25.
//

import Foundation

struct ClassDetailDTO: Decodable {
    let classId: String
    let category: Int
    let title: String
    let description: String
    let price: Int?
    let salePrice: Int?
    let location: String?
    let date: String?
    let capacity: Int?
    let imageUrls: [String]
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
        case location
        case date
        case capacity
        case imageUrls = "image_urls"
        case createdAt = "created_at"
        case isLiked = "is_liked"
        case creator
    }

    func makeToEntity() -> ClassDetail {
        return .init(description: description,
                     location: bindLocation,
                     date: bindDate,
                     capacity: bindCapacity,
                     isLiked: isLiked,
                     profileImage: creator.bindImageUrl,
                     creatorNick: creator.nick)
    }
}

extension ClassDetailDTO {
    var bindLocation: String {
        return location ?? "미정"
    }

    var bindDate: String {
        return DateManager.setupDate(value: date)
    }

    var bindCapacity: String {
        return changeValue(capacity)
    }

    private func changeValue(_ capacity: Int?) -> String {
        if let capacity {
            return "\(capacity.demical)명"
        } else {
            return "미정"
        }
    }
}
