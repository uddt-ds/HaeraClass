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

    private let classId: String

    let className: String

    let disposeBag = DisposeBag()

    let networkManager = NetworkManager.shared

    let userId = UserDefaults.standard.string(forKey: "userId") ?? ""

    init(classId: String, className: String) {
        self.classId = classId
        self.className = className
    }

    struct Input {
        let viewDidLoadTrigger: Observable<Void>
    }

    struct Output {
        let commentData: BehaviorRelay<[CommentData]>
        let currentUserId: BehaviorRelay<String>
    }

    func transform(input: Input) -> Output {

        let commentData: BehaviorRelay<[CommentData]> = BehaviorRelay(value: [])

        let currentUserId = BehaviorRelay(value: userId)

        let viewDidLoad = input.viewDidLoadTrigger
            .share()

        viewDidLoad
            .withUnretained(self)
            .flatMap { owner, _ in
                return owner.networkManager.getData(router: .commentSearch(classId: owner.classId), type: Comment.self)
            }
            .bind(with: self) { owner, responseData in
                switch responseData {
                case .success(let value):
                    commentData.accept(value.data)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)


        return Output(commentData: commentData, currentUserId: currentUserId)
    }
}
