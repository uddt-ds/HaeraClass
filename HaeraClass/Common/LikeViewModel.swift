//
//  LikeViewModel.swift
//  HaeraClass
//
//  Created by Lee on 9/14/25.
//

import Foundation
import RxSwift
import RxCocoa

final class LikeViewModel: ViewModelProtocol {
    private let networkManager = NetworkManager.shared
    private let disposeBag = DisposeBag()

    struct Input {
        let heartButtonTapped: PublishSubject<(String, Bool)>
    }

    struct Output {
        let isLiked: PublishRelay<Bool>
        let saveResult: PublishRelay<String>
        let errorMessage: PublishRelay<String>
    }

    func transform(input: Input) -> Output {
        let isLiked = PublishRelay<Bool>()
        let saveResult = PublishRelay<String>()
        let errorMessage = PublishRelay<String>()

        input.heartButtonTapped
            .withUnretained(self)
            .flatMap { owner, value in
                let (classId, isLiked) = value
                return owner.networkManager.fetchData(router: .likeClass(classId: classId, likeStatus: isLiked), type: Like.self)
            }
            .bind(with: self) { owner, responseData in
                switch responseData {
                case .success(let data):
                    isLiked.accept(data.likeStatus)
                case .failure(let error):
                    errorMessage.accept(error.errorMessage)
                }
            }
            .disposed(by: disposeBag)

        isLiked
            .map { $0 ? Message.isLiked.title : Message.isNotLiked.title }
            .bind(with: self) { owner, value in
                saveResult.accept(value)
            }
            .disposed(by: disposeBag)

        return Output(isLiked: isLiked, saveResult: saveResult, errorMessage: errorMessage)
    }
}

extension LikeViewModel {
    enum Message {
        case isLiked
        case isNotLiked

        var title: String {
            switch self {
            case .isLiked: return "클래스를 찜했습니다"
            case .isNotLiked: return "클래스 찜을 취소했습니다"
            }
        }
    }
}
