//
//  CommentEditViewModel.swift
//  HaeraClass
//
//  Created by Lee on 9/5/25.
//

import Foundation
import RxSwift
import RxCocoa

final class CommentEditViewModel: ViewModelProtocol {

    var disposeBag = DisposeBag()

    struct Input {
        let textField: ControlProperty<String>
    }

    struct Output {
        let textCount: BehaviorRelay<String>
        let textColor: BehaviorRelay<String>
        let saveButtonState: BehaviorRelay<Bool>
    }

    func transform(input: Input) -> Output {

        let maxCount = 200

        let textCount = BehaviorRelay(value: "0 / \(maxCount)")
        let textColor = BehaviorRelay(value: "")
        let saveButtonState = BehaviorRelay(value: false)

        let textField = input.textField
            .distinctUntilChanged()
            .share()

        textField
            .withUnretained(self)
            .map { owner, value in
                if value == "댓글을 작성해주세요" {
                    return "0 / \(maxCount)"
                } else if value.count > 200 {
                    return "200자 초과"
                }
                let onlyTextCount = owner.getOnlyTextCount(value)
                return "\(onlyTextCount) / \(maxCount)"
            }
            .bind(with: self) { owner, value in
                textCount.accept(value)
            }
            .disposed(by: disposeBag)

        textField
            .withUnretained(self)
            .map { owner, value in
                owner.getOnlyTextCount(value)
            }
            .map { value in
                if value > -1 && value < 150 {
                    return "black"
                } else if value >= 150 && value <= 200 {
                    return "red"
                } else {
                    return "red"
                }
            }
            .bind(with: self) { owner, value in
                textColor.accept(value)
            }
            .disposed(by: disposeBag)

        textField
            .withUnretained(self)
            .map { owner, value in
                owner.getOnlyTextCount(value)
            }
            .map { !($0 < 2 || $0 > 200) }
            .bind(with: self) { owner, value in
                saveButtonState.accept(value)
                print(value)
            }
            .disposed(by: disposeBag)

        return Output(textCount: textCount, textColor: textColor, saveButtonState: saveButtonState)
    }

    private func getOnlyTextCount(_ text: String) -> Int {
        let split = text.split(separator: " ")
        return split.joined().count
    }

}
