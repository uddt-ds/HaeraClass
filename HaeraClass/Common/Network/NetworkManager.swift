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

    func fetchData<T: Decodable>(router: Router, value: T.Type) -> Single<Result<T, Error>> {
        return Single.create { value in
            if let url = router.endPoint {
                AF.request(url,
                           method: router.method,
                           parameters: router.parameter,
                           encoding: JSONParameterEncoder.default as! ParameterEncoding,
                           headers: router.header)
                .responseDecodable(of: T.self) { responseData in
                    switch responseData.result {
                    case .success(let data):
                        value(.success(.success(data)))
                    case .failure(let error):
                        value(.success(.failure(error)))
                    }
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
