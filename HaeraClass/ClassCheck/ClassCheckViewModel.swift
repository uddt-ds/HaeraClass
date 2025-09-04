//
//  ClassCheckViewModel.swift
//  HaeraClass
//
//  Created by Lee on 9/4/25.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class ClassCheckViewModel: ViewModelProtocol {

    private let networkManager = NetworkManager.shared

    private var disposeBag = DisposeBag()

    struct Input {
        let initialSet: Observable<Void>
        let categoryButtonTap: ControlEvent<IndexPath>
        let sortButtonTap: ControlEvent<Void>
    }

    struct Output {
        let selectedData: PublishRelay<[Data]>
        let totalCount: PublishRelay<String>
    }

    func transform(input: Input) -> Output {

        let selectedData = PublishRelay<[Data]>()
        let totalCount = PublishRelay<String>()

        input.initialSet
            .debug()
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.networkManager.getData(router: .classCheck, type: ClassCheck.self)
            }
            .bind(with: self) { owner, value in
                switch value {
                case .success(let response):
                    print(response)
                    selectedData.accept(response.data)
                    let totalTitle = "\(response.data.count)개"
                    totalCount.accept(totalTitle)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)

        input.categoryButtonTap
            .bind(with: self) { owner, value in
            }

        return Output(selectedData: selectedData, totalCount: totalCount)
    }
}
