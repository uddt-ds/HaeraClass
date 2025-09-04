//
//  ClassSearchViewModel.swift
//  HaeraClass
//
//  Created by Lee on 9/4/25.
//

import Foundation
import RxSwift
import RxCocoa

final class ClassSearchViewModel: ViewModelProtocol {

    let networkManager = NetworkManager.shared

    let disposeBag = DisposeBag()

    struct Input {
        let searchText: ControlProperty<String>
        let searchButtonTapped:  ControlEvent<Void>
    }

    struct Output {
        let searchResult: PublishRelay<[Data]>
        let searchResultLabel: BehaviorRelay<String>
    }


    func transform(input: Input) -> Output {

        let searchResult = PublishRelay<[Data]>()
        let searchResultLabel = BehaviorRelay(value: "원하는 클래스가 있으신가요?")

        input.searchButtonTapped
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .filter { $0.count > 0 }
            .withUnretained(self)
            .flatMap { owner, value in
                print(value)
                return owner.networkManager.getData(router: .classSearch(title: value), type: ClassCheck.self)
            }
            .bind(with: self) { owner, responseData in
                switch responseData {
                case .success(let responseData):
                    searchResult.accept(responseData.data)

                    if responseData.data.count == 0 {
                        searchResultLabel.accept("검색 결과가 없습니다")
                    } else {
                        searchResultLabel.accept("")
                    }

                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)

        return Output(searchResult: searchResult, searchResultLabel: searchResultLabel)

    }


}
