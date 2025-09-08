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
        let heartButtonTapped: BehaviorSubject<(String, Bool)>
    }


    struct Output {
        let searchResult: PublishRelay<[Data]>
        let searchResultLabel: BehaviorRelay<String>
        let saveResult: PublishRelay<String>
    }

    func transform(input: Input) -> Output {

        let searchResult = PublishRelay<[Data]>()
        let searchResultLabel = BehaviorRelay(value: "원하는 클래스가 있으신가요?")
        let isLiked = PublishRelay<Bool>()
        let saveResult = PublishRelay<String>()

        input.viewWillAppearTrigger
            .withLatestFrom(input.searchText)
            .withUnretained(self)
            .flatMap { owner, value in
                print(value)
                return owner.networkManager.getData(router: .classSearch(title: value), type: ClassCheck.self)
            }
            .bind(with: self) { owner, responseData in
                switch responseData {
                case .success(let responseData):
                    print(responseData)
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

        input.heartButtonTapped
            .withUnretained(self)
            .flatMap { owner, value in
                let (classId, isLiked) = value
                return owner.networkManager.fetchData(router: .likeClass(classId: classId, likeStatus: isLiked), type: Like.self)
            }
            .bind(with: self) { owner, responseData in
                switch responseData {
                case .success(let data):
                    isLiked.accept(data.likeStatus)
                    print(data.likeStatus)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)

        isLiked
            .map { $0 ? "클래스를 찜했습니다" : "클래스 찜을 취소했습니다" }
            .bind(with: self) { owner, value in
                saveResult.accept(value)
            }
            .disposed(by: disposeBag)

        return Output(searchResult: searchResult, searchResultLabel: searchResultLabel, saveResult: saveResult)
    }
}
