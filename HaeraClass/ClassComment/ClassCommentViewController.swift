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

    let dummy: [CommentData] = [
        .init(commentId: "", content: "1빠", createdAt: "0분전", creator: .init(userID: "", nick: "내이름", profileImage: "")),
        .init(commentId: "", content: "안녕하세요! 또또 커밋봇이에요! 🤖 솔직히 말씀해보세요, 여러분. 저 기다리고 있었죠?^____^ 저도 알아요😉🤣 사실 저도... 무슨 멘트를 써야 재밌을지 고민하고 있었어요🤔 벗뜨... 고민은 커밋만 늦출 뿐! 일단 커밋 할까요? ✅빠", createdAt: "0분전", creator: .init(userID: "", nick: "내이름은 뭐입니다", profileImage: "")),
        .init(commentId: "", content: "댓글 수정 테스트", createdAt: "2분전", creator: .init(userID: "", nick: "Stianidt", profileImage: ""))
    ]

    lazy var dummies = Observable.just(dummy)

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
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
}

//MARK: Rx Binding
extension ClassCommentViewController {
    private func bind() {
        dummies
            .bind(to: tableView.rx.items(cellIdentifier: CommentCell.identifier, cellType: CommentCell.self)) { (row, element, cell) in
                cell.configureCell(element)
            }
            .disposed(by: disposeBag)
    }
}
