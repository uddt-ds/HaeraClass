//
//  LoginViewController.swift
//  HaeraClass
//
//  Created by Lee on 9/2/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LoginViewController: BaseViewController {

    var disposeBag = DisposeBag()

    let viewModel = LoginViewModel()

    private let loginImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .splash
        return imageView
    }()

    private let idHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.text = TextField.id.rawValue
        label.textColor = .black
        return label
    }()

    private let idTextField: UITextField = {
        let txtField = UITextField()
        txtField.setField(placeHolder: TextField.id.phText,
                          borderColor: ColorSet.orange.color.cgColor,
                          borderWidth: 2,
                          radius: 10)
        txtField.becomeFirstResponder()
        return txtField
    }()

    private let pwHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.text = TextField.pw.rawValue
        label.textColor = .black
        return label
    }()

    private let pwTextField: UITextField = {
        let txtField = UITextField()
        txtField.setField(placeHolder: TextField.id.phText,
                          borderColor: ColorSet.orange.color.cgColor,
                          borderWidth: 2,
                          radius: 10)
        return txtField
    }()

    private let button: CustomButton = {
        let button = CustomButton("로그인")
        return button
    }()

    private let validateLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorSet.orange.color
        label.font = .boldSystemFont(ofSize: 12)
        label.text = "테스트"
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func configureHierarchy() {
        super.configureHierarchy()

        [loginImageView, idHeaderLabel, idTextField, pwHeaderLabel, pwTextField, button, validateLabel]
            .forEach { view.addSubview($0) }

    }

    override func configureLayout() {
        super.configureLayout()

        loginImageView.snp.makeConstraints { make in

            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.centerX.equalToSuperview()
            make.size.equalTo(140)
        }

        idHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(loginImageView.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

        idTextField.snp.makeConstraints { make in
            make.top.equalTo(idHeaderLabel.snp.bottom).offset(10)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }

        pwHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(pwHeaderLabel.snp.bottom).offset(10)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }

        button.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }

        validateLabel.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    private func buttonState(_ state: Bool) {
        button.isEnabled = state
        if button.isEnabled {
            button.backgroundColor = ColorSet.lightOrange.color
        } else {
            button.backgroundColor = ColorSet.darkGray.color
        }
    }
}

// MARK: Rx Binding
extension LoginViewController {
    private func bind() {
        let input = LoginViewModel.Input(idTextField: idTextField.rx.text.orEmpty,
                                         pwTextField: pwTextField.rx.text.orEmpty,
                                         loginButtonTapped: button.rx.tap)

        let output = viewModel.transform(input: input)

        output.validateResult
            .bind(to: validateLabel.rx.text)
            .disposed(by: disposeBag)

        output.loginValue
            .bind(with: self) { owner, value in
                UserDefaults.standard.set(value.accessToken, forKey: "token")
            }
            .disposed(by: disposeBag)

        output.loginResult
            .bind(with: self) { owner, value in
                if value {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }

                    //TODO: 탭바 컨트롤러로 변경하기
                    let tabBar = TabBarController()
                    sceneDelegate.window?.rootViewController = tabBar
                    sceneDelegate.window?.makeKeyAndVisible()

                    guard let window = sceneDelegate.window else { return }

                    UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) { }
                }
            }
            .disposed(by: disposeBag)

        output.loginButtonState
            .bind(with: self, onNext: { owner, value in
                owner.buttonState(value)
            })
            .disposed(by: disposeBag)
    }
}

extension LoginViewController {
    enum TextField: String {
        case id = "이메일"
        case pw = "비밀번호"

        var phText: String {
            switch self {
            case .id: return "이메일을 입력해주세요"
            case .pw: return "비밀번호를 입력해주세요"
            }
        }
    }
}
