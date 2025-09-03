//
//  Model.swift
//  HaeraClass
//
//  Created by Lee on 9/3/25.
//

import Foundation

struct Login: Decodable {
    let userId: String
    let email: String
    let nick: String
    let profileImage: String?
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
        case profileImage
        case accessToken
    }
}
