//
//  NetworkError.swift
//  HaeraClass
//
//  Created by Lee on 9/8/25.
//

import Foundation

enum CustomNetworkError: Error {
    case serverError(message: String)

    var errorMessage: String {
        switch self {
        case .serverError(let message): return message
        }
    }
}
