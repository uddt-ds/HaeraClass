//
//  LoginViewModel.swift
//  HaeraClass
//
//  Created by Lee on 9/3/25.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelProtocol {

    private var disposeBag = DisposeBag()

    let networkManager = NetworkManager.shared

    struct Input {
        let idTextField: ControlProperty<String>
        let pwTextField: ControlProperty<String>
        let loginButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let validateResult: PublishRelay<String>
        let loginValue: PublishRelay<Login>
        let loginResult: PublishRelay<Bool>
        let loginButtonState: PublishRelay<Bool>
    }

    func transform(input: Input) -> Output {
        let validateResult = PublishRelay<String>()
        let loginValue = PublishRelay<Login>()
        let loginResult = PublishRelay<Bool>()
        let loginButtonState = PublishRelay<Bool>()

        let textFieldInput = Observable.combineLatest(input.idTextField, input.pwTextField)

        textFieldInput
            .map { result in
                let idField = result.0
                let pwField = result.1
                if idField.count < 1 && idField.count < 1 {
                    return "이메일과 비밀번호를 입력해주세요"
                } else if !(idField.contains("@") && idField.contains(".com")) {
                    return "@와 .com을 포함해주세요"
                } else if !(pwField.count >= 2 && pwField.count < 10) {
                    return "2글자 이상 10글자 미만의 비밀번호를 설정해주세요"
                } else {
                    return ""
                }
            }
            .bind(to: validateResult)
            .disposed(by: disposeBag)

        input.loginButtonTapped
            .withLatestFrom(textFieldInput)
            .withUnretained(self)
            .debug()
            .flatMap { owner, value in
                owner.networkManager.fetchData(router: .login(email: value.0, pw: value.1), type: Login.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let data):
                    loginValue.accept(data)
                    UserDefaults.standard.set(data.accessToken, forKey: "token")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)

        validateResult
            .bind(with: self) { owner, value in
                if value == "" {
                    loginButtonState.accept(true)
                } else {
                    loginButtonState.accept(false)
                }
            }
            .disposed(by: disposeBag)

        loginValue
            .bind(with: self) { owner, value in
                if value.accessToken.count > 0 {
                    loginResult.accept(true)
                } else {
                    loginResult.accept(false)
                }
            }
            .disposed(by: disposeBag)

        return Output(validateResult: validateResult, loginValue: loginValue, loginResult: loginResult, loginButtonState: loginButtonState)
    }


    private func checkIdValidate(_ input: String) -> String? {
        if input.count < 1 {
            return "이메일과 비밀번호를 입력해주세요"
        } else if !(input.contains("@") && input.contains(".com")) {
            return "@와 .com을 포함해주세요"
        }
        return nil
    }

    private func checkPwValidate(_ input: String) -> String? {
        if input.count < 1 {
            return "이메일과 비밀번호를 입력해주세요"
        } else if input.count >= 2 && input.count < 10 {
            return "2글자 이상 10글자 미만으로 설정해주세요"
        }
        return nil
    }

}
