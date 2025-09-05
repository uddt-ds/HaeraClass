//
//  ClassCommentViewController.swift
//  HaeraClass
//
//  Created by Lee on 9/5/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ClassCommentViewController: BaseViewController {

    var disposeBag = DisposeBag()

    let viewModel: ClassCommentViewModel

    init(viewModel: ClassCommentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        return table
    }()

    private let rightBarButton: UIButton = {
        let button = UIButton()
        button.setImage(.comment, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupNavigation(viewModel.className)
    }

    override func configureHierarchy() {
        super.configureHierarchy()
        [tableView].forEach { view.addSubview($0) }
    }

    override func configureLayout() {
        super.configureLayout()

        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func configureView() {
        super.configureView()
    }

    private func setupNavigation(_ title: String) {
        navigationItem.title = title
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
    }
}

//MARK: Rx Binding
extension ClassCommentViewController {
    private func bind() {
        let input = ClassCommentViewModel.Input(viewDidLoadTrigger: .just(()))

        let output = viewModel.transform(input: input)

        output.commentData
            .bind(to: tableView.rx.items(cellIdentifier: CommentCell.identifier, cellType: CommentCell.self)) { (row, element, cell) in
                cell.configureCell(element)
                cell.dotButtonHidden(!(output.currentUserId.value == element.creator.userID))
                cell.rx.dotButtonTapped
                    .bind(with: self) { owner, _ in
                        let vc = CommentEditViewController(navTitle: "댓글 수정", classTitleValue: owner.viewModel.className)
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        rightBarButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = CommentEditViewController(navTitle: "댓글 작성", classTitleValue: owner.viewModel.className)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
