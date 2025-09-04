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
        let currentButtonState: BehaviorRelay<Bool>
        let sortButtonTap: ControlEvent<Void>
    }

    struct Output {
        let selectedData: BehaviorRelay<[Data]>
        let totalCount: PublishRelay<String>
        let buttonItems: BehaviorRelay<[CategoryTitle]>
    }

    func transform(input: Input) -> Output {

        let buttonItems: BehaviorRelay<[CategoryTitle]> = .init(value: CategoryTitle.allCases)

        let selectedData: BehaviorRelay<[Data]> = BehaviorRelay(value: [])
        let totalCount = PublishRelay<String>()

        input.initialSet
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.networkManager.getData(router: .classCheck, type: ClassCheck.self)
            }
            .bind(with: self) { owner, value in
                switch value {
                case .success(let response):
                    selectedData.accept(response.data)
                    let totalTitle = "\(response.data.count)개"
                    totalCount.accept(totalTitle)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)

        input.sortButtonTap
            .withLatestFrom(input.currentButtonState)
            .map { value in
                if value {
                    let data = selectedData.value
                    let sortedArr = data.sorted { lhs, rhs in
                        return lhs.createdAt > rhs.createdAt
                    }
                    return sortedArr
                } else {
                    let data = selectedData.value
                    let sortedArr = data.sorted { lhs, rhs in
                        return lhs.price ?? 0 > rhs.price ?? 0
                    }
                    return sortedArr
                }
            }
            .bind(with: self) { owner, value in
                selectedData.accept(value)
            }
            .disposed(by: disposeBag)

        input.categoryButtonTap
            .debug()
            .bind(with: self) { owner, value in
                let data = selectedData.value.filter { $0.category == CategoryTitle.allCases[value.row].rawValue }
                selectedData.accept(data)
                print(data)
            }
            .disposed(by: disposeBag)

        input.categoryButtonTap
            .bind(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)

        return Output(selectedData: selectedData, totalCount: totalCount, buttonItems: buttonItems)
    }
}
