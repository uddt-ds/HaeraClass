//
//  LikeViewModel.swift
//  HaeraClass
//
//  Created by Lee on 9/14/25.
//

import Foundation
import RxSwift
import RxCocoa

final class LikeViewModel {

    private let networkManager = NetworkManager.shared
    private let disposeBag = DisposeBag()

    private let heartButtonTapped: PublishSubject<(String, Bool)>

    let isLiked = PublishRelay<Bool>()
    let saveResult = PublishRelay<String>()
    let errorMessage = PublishRelay<String>()

    init(heartButtonTapped: PublishSubject<(String, Bool)>) {
        self.heartButtonTapped = heartButtonTapped
        bind()
    }

    func bind() {
        heartButtonTapped
            .withUnretained(self)
            .flatMap { owner, value in
                let (classId, isLiked) = value
                return owner.networkManager.fetchData(router: .likeClass(classId: classId, likeStatus: isLiked), type: Like.self)
            }
            .bind(with: self) { owner, responseData in
                switch responseData {
                case .success(let data):
                    owner.isLiked.accept(data.likeStatus)
                case .failure(let error):
                    owner.errorMessage.accept(error.errorMessage)
                }
            }
            .disposed(by: disposeBag)

        isLiked
            .map { $0 ? Message.isLiked.title : Message.isNotLiked.title }
            .bind(with: self) { owner, value in
                owner.saveResult.accept(value)
            }
            .disposed(by: disposeBag)
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
