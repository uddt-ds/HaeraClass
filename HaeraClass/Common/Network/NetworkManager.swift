//
//  NetworkManager.swift
//  HaeraClass
//
//  Created by Lee on 9/3/25.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class NetworkManager {

    static let shared = NetworkManager()

    private init() { }

    func fetchData<T: Decodable>(router: Router, type: T.Type) -> Single<Result<T, CustomNetworkError>> {
        return Single.create { value in
            AF.request(router.endPoint,
                       method: router.method,
                       parameters: router.parameter,
                       encoding: JSONEncoding.default, 
                       headers: router.header)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: T.self) { responseData in
                switch responseData.result {
                case .success(let data):
                    value(.success(.success(data)))
                case .failure(let error):

                    if let urlError = error.underlyingError as? URLError {
                        switch urlError.code {
                        case .notConnectedToInternet:
                            value(.success(.failure(.noInternet)))
                        default:
                            value(.success(.failure(.unknown)))
                        }
                        return
                    }

                    if let data = responseData.data {
                        if let decodedData = try? JSONDecoder().decode(ServerError.self, from: data) {
                            value(.success(.failure(.serverError(message: decodedData.message))))
                            return
                        } else {
                            value(.success(.failure(.decodingError)))
                        }
                    }
                }
                value(.success(.failure(.unknown)))
            }
            return Disposables.create()
        }
    }

    func getData<T: Decodable>(router: Router, type: T.Type) -> Single<Result<T, CustomNetworkError>> {
        return Single.create { value in
            AF.request(router.endPoint,
                       parameters: router.parameter,
                       headers: router.header)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: T.self) { responseData in
                switch responseData.result {
                case .success(let data):
                    value(.success(.success(data)))
                case .failure(let error):

                    if let urlError = error.underlyingError as? URLError {
                        switch urlError.code {
                        case .notConnectedToInternet:
                            value(.success(.failure(.noInternet)))
                        default:
                            value(.success(.failure(.unknown)))
                        }
                        return
                    }

                    if let data = responseData.data {
                        if let decodedData = try? JSONDecoder().decode(ServerError.self, from: data) {
                            value(.success(.failure(.serverError(message: decodedData.message))))
                            return
                        } else {
                            value(.success(.failure(.decodingError)))
                        }
                    }
                }
                value(.success(.failure(.unknown)))
            }
            return Disposables.create()
        }
    }
}
