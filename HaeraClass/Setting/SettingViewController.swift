//
//  ViewController.swift
//  HaeraClass
//
//  Created by Lee on 9/2/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SettingViewController: BaseViewController {

    let disposeBag = DisposeBag()

    let alertManager = AlertManager.shared

    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle(SettingTitle.logout.rawValue, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = ColorSet.lightOrange.color
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func configureHierarchy() {
        super.configureHierarchy()
        [logoutButton].forEach { view.addSubview($0) }
    }

    override func configureLayout() {
        super.configureLayout()
        logoutButton.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }

    override func configureView() {
        super.configureView()
    }
}

//MARK: Rx Binding
extension SettingViewController {
    private func bind() {

        logoutButton.rx.tap
            .bind(with: self) { owner, _ in
                print("buttonTapped")
                owner.alertManager.showLogoutAlert("정말 로그아웃 하시겠습니까?")
            }
            .disposed(by: disposeBag)
    }
}

extension SettingViewController {
    enum SettingTitle: String {
        case logout = "로그아웃"
    }
}
