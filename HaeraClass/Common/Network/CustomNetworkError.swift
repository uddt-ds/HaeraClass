//
//  CustomNetworkError.swift
//  HaeraClass
//
//  Created by Lee on 9/8/25.
//

import Foundation

enum CustomNetworkError: Error {
    case serverError(message: String)
    case decodingError
    case noInternet
    case unknown

    var errorMessage: String {
        switch self {
        case .serverError(let message): return message
        case .decodingError: return "디코딩 에러입니다"
        case .noInternet: return "네트워크 연결이 일시적으로 원활하지 않습니다. 데이터 또는 Wi-Fi 연결 상태를 확인해주세요"
        case .unknown: return "알 수 없는 오류가 발생하였습니다"
        }
    }
}
