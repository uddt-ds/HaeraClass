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

    var viewModel: ClassCommentViewModel

    let deleteTapped = PublishRelay<Void>()

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
        setupNavigation(viewModel.classData.className)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name("commentPop"), object: nil)
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

        let input = ClassCommentViewModel.Input(viewDidLoadTrigger: .just(()), deleteTapped: deleteTapped)

        let output = viewModel.transform(input: input)

        output.commentData
            .bind(to: tableView.rx.items(cellIdentifier: CommentCell.identifier, cellType: CommentCell.self)) { (row, element, cell) in
                cell.configureCell(element)

                cell.dotButtonHidden(!(output.currentUserId.value == element.creator.userID))

                cell.rx.dotButtonTapped
                    .debug()
                    .bind(with: self) { owner, _ in
                        AlertManager.shared.makeActionSheet { [weak self] in
                            guard let self else { return }
                            let data = self.viewModel.classData
                            let viewModel = CommentEditViewModel(
                                navTitle: "댓글 수정",
                                classTitleValue: data.className,
                                classId: data.classId,
                                category: data.category,
                                commentID: element.commentId,
                                content: element.content)
                            let vc = CommentEditViewController(viewModel: viewModel)
                            self.navigationController?.pushViewController(vc, animated: true)
                        } deleteHanlder: { [weak self] in
                            guard let self else { return }
                            self.viewModel.classData.commentId = element.commentId
                            deleteTapped.accept(())
                        }
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        rightBarButton.rx.tap
            .bind(with: self) { owner, _ in
                let data = owner.viewModel.classData
                let viewModel = CommentEditViewModel(navTitle: "댓글 작성",
                                                     classTitleValue: data.className,
                                                     classId: data.classId,
                                                     category: data.category)
                let vc = CommentEditViewController(viewModel: viewModel)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

        output.errorMessage
            .bind(with: self) { owner, value in
                AlertManager.shared.showBasicAlert(value)
            }
            .disposed(by: disposeBag)
    }
}
