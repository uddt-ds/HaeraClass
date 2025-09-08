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

    var datas: [Data] = []

    struct Input {
        let viewWillAppearTrigger: PublishSubject<Void>
        let initialSet: Observable<Void>
        let selectedCategory: BehaviorRelay<Int>
        let currentButtonState: BehaviorRelay<Bool>
        let sortButtonTap: ControlEvent<Void>
        let heartButtonTapped: PublishSubject<(String, Bool)>
    }

    struct State {
        let totalData: BehaviorRelay<[Data]>
        var currentCategories: Set<Int>
    }

    struct Output {
        let selectedData: BehaviorRelay<[Data]>
        let totalCount: PublishRelay<String>
        let buttonItems: BehaviorRelay<[CategoryTitle]>
        let saveResult: PublishRelay<String>
        let selectedCategories: BehaviorRelay<Set<Int>>
        let errorMessage: PublishRelay<String>
    }

    func transform(input: Input) -> Output {

        let buttonTitles = CategoryTitle.allCases

        let buttonItems: BehaviorRelay<[CategoryTitle]> = .init(value: buttonTitles)

        var state = State(totalData: .init(value: []), currentCategories: [])

        let selectedData: BehaviorRelay<[Data]> = BehaviorRelay(value: [])
        let totalCount = PublishRelay<String>()

        let isLiked = PublishRelay<Bool>()
        let saveResult = PublishRelay<String>()

        let errorMessage = PublishRelay<String>()

        let selectedCategories: BehaviorRelay<Set<Int>> = BehaviorRelay(value: state.currentCategories)

        input.viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.networkManager.getData(router: .classCheck, type: ClassCheck.self)
            }
            .bind(with: self) { owner, value in
                switch value {
                case .success(let response):

                    state.totalData.accept(response.data)

                    if state.currentCategories.isEmpty || state.currentCategories.contains(0) {
                        selectedData.accept(response.data)
                    } else {
                        let filterData = response.data.filter { state.currentCategories.contains($0.category) }
                        selectedData.accept(filterData)
                    }

                    let countTitle = "\(selectedData.value.count)개"
                    totalCount.accept(countTitle)
                case .failure(let error):
                    errorMessage.accept(error.errorMessage)
                }
            }
            .disposed(by: disposeBag)

        input.initialSet
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.networkManager.getData(router: .classCheck, type: ClassCheck.self)
            }
            .bind(with: self) { owner, value in
                switch value {
                case .success(let response):
                    state.totalData.accept(response.data)
                    selectedData.accept(response.data)
                    let totalTitle = "\(response.data.count)개"
                    totalCount.accept(totalTitle)
                case .failure(let error):
                    errorMessage.accept(error.errorMessage)
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

        Observable.combineLatest(input.selectedCategory, input.currentButtonState)
            .bind(with: self) { owner, value in
                let (category, sortValue) = value
                if category == 0 {
                    state.currentCategories.removeAll()
                    selectedCategories.accept([0])
                    let data = owner.sort(with: state.totalData.value, value: sortValue)
                    selectedData.accept(data)
                    totalCount.accept("\(state.totalData.value.count)개")
                } else {
                    if !state.currentCategories.contains(category) {
                        state.currentCategories.insert(category)
                        selectedCategories.accept(state.currentCategories)
                    } else {
                        state.currentCategories.remove(category)
                        selectedCategories.accept(state.currentCategories)
                    }

                    if state.currentCategories == [] {
                        selectedCategories.accept([0])
                        let data = owner.sort(with: state.totalData.value, value: sortValue)
                        selectedData.accept(data)
                        totalCount.accept("\(selectedData.value.count)개")
                    } else {
                        let data = state.totalData.value.filter { state.currentCategories.contains($0.category) }
                        let sortedData = owner.sort(with: data, value: sortValue)
                        selectedData.accept(sortedData)
                        totalCount.accept("\(selectedData.value.count)개")
                    }
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
                case .failure(let error):
                    errorMessage.accept(error.errorMessage)
                }
            }
            .disposed(by: disposeBag)

        isLiked
            .map { $0 ? "클래스를 찜했습니다" : "클래스 찜을 취소했습니다" }
            .bind(with: self) { owner, value in
                saveResult.accept(value)
            }
            .disposed(by: disposeBag)


        return Output(selectedData: selectedData, totalCount: totalCount, buttonItems: buttonItems, saveResult: saveResult, selectedCategories: selectedCategories, errorMessage: errorMessage)
    }

    private func sort(with data: [Data], value: Bool) -> [Data] {
        if !value {
            let sortedArr = data.sorted { lhs, rhs in
                return lhs.createdAt > rhs.createdAt
            }
            return sortedArr
        } else {
            let sortedArr = data.sorted { lhs, rhs in
                return lhs.price ?? 0 > rhs.price ?? 0
            }
            return sortedArr
        }
    }
}
