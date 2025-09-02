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

    let dummy = [
        Dummy(image: .noProfile, header: "테스트", category: "테스트", description: "테스트테스트테스트", salePrice: "1000000원", price: "1000000원", persent: "90%"),
        Dummy(image: .noProfile, header: "테스트", category: "테스트", description: "테스트테스트테스트", salePrice: "1000000원", price: "1000000원", persent: "90%"),
        Dummy(image: .noProfile, header: "테스트", category: "테스트", description: "테스트테스트테스트", salePrice: "1000000원", price: "1000000원", persent: "90%"),
        Dummy(image: .noProfile, header: "테스트", category: "테스트", description: "테스트테스트테스트", salePrice: "1000000원", price: "1000000원", persent: "90%"),
        Dummy(image: .noProfile, header: "테스트", category: "테스트", description: "테스트테스트테스트", salePrice: "1000000원", price: "1000000원", persent: "90%"),
        Dummy(image: .noProfile, header: "테스트", category: "테스트", description: "테스트테스트테스트", salePrice: "1000000원", price: "1000000원", persent: "90%"),
        Dummy(image: .noProfile, header: "테스트", category: "테스트", description: "테스트테스트테스트", salePrice: "1000000원", price: "1000000원", persent: "90%"),
        Dummy(image: .noProfile, header: "테스트", category: "테스트", description: "테스트테스트테스트", salePrice: "1000000원", price: "1000000원", persent: "90%")
    ]

    lazy var dummies = Observable.just(dummy)

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

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func configureHierarchy() {
        super.configureHierarchy()
        [searchBar, tableView].forEach { view.addSubview($0) }
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
    }

    override func configureView() {
        super.configureView()
    }
}

// MARK: Rx Binding
extension ClassSearchViewController {
    private func bind() {
        dummies
            .bind(to: tableView.rx.items(cellIdentifier: ClassSearchCell.identifier, cellType: ClassSearchCell.self)) { (row, element, cell) in
                cell.configureCell(with: element)
            }
            .disposed(by: disposeBag)
    }
}

extension ClassSearchViewController {
    enum TextField: String {
        case search = "검색어를 입력해주세요"
    }
}
