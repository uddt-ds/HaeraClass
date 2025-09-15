//
//  ClassCommentViewModel.swift
//  HaeraClass
//
//  Created by Lee on 9/5/25.
//

import Foundation
import RxSwift
import RxCocoa

final class ClassCommentViewModel: ViewModelProtocol {

    var classData: ClassData

    private let disposeBag = DisposeBag()

    private let networkManager = NetworkManager.shared

    let userId = UserDefaults.standard.string(forKey: "userId") ?? ""

    init(classData: ClassData) {
        self.classData = classData
    }

    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let deleteTapped: PublishRelay<Void>
    }

    struct Output {
        let commentData: BehaviorRelay<[CommentData]>
        let currentUserId: BehaviorRelay<String>
        let errorMessage: PublishRelay<String>
    }

    func transform(input: Input) -> Output {

        let commentData: BehaviorRelay<[CommentData]> = BehaviorRelay(value: [])

        let currentUserId = BehaviorRelay(value: userId)

        let errorMessage = PublishRelay<String>()

        let viewDidLoad = input.viewDidLoadTrigger
            .share()

        viewDidLoad
            .withUnretained(self)
            .flatMap { owner, _ in
                return owner.networkManager.getData(router: .commentSearch(classId: owner.classData.classId), type: Comment.self)
            }
            .bind(with: self) { owner, responseData in
                switch responseData {
                case .success(let value):
                    commentData.accept(value.data)
                case .failure(let error):
                    errorMessage.accept(error.errorMessage)
                }
            }
            .disposed(by: disposeBag)

        input.deleteTapped
            .withUnretained(self)
            .flatMap { owner, _ in
                return owner.networkManager.fetchData(router: .commentDelete(classId: owner.classData.classId, commentId: owner.classData.commentId), type: Comment.self)
            }
            .withUnretained(self)
            .flatMap { owner, _ in
                return owner.networkManager.getData(router: .commentSearch(classId: owner.classData.classId), type: Comment.self)
            }
            .bind(with: self) { owner, responseData in
                switch responseData {
                case .success(let value):
                    commentData.accept(value.data)
                case .failure(let error):
                    errorMessage.accept(error.errorMessage)
                }
            }
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(Notification.Name("isPop"), object: nil)
            .withUnretained(self)
            .flatMap { owner, _ in
                return owner.networkManager.getData(router: .commentSearch(classId: owner.classData.classId), type: Comment.self)
            }
            .bind(with: self) { owner, responseData in
                switch responseData {
                case .success(let value):
                    commentData.accept(value.data)
                case .failure(let error):
                    errorMessage.accept(error.errorMessage)
                }
            }
            .disposed(by: disposeBag)

        return Output(commentData: commentData, currentUserId: currentUserId, errorMessage: errorMessage)
    }
}
