//
//  LoginViewModel.swift
//  HaeraClass
//
//  Created by Lee on 9/3/25.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class LoginViewModel: ViewModelProtocol {

    private var disposeBag = DisposeBag()

    private let networkManager = NetworkManager.shared

    struct Input {
        let idTextField: ControlProperty<String>
        let pwTextField: ControlProperty<String>
        let loginButtonTapped: ControlEvent<Void>
    }

    struct State {
        let loginValue = PublishRelay<Login>()
    }

    struct Output {
        let validateResult: PublishRelay<String>
        let loginResult: PublishRelay<Bool>
        let loginButtonState: PublishRelay<Bool>
        let errorMessage: PublishRelay<String>
    }

    func transform(input: Input) -> Output {

        let state = State()

        let validateResult = PublishRelay<String>()
        let loginResult = PublishRelay<Bool>()
        let loginButtonState = PublishRelay<Bool>()
        let errorMessage = PublishRelay<String>()

        let textFieldInput = Observable.combineLatest(input.idTextField, input.pwTextField)

        textFieldInput
            .withUnretained(self)
            .map { owner, result in
                let (id, pw) = result
                return owner.checkValidate(id: id, pw: pw)
            }
            .bind(to: validateResult)
            .disposed(by: disposeBag)

        validateResult
            .map { $0.isEmpty }
            .bind(with: self) { owner, value in
                loginButtonState.accept(value)
            }
            .disposed(by: disposeBag)

        input.loginButtonTapped
            .withLatestFrom(textFieldInput)
            .withUnretained(self)
            .flatMap { owner, value -> Single<Result<Login, CustomNetworkError>> in
                let (id, pw) = value
                return owner.networkManager.fetchData(router: .login(email: id, pw: pw), type: Login.self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let data):
                    state.loginValue.accept(data)
                    owner.saveToDataInUserDefaults(id: data.userId, token: data.accessToken)
                case .failure(let error):
                    errorMessage.accept(error.errorMessage)
                }
            }
            .disposed(by: disposeBag)

        state.loginValue
            .map { !($0.accessToken.isEmpty) }
            .bind(to: loginResult)
            .disposed(by: disposeBag)

        return Output(validateResult: validateResult,
                      loginResult: loginResult,
                      loginButtonState: loginButtonState,
                      errorMessage: errorMessage)
    }
}

extension LoginViewModel {
    private func checkValidate(id: String, pw: String) -> String {
        if id.count < 1 && pw.count < 1 {
            return LoginValidateTitle.emptyInput.rawValue
        } else if !(id.contains("@") && id.contains(".com")) {
            return LoginValidateTitle.wrongIdInput.rawValue
        } else if !(pw.count >= 2 && pw.count < 10) {
            return LoginValidateTitle.wrongPwInput.rawValue
        } else if id.count > 30 {
            return LoginValidateTitle.tooLongId.rawValue
        } else {
            return ""
        }
    }

    private func saveToDataInUserDefaults(id: String, token: String) {
        UserDefaults.standard.set(id, forKey: UserDefaultKey.userId.rawValue)
        UserDefaults.standard.set(token, forKey: UserDefaultKey.token.rawValue)
    }
}

extension LoginViewModel {
    enum LoginValidateTitle: String {
        case emptyInput = "이메일과 비밀번호를 입력해주세요"
        case wrongIdInput = "@와 .com을 포함해주세요"
        case tooLongId = "아이디가 너무 깁니다. 30자 미만의 아이디를 입력해주세요"
        case wrongPwInput = "2글자 이상 10글자 미만의 비밀번호를 설정해주세요"
    }

    enum UserDefaultKey: String {
        case userId
        case token
    }
}
