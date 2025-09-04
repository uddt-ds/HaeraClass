//
//  ClassDetailViewController.swift
//  HaeraClass
//
//  Created by Lee on 9/3/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct Dummy2 {
    let place: String
    let time: String
    let people: String
    let intro: String
}

final class ClassDetailViewController: BaseViewController {

    let disposeBag = DisposeBag()

    let viewModel: ClassDetailViewModel

    let dummy = [
        Dummy2(place: "미정", time: "미정", people: "미정", intro: "테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트"),
        Dummy2(place: "미정", time: "미정", people: "미정", intro: "테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트"),
        Dummy2(place: "미정", time: "미정", people: "미정", intro: "테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트")
        ]


    lazy var dummies = Observable.just(dummy)

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ClassDetailPhotoCell.self, forCellReuseIdentifier: ClassDetailPhotoCell.identifier)
        tableView.register(ClassInfoCell.self, forCellReuseIdentifier: ClassInfoCell.identifier)
        tableView.register(ClassIntroCell.self, forCellReuseIdentifier: ClassIntroCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    let underBarBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let commentButton: CustomButton = {
        let button = CustomButton("댓글보기 (0)")
        return button
    }()

    let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(.likeButton.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = ColorSet.darkGray.color
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [heartButton, commentButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalCentering
        return stack
    }()

    init(viewModel: ClassDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        tableView.rowHeight = 250
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false
    }

    override func configureHierarchy() {
        super.configureHierarchy()
        underBarBgView.addSubview(stackView)

        [tableView, underBarBgView].forEach { view.addSubview($0) }
    }

    override func configureLayout() {
        super.configureLayout()
        configureStackSubViewLayout()

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(underBarBgView.snp.top)
        }

        underBarBgView.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }

    private func configureStackSubViewLayout() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.directionalHorizontalEdges.bottom.equalToSuperview().inset(30)
        }

        heartButton.snp.makeConstraints { make in
            make.size.equalTo(44)
        }

        commentButton.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.width.equalTo(270)
        }
    }

    override func configureView() {
        super.configureView()
    }
}

//MARK: Rx Binding
extension ClassDetailViewController {
    private func bind() {

        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        // 데이터 개수가 1개니까 row도 1개....
        dummies
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                switch row {
                case 0:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ClassDetailPhotoCell.identifier, for: IndexPath(row: row, section: 0)) as? ClassDetailPhotoCell else { return .init () }
                    return cell
                case 1:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ClassInfoCell.identifier, for: IndexPath(row: row, section: 0)) as? ClassInfoCell  else { return .init() }
                    return cell
                case 2:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ClassIntroCell.identifier, for: IndexPath(row: row, section: 0)) as? ClassIntroCell else { return .init() }
                    return cell
                default:
                    return .init()
                }
            }
            .disposed(by: disposeBag)

        let input = ClassDetailViewModel.Input(viewDidLoadTrigger: Observable.just(()))

        let output = viewModel.transform(input: input)

        output.detailData
            .bind(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
    }
}

extension ClassDetailViewController: UITableViewDelegate {

}
