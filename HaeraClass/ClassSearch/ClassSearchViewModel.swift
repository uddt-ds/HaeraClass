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
        let viewWillAppearTrigger: PublishSubject<Void>
        let searchText: ControlProperty<String>
        let searchButtonTapped:  ControlEvent<Void>
    }


    struct Output {
        let searchResult: PublishRelay<[DataDTO]>
        let searchResultLabel: BehaviorRelay<String>
        let errorMessage: PublishRelay<String>
}

    func transform(input: Input) -> Output {

        let searchResult = PublishRelay<[DataDTO]>()
        let searchResultLabel = BehaviorRelay(value: Message.greeting.rawValue)
        let errorMessage = PublishRelay<String>()

        input.viewWillAppearTrigger
            .withLatestFrom(input.searchText)
            .withUnretained(self)
            .flatMap { owner, value in
                return owner.networkManager.getData(router: .classSearch(title: value), type: ClassCheckDTO.self)
            }
            .bind(with: self) { owner, responseData in
                switch responseData {
                case .success(let responseData):
                    searchResult.accept(responseData.data)

                    if responseData.data.count == 0 {
                        searchResultLabel.accept(Message.noResult.rawValue)
                    } else {
                        searchResultLabel.accept("")
                    }

                case .failure(let error):
                    errorMessage.accept(error.errorMessage)
                }
            }
            .disposed(by: disposeBag)


        input.searchButtonTapped
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .filter { $0.count > 0 }
            .withUnretained(self)
            .flatMap { owner, value in
                return owner.networkManager.getData(router: .classSearch(title: value), type: ClassCheckDTO.self)
            }
            .bind(with: self) { owner, responseData in
                switch responseData {
                case .success(let responseData):
                    searchResult.accept(responseData.data)

                    if responseData.data.count == 0 {
                        searchResultLabel.accept(Message.noResult.rawValue)
                    } else {
                        searchResultLabel.accept("")
                    }

                case .failure(let error):
                    errorMessage.accept(error.errorMessage)
                }
            }
            .disposed(by: disposeBag)

        return Output(searchResult: searchResult,
                      searchResultLabel: searchResultLabel,
                      errorMessage: errorMessage)
    }
}

extension ClassSearchViewModel {
    enum Message: String {
        case noResult = "검색 결과가 없습니다"
        case greeting = "원하는 클래스가 있으신가요?"
    }
}
