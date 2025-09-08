//
//  SettingViewModel.swift
//  HaeraClass
//
//  Created by Lee on 9/5/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingViewModel: ViewModelProtocol {

    let disposeBag = DisposeBag()

    struct Input {
        let okAlertTapped: ControlEvent<Void>
    }

    struct Output {
        let logoutMessage: PublishRelay<String>
    }

    func transform(input: Input) -> Output {
        let logoutMessage = PublishRelay<String>()

        input.okAlertTapped
            .map { "정말 로그아웃 하시겠습니까?" }
            .bind(to: logoutMessage)
            .disposed(by: disposeBag)

        return Output(logoutMessage: logoutMessage)
    }

}

