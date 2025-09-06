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
    }

    struct Output {
        let detailData: PublishRelay<ClassDetail>
        let commentData: PublishRelay<Comment>
        let selectedClassId: PublishRelay<String>
    }

    func transform(input: Input) -> Output {

        let detailData = PublishRelay<ClassDetail>()
        let commentData = PublishRelay<Comment>()
        let selectedClassId = PublishRelay<String>()

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



        return Output(detailData: detailData, commentData: commentData, selectedClassId: selectedClassId)
    }

    init(classId: String, className: String, category: Int) {
        self.classId = classId
        self.className = className
        self.category = category
    }
}
