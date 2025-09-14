//
//  CommentEditViewModel.swift
//  HaeraClass
//
//  Created by Lee on 9/5/25.
//

import Foundation
import RxSwift
import RxCocoa

final class CommentEditViewModel: ViewModelProtocol{

    let navTitle: String
    let classTitleValue: String
    let classId: String
    let category: Int
    let commentId: String?
    let content: String?

    let networkManager = NetworkManager.shared

    var disposeBag = DisposeBag()

    init(navTitle: String, classTitleValue: String, classId: String, category: Int, commentID: String? = nil, content: String? = nil) {
        self.navTitle = navTitle
        self.classTitleValue = classTitleValue
        self.classId = classId
        self.category = category
        self.commentId = commentID
        self.content = content
    }

    struct Input {
        let textField: ControlProperty<String>
        let saveButtonTap: ControlEvent<Void>
    }

    struct Output {
        let textCount: BehaviorRelay<String>
        let textColor: BehaviorRelay<String>
        let saveButtonState: BehaviorRelay<Bool>
        let isSaved: BehaviorRelay<Bool>
        let errorMessage: PublishRelay<String>
    }

    func transform(input: Input) -> Output {

        let textCount = BehaviorRelay(value: "0 / \(CommentLimit.maxCount.rawValue)")
        let textColor = BehaviorRelay(value: "")
        let saveButtonState = BehaviorRelay(value: false)

        let isSaved = BehaviorRelay(value: false)

        let errorMessage = PublishRelay<String>()

        let textField = input.textField
            .distinctUntilChanged()
            .share()

        textField
            .withUnretained(self)
            .map { owner, value in
                if value == "댓글을 작성해주세요" {
                    return "0 / \(CommentLimit.maxCount.rawValue)"
                } else if value.count > CommentLimit.maxCount.rawValue {
                    return "\(CommentLimit.maxCount.rawValue)자 초과"
                }
                let onlyTextCount = owner.getOnlyTextCount(value)
                return "\(onlyTextCount) / \(CommentLimit.maxCount.rawValue)"
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
                if value > -1 && value < CommentLimit.middleCount.rawValue {
                    return "black"
                } else if value >= CommentLimit.middleCount.rawValue && value <= CommentLimit.maxCount.rawValue {
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
            .map { !($0 < CommentLimit.minCount.rawValue || $0 > CommentLimit.maxCount.rawValue) }
            .bind(with: self) { owner, value in
                saveButtonState.accept(value)
            }
            .disposed(by: disposeBag)

        input.saveButtonTap
            .withLatestFrom(input.textField)
            .filter { $0 != "댓글을 작성해주세요" }
            .withUnretained(self)
            .flatMap { owner, value in
                if owner.navTitle == "댓글 작성" {
                    return owner.networkManager.fetchData(router: .commentEdit(classId: owner.classId, editString: value), type: CommentData.self)
                } else {
                    return owner.networkManager.fetchData(router: .commentRevise(classId: owner.classId, commentId: owner.commentId ?? "", content: value), type: CommentData.self)
                }
            }
            .bind(with: self) { owner, responseData in
                switch responseData {
                case .success(_):
                    isSaved.accept(true)
                case .failure(let error):
                    isSaved.accept(false)
                    errorMessage.accept(error.errorMessage)
                }
            }
            .disposed(by: disposeBag)

        return Output(textCount: textCount,
                      textColor: textColor,
                      saveButtonState: saveButtonState,
                      isSaved: isSaved,
                      errorMessage: errorMessage)
    }

    private func getOnlyTextCount(_ text: String) -> Int {
        let split = text.split(separator: " ")
        return split.joined().count
    }
}

extension CommentEditViewModel {
    enum CommentLimit: Int {
        case minCount = 2
        case middleCount = 150
        case maxCount = 200
    }
}
