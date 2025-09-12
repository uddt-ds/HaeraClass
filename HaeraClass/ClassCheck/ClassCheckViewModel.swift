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

    private var datas: [ClassCheck] = []

    struct Input {
        let viewWillAppearTrigger: PublishSubject<Void>
        let initialSet: Observable<Void>
        let selectedCategory: BehaviorRelay<Int>
        let currentButtonState: BehaviorRelay<Bool>
        let sortButtonTap: ControlEvent<Void>
        let heartButtonTapped: PublishSubject<(String, Bool)>
    }

    struct State {
        let totalData: BehaviorRelay<[ClassCheck]>
        var currentCategories: Set<Int>
    }

    struct Output {
        let selectedData: BehaviorRelay<[ClassCheck]>
        let totalCount: PublishRelay<String>
        let buttonItems: BehaviorRelay<[CategoryTitle]>
        let saveResult: PublishRelay<String>
        let selectedCategories: BehaviorRelay<Set<Int>>
        let errorMessage: PublishRelay<String>
    }

    func transform(input: Input) -> Output {

        var state = State(totalData: BehaviorRelay(value: []), currentCategories: [])

        let buttonTitles = CategoryTitle.allCases
        let buttonItems = BehaviorRelay<[CategoryTitle]>(value: buttonTitles)

        let selectedData = BehaviorRelay<[ClassCheck]>(value: [])
        let totalCount = PublishRelay<String>()

        let isLiked = PublishRelay<Bool>()
        let saveResult = PublishRelay<String>()

        let errorMessage = PublishRelay<String>()

        let selectedCategories: BehaviorRelay<Set<Int>> = BehaviorRelay(value: state.currentCategories)

        input.viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.networkManager.getData(router: .classCheck, type: ClassCheckDTO.self)
            }
            .bind(with: self) { owner, value in
                switch value {
                case .success(let response):

                    let data = response.data.map { $0.toDomain() }
                    state.totalData.accept(data)

                    if state.currentCategories.isEmpty || state.currentCategories.contains(0) {
                        selectedData.accept(data)
                    } else {
                        let filterData = data.filter { state.currentCategories.contains($0.category) }
                        selectedData.accept(filterData)
                    }

                    let countTitle = "\(selectedData.value.count)개"
                    totalCount.accept(countTitle)
                case .failure(let error):
                    errorMessage.accept(error.errorMessage)
                }
            }
            .disposed(by: disposeBag)

        input.sortButtonTap
            .withLatestFrom(input.currentButtonState)
            .withUnretained(self)
            .map { owner, sortedToggle in
                let data = selectedData.value
                return owner.sortCurrentData(with: data, value: !sortedToggle)
            }
            .bind(with: self) { owner, value in
                selectedData.accept(value)
            }
            .disposed(by: disposeBag)

        input.selectedCategory
            .withLatestFrom(input.currentButtonState) { category, sortedToggle in
                return (category, sortedToggle)
            }
            .bind(with: self) { owner, value in
                let (category, sortedToggle) = value
                if category == 0 {
                    state.currentCategories.removeAll()
                    state.currentCategories.insert(0)
                    selectedData.accept(state.totalData.value)
                } else {
                    if state.currentCategories.contains(0) {
                        state.currentCategories.removeAll()
                    }

                    if state.currentCategories.contains(category) {
                        state.currentCategories.remove(category)
                        let data = selectedData.value.filter { $0.category != category }
                        selectedData.accept(data)

                        if state.currentCategories.count == 0 {
                            state.currentCategories.insert(0)
                            selectedData.accept(state.totalData.value)
                        }

                    } else if !state.currentCategories.contains(category){
                        if !state.currentCategories.contains(0) {
                            state.currentCategories.insert(category)
                            let totalData = state.totalData.value
                            let data = totalData.filter { state.currentCategories.contains($0.category) }
                            selectedData.accept(data)
                        }
                    }
                }

                let sorttedData = owner.sortCurrentData(with: selectedData.value, value: sortedToggle)
                selectedData.accept(sorttedData)
                totalCount.accept("\(selectedData.value.count)개")

                selectedCategories.accept(state.currentCategories)
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


        return Output(selectedData: selectedData,
                      totalCount: totalCount,
                      buttonItems: buttonItems,
                      saveResult: saveResult,
                      selectedCategories: selectedCategories,
                      errorMessage: errorMessage)
    }

    private func sortCurrentData(with data: [ClassCheck], value: Bool) -> [ClassCheck] {
        let sortedArr = data.sorted { lhs, rhs in
            return lhs.createdAt > rhs.createdAt
        }

        if !value {
            return sortedArr
        } else {
            let priceSortedArr = sortedArr.sorted { lhs, rhs in
                return lhs.priceValue > rhs.priceValue
            }
            return priceSortedArr
        }
    }
}
