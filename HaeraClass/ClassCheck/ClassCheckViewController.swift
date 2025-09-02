//
//  ClassCheckViewController.swift
//  HaeraClass
//
//  Created by Lee on 9/2/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ClassCheckViewController: BaseViewController {

    let disposeBag = DisposeBag()

    let items = Observable.just(ButtonTitle.allCases)

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.makeCollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ClassCategoryCell.self, forCellWithReuseIdentifier: ClassCategoryCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func configureHierarchy() {
        [collectionView].forEach { view.addSubview($0) }
    }

    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(56)
        }
    }

    override func configureView() {
        super.configureView()
    }

    private func bind() {
        items
            .bind(to: collectionView.rx.items(cellIdentifier: ClassCategoryCell.identifier,cellType: ClassCategoryCell.self)) {
                (row, element, cell) in
                cell.configureCell(with: element.title)
                cell.rx.buttonTap
                    .bind(with: self) { owner, _ in
                        cell.changeButtonState()
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}

extension ClassCheckViewController {
    private func makeCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        typealias Collection = CollectionViewFigureSet

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Collection.line.dimension
        layout.minimumInteritemSpacing = Collection.item.dimension
        layout.sectionInset = .init(top: Collection.top.dimension,
                                    left: Collection.left.dimension,
                                    bottom: Collection.bottom.dimension,
                                    right: Collection.right.dimension)
        layout.itemSize = .init(width: 80, height: 36)
        return layout
    }

    enum CollectionViewFigureSet {
        case item
        case line
        case top
        case left
        case bottom
        case right

        var dimension: CGFloat {
            switch self {
            case .item: return 0
            case .line: return 6
            case .top, .bottom, .left, .right: return 10
            }
        }
    }
}

extension ClassCheckViewController {
    enum ButtonTitle: Int, CaseIterable {
        case total
        case develop = 101
        case design = 102
        case foreignLanguage = 201
        case life = 202
        case beauty = 203
        case moneyTech = 301
        case etc = 900

        var title: String {
            switch self {
            case .total: return "전체"
            case .develop: return "개발"
            case .design: return "디자인"
            case .foreignLanguage: return "외국어"
            case .life: return "라이프"
            case .beauty: return "뷰티"
            case .moneyTech: return "재테크"
            case .etc: return "기타"
            }
        }
    }
}

