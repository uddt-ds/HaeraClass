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

    private var disposeBag = DisposeBag()

    private let networkManager = NetworkManager.shared

    private var list = [
        SectionOfCustomData(header: "", items: [""]),
        SectionOfCustomData(header: "", items: [""]),
        SectionOfCustomData(header: "", items: [""])
    ]

    struct Input {
        let viewDidLoadTrigger: Observable<Void>
    }

    struct Output {
        let detailData: PublishRelay<ClassDetailModel>
    }

    func transform(input: Input) -> Output {

        let detailData = PublishRelay<ClassDetailModel>()

        input.viewDidLoadTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                return owner.networkManager.getData(router: .classDetail(classId: owner.classId), type: ClassDetailModel.self)
            }
            .bind(with: self) { owner, responseData in
                switch responseData {
                case .success(let data):
                    print(data)
                    detailData.accept(data)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)

        return Output(detailData: detailData)
    }

    init(classId: String) {
        self.classId = classId
    }
}
