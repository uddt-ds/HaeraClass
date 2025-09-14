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
        let selectedCategory: BehaviorRelay<Int>
        let currentButtonState: BehaviorRelay<Bool>
        let sortButtonTap: ControlEvent<Void>
    }

    struct State {
        let totalData: BehaviorRelay<[ClassCheck]>
        var currentCategories: Set<Int>
    }

    struct Output {
        let selectedData: BehaviorRelay<[ClassCheck]>
        let totalCount: PublishRelay<String>
        let buttonItems: BehaviorRelay<[CategoryTitle]>
        let selectedCategories: BehaviorRelay<Set<Int>>
        let scrollGoToTopTrigger: PublishRelay<Void>
    }

    func transform(input: Input) -> Output {

        var state = State(totalData: BehaviorRelay(value: []), currentCategories: [])

        let buttonTitles = CategoryTitle.allCases
        let buttonItems = BehaviorRelay<[CategoryTitle]>(value: buttonTitles)

        let selectedData = BehaviorRelay<[ClassCheck]>(value: [])
        let totalCount = PublishRelay<String>()

        let saveResult = PublishRelay<String>()

        let errorMessage = PublishRelay<String>()

        let selectedCategories = BehaviorRelay(value: state.currentCategories)

        let scrollGoToTopTrigger = PublishRelay<Void>()

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
                scrollGoToTopTrigger.accept(())
            }
            .disposed(by: disposeBag)

        //TODO: 코드 로직 메서드 단위로 분리
        // Set Collection 업데이트
        // 필터링과 정렬 책임 분리
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
                scrollGoToTopTrigger.accept(())
            }
            .disposed(by: disposeBag)

        return Output(selectedData: selectedData,
                      totalCount: totalCount,
                      buttonItems: buttonItems,
                      selectedCategories: selectedCategories,
                      scrollGoToTopTrigger: scrollGoToTopTrigger)
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
