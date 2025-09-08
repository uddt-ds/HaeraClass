//
//  Router.swift
//  HaeraClass
//
//  Created by Lee on 9/3/25.
//

import Foundation
import Alamofire

enum Router {
    case login(email: String, pw: String)
    case classCheck
    case classDetail(classId: String)
    case classSearch(title: String)
    case commentEdit(classId: String, editString: String)
    case commentSearch(classId: String)
    case commentRevise(classId: String, commentId: String, content: String)
    case commentDelete(classId: String, commentId: String)
    case likeClass(classId: String, likeStatus: Bool)
    case profileCheck


    var baseURL: String {
        return BaseURL.url
    }

    var path: String {
        switch self {
        case .login: return "/v1/users/login"
        case .classCheck: return "/v1/courses"
        case .classDetail(let classId): return "/v1/courses/\(classId)"
        case .classSearch: return "/v1/courses/search"
        case .commentEdit(let classId, _): return "/v1/courses/\(classId)/comments"
        case .commentSearch(let classId): return "/v1/courses/\(classId)/comments"
        case .commentRevise(let classId, let commentId, _): return "/v1/courses/\(classId)/comments/\(commentId)"
        case .commentDelete(let classId, let commentId): return "/v1/courses/\(classId)/comments/\(commentId)"
        case .likeClass(let classId, _):  return "/v1/courses/\(classId)/like"
        case .profileCheck: return "/v1/users/me/profile"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login: return .post
        case .classCheck: return .get
        case .classDetail: return .get
        case .classSearch: return .get
        case .commentEdit: return .post
        case .commentSearch: return .get
        case .commentRevise: return .put
        case .commentDelete: return .delete
        case .likeClass: return .post
        case .profileCheck: return .get
        }
    }

    var endPoint: URL! {
        return URL(string: baseURL + path)
    }

    var header: HTTPHeaders {
        guard let headerKey = Bundle.main.object(forInfoDictionaryKey: "SesacKey") as? String else { return .init() }

        let token = UserDefaults.standard.string(forKey: "token")

        var defaultHeader: HTTPHeaders = [
            "SesacKey": headerKey,
            "Content-Type": "application/json"
        ]

        if let token {
            defaultHeader.add(name: "Authorization", value: token)
        }

        switch self {
        case .login:
            return [
                "SesacKey": headerKey,
                "Content-Type": "application/json"
            ]

        default:
            return defaultHeader
        }

    }

    var parameter: Parameters {
        switch self {
        case .login(let email, let pw):
            return [
                "email": email,
                "password": pw
            ]
        case .classSearch(let title):
            return [
                "title": title
            ]
        case .commentEdit(_, let editString):
            return [
                "content": editString
            ]
        case .commentRevise(_, _, let reviseString):
            return [
                "content": reviseString
            ]

        case .likeClass(_, let likeStatus):
            return [
                "like_status": likeStatus
            ]
        default:
            return .init()
        }
    }
}

//enum MultipartRouter {
//    case profileRevise(nick: String?, profile: Data?)
//
//    var baseURL: String {
//        return BaseURL.url
//    }
//
//    var path: String {
//        switch self {
//        case .profileRevise:
//            return "/v1/users/me/profile"
//        }
//    }
//
//    var method: HTTPMethod {
//        switch self {
//        case .profileRevise: return .put
//        }
//    }
//
//    var endPoint: URL! {
//        return URL(string: baseURL + path)
//    }
//
//    var header: HTTPHeaders {
//        guard let headerKey = Bundle.main.object(forInfoDictionaryKey: "SesacKey") as? String else { return .init() }
//
//        guard let token = Bundle.main.object(forInfoDictionaryKey: "AccessToken") as? String else { return .init() }
//
//        switch self {
//        case .profileRevise:
//            return [
//                "SesacKey": headerKey,
//                "Authorization": token,
//                "Content-Type": "multipart/form-data"
//            ]
//        }
//    }
//
//    var parameter: Parameters {
//        switch self {
//        case .profileRevise(let nick, let profile):
//            if let nick = nick, let profile = profile {
//                return [
//                    "nick": nick,
//                    "profile": profile
//                ]
//            }
//            return .init()
//        }
//    }
//}
