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
                    if let data = responseData.data {
                        guard let decodedData = try? JSONDecoder().decode(ServerError.self, from: data) else { return }
                        let error = CustomNetworkError.serverError(message: decodedData.message)
                        print(error)
                        value(.success(.failure(.serverError(message: decodedData.message))))
                    }
                    value(.success(.failure(.serverError(message: ""))))
                }
            }
            return Disposables.create()
        }
    }

    func getData<T: Decodable>(router: Router, type: T.Type) -> Single<Result<T, AFError>> {
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
                    value(.success(.failure(error)))
                }
            }
            return Disposables.create()
        }
    }
}

extension NetworkManager {
    enum NetworkError: Int, Error {
        case invalidKey = 420
        case tooManyCalls = 429
        case invalidURL = 444
        case serverError = 500
    }
}
