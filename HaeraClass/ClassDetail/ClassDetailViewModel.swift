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

    init(classId: String, className: String, category: Int) {
        self.classId = classId
        self.className = className
        self.category = category
    }

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
        let commentCount: PublishRelay<String>
        let errorMessage: PublishRelay<String>
    }

    func transform(input: Input) -> Output {

        let detailData = PublishRelay<ClassDetail>()
        let photoData = PublishRelay<[String]>()
        let commentData = PublishRelay<Comment>()
        let selectedClassId = PublishRelay<String>()
        let commentCount = PublishRelay<String>()

        let isLiked = PublishRelay<Bool>()

        let saveResult = PublishRelay<String>()

        let errorMessage = PublishRelay<String>()

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
                    errorMessage.accept(error.errorMessage)
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
                    errorMessage.accept(error.errorMessage)
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
                    errorMessage.accept(error.errorMessage)
                }
            }
            .disposed(by: disposeBag)

        isLiked
            .map { $0 ? Message.isLiked.title : Message.isNotLiked.title }
            .bind(to: saveResult)
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(Notification.Name("commentPop"), object: nil)
            .withUnretained(self)
            .flatMap { owner, value in
                owner.networkManager.getData(router: .commentSearch(classId: owner.classId), type: Comment.self)
            }
            .bind(with: self) { owner, responseData in
                switch responseData {
                case .success(let value):
                    commentCount.accept(Message.showComment(value.data.count).title)
                case .failure(let error):
                    errorMessage.accept(error.errorMessage)
                }
            }
            .disposed(by: disposeBag)

        return Output(detailData: detailData, photoData: photoData, commentData: commentData, selectedClassId: selectedClassId, saveResult: saveResult, commentCount: commentCount, errorMessage: errorMessage)
    }
}

extension ClassDetailViewModel {
    enum Message {
        case isLiked
        case isNotLiked
        case showComment(Int)

        var title: String {
            switch self {
            case .isLiked: return "클래스를 찜했습니다"
            case .isNotLiked: return "클래스 찜을 취소했습니다"
            case .showComment(let count): return "댓글보기 (\(count))"
            }
        }
    }
}
