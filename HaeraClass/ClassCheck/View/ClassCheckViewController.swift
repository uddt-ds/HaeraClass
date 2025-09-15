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
import Toast

final class ClassCheckViewController: BaseViewController {

    let disposeBag = DisposeBag()

    let viewModel = ClassCheckViewModel()
    let heartButtonTap = PublishSubject<(String, Bool)>()

//    private lazy var likeViewModel = LikeViewModel(heartButtonTapped: heartButtonTap)
    private let likeViewModel = LikeViewModel()

    let viewWillAppearTrigger = PublishSubject<Void>()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.makeCollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ClassCategoryCell.self, forCellWithReuseIdentifier: ClassCategoryCell.identifier)
        return collectionView
    }()

    private let totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    private let sortButton: SortButton = {
        let button = SortButton()
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [totalLabel, sortButton])
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        return stack
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ClassCategoryTableViewCell.self, forCellReuseIdentifier: ClassCategoryTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false

        viewWillAppearTrigger.onNext(())
    }

    override func configureHierarchy() {
        super.configureHierarchy()
        [collectionView, stackView, tableView].forEach { view.addSubview($0) }
    }

    override func configureLayout() {
        stackSubViewLayout()

        collectionView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(56)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.directionalHorizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func stackSubViewLayout() {
        sortButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }

    override func configureView() {
        super.configureView()
    }
}

// MARK: Rx Binding
extension ClassCheckViewController {
    private func bind() {

        let buttonState = BehaviorRelay(value: false)

        let selectedCategory = BehaviorRelay(value: 0)

        let input = ClassCheckViewModel.Input(viewWillAppearTrigger: viewWillAppearTrigger,
                                              selectedCategory: selectedCategory,
                                              currentButtonState: buttonState,
                                              sortButtonTap: sortButton.rx.tap)

        let likeInput = LikeViewModel.Input(heartButtonTapped: heartButtonTap)

        let output = viewModel.transform(input: input)
        let likeOutput = likeViewModel.transform(input: likeInput)

        output.selectedData
            .bind(to: tableView.rx.items(cellIdentifier: ClassCategoryTableViewCell.identifier, cellType:ClassCategoryTableViewCell.self)) { (row, element, cell) in
                cell.configureCell(with: element)
                cell.rx.heartButtonIsSelected
                    .map { value in
                        let changeButtonState = value
                        cell.updateHeartButton()
                        return (element.classId, changeButtonState)
                    }
                    .bind(with: self) { owner, value in
                        owner.heartButtonTap.onNext(value)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        output.totalCount
            .bind(to: totalLabel.rx.text)
            .disposed(by: disposeBag)

        output.buttonItems
            .bind(to: collectionView.rx.items(cellIdentifier: ClassCategoryCell.identifier, cellType: ClassCategoryCell.self)) {
                (row, element, cell) in

                cell.configureCell(with: element.title, tag: element.rawValue)

                output.selectedCategories
                    .map { $0.contains(element.rawValue) }
                    .bind(to: cell.rx.isSelected)
                    .disposed(by: cell.disposeBag)

                cell.rx.buttonTag
                    .bind(with: self) { owner, value in
                        selectedCategory.accept(value)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        sortButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.sortButton.isSelected.toggle()
                buttonState.accept(owner.sortButton.isSelected)
            }
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(ClassCheck.self)
            .bind(with: self) { owner, data in
                let viewModel = ClassDetailViewModel(
                    classData: .init(classId: data.classId,
                                     className: data.title,
                                     commentId: data.creator.userID,
                                     category: data.category)
                )
                let vc = ClassDetailViewController(viewModel: viewModel)
                owner.navigationItem.backButtonTitle = ""
                owner.navigationController?.navigationBar.tintColor = .black
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

        output.scrollGoToTopTrigger
            .withLatestFrom(tableView.rx.contentOffset)
            .bind(with: self) { owner, value in
                if value.y != 0 {
                    DispatchQueue.main.async {
                        owner.tableView.setContentOffset(.init(x: 0, y: 0), animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)

        likeOutput.saveResult
            .bind(with: self) { owner, value in
                owner.view.makeToast(value, duration: 1.5, position: .bottom)
            }
            .disposed(by: disposeBag)

        likeOutput.errorMessage
            .bind(with: self) { owner, value in
                AlertManager.shared.showBasicAlert(value)
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

