//
//  ClassSearchViewController.swift
//  HaeraClass
//
//  Created by Lee on 9/2/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ClassSearchViewController: BaseViewController {

    var disposeBag = DisposeBag()

    let viewModel = ClassSearchViewModel()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = TextField.search.rawValue
        searchBar.layer.cornerRadius = 20
        searchBar.layer.masksToBounds = true
        searchBar.backgroundColor = .clear
        searchBar.backgroundImage = .init()
        searchBar.searchTextField.backgroundColor = .white
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = ColorSet.darkGray.color.cgColor
        return searchBar
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ClassSearchCell.self, forCellReuseIdentifier: ClassSearchCell.identifier)
        tableView.rowHeight = 140
        return tableView
    }()

    private let resultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupNav()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = false
    }

    override func configureHierarchy() {
        super.configureHierarchy()
        [searchBar, tableView, resultLabel].forEach { view.addSubview($0) }
    }

    override func configureLayout() {
        super.configureLayout()
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.directionalHorizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        resultLabel.snp.makeConstraints { make in
            make.center.equalTo(tableView)
        }
    }

    override func configureView() {
        super.configureView()
    }

    private func setupNav() {
        navigationController?.navigationBar.tintColor = .black
    }
}

// MARK: Rx Binding
extension ClassSearchViewController {
    private func bind() {

        let input = ClassSearchViewModel.Input(searchText: searchBar.rx.text.orEmpty, searchButtonTapped: searchBar.rx.searchButtonClicked)

        let output = viewModel.transform(input: input)

        output.searchResult
            .bind(to: tableView.rx.items(cellIdentifier: ClassSearchCell.identifier, cellType: ClassSearchCell.self)) { (row, element, cell) in
                cell.configureCell(with: element)
            }
            .disposed(by: disposeBag)

        output.searchResultLabel
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(Data.self)
            .bind(with: self) { owner, data in
                let viewModel = ClassDetailViewModel(classId: data.classId, className: data.title)
                let vc = ClassDetailViewController(viewModel: viewModel)
                owner.navigationItem.backButtonTitle = ""
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked
            .bind(with: self) { owner, _ in
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)
    }
}

extension ClassSearchViewController {
    enum TextField: String {
        case search = "검색어를 입력해주세요"
    }
}
