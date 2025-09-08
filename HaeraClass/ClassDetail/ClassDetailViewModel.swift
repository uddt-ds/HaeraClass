//
//  ClassDetailViewModel.swift
//  HaeraClass
//
//  Created by Lee on 9/4/25.
//

import Foundation
import RxSwift
import RxCocoa

final class ClassDetailViewModel: ViewModelProtocol {

    private let classId: String
    let className: String
    let category: Int

    private var disposeBag = DisposeBag()

    private let networkManager = NetworkManager.shared

    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let commentButtonTap: ControlEvent<Void>
        let heartButtonTap: Observable<Bool>
    }

    struct Output {
        let detailData: PublishRelay<ClassDetail>
        let photoData: PublishRelay<[String]>
        let commentData: PublishRelay<Comment>
        let selectedClassId: PublishRelay<String>
        let saveResult: PublishRelay<String>
    }

    func transform(input: Input) -> Output {

        let detailData = PublishRelay<ClassDetail>()
        let photoData = PublishRelay<[String]>()
        let commentData = PublishRelay<Comment>()
        let selectedClassId = PublishRelay<String>()

        let isLiked = PublishRelay<Bool>()

        let saveResult = PublishRelay<String>()

        let viewDidLoad = input.viewDidLoadTrigger
            .share()

        viewDidLoad
            .withUnretained(self)
            .flatMap { owner, _ in
                return owner.networkManager.getData(router: .classDetail(classId: owner.classId), type: ClassDetail.self)
            }
            .bind(with: self) { owner, responseData in
                switch responseData {
                case .success(let data):
                    detailData.accept(data)
                    photoData.accept(data.imageUrls)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)

        viewDidLoad
            .withUnretained(self)
            .flatMap { owner, _ in
                return owner.networkManager.getData(router: .commentSearch(classId: owner.classId), type: Comment.self)
            }
            .bind(with: self) { owner, responseData in
                switch responseData {
                case .success(let data):
                    commentData.accept(data)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)

        input.commentButtonTap
            .bind(with: self) { owner, _ in
                selectedClassId.accept(owner.classId)
            }
            .disposed(by: disposeBag)

        input.heartButtonTap
            .withUnretained(self)
            .flatMap { owner, value in
                return owner.networkManager.fetchData(router: .likeClass(classId: owner.classId, likeStatus: value), type: Like.self)
            }
            .bind(with: self) { owner, responseData in
                switch responseData {
                case .success(let data):
                    isLiked.accept(data.likeStatus)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)

        isLiked
            .map { $0 ? "클래스를 찜했습니다" : "클래스 찜을 취소했습니다" }
            .bind(to: saveResult)
            .disposed(by: disposeBag)

        return Output(detailData: detailData, photoData: photoData, commentData: commentData, selectedClassId: selectedClassId, saveResult: saveResult)
    }

    init(classId: String, className: String, category: Int) {
        self.classId = classId
        self.className = className
        self.category = category
    }
}
