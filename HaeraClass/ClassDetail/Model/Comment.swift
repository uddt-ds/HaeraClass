//
//  Comment.swift
//  HaeraClass
//
//  Created by Lee on 9/4/25.
//

import Foundation

struct Comment: Decodable {
    let data: [CommentData]
}

struct CommentData: Decodable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: Creator

    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content
        case createdAt = "created_at"
        case creator
    }
}
