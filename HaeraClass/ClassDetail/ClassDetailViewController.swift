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

final class ClassDetailViewController: BaseViewController {

    let disposeBag = DisposeBag()

    let viewModel: ClassDetailViewModel

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.makeCollectionViewLayout())
        collectionView.register(DetailPhotoCell.self, forCellWithReuseIdentifier: DetailPhotoCell.identifier)
        return collectionView
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.backgroundColor = .blue
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nickLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()

    private let classInfoView: ClassInfoView = {
        let view = ClassInfoView()
        return view
    }()

    private let underBarBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let commentButton: CustomButton = {
        let button = CustomButton("댓글보기 (0)")
        return button
    }()

    private let heartButton: UIButton = {
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

    let headLabel: UILabel = {
        let label = UILabel()
        label.text = "클래스 소개"
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    let introTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .darkGray
        textView.font = .systemFont(ofSize: 12)
        textView.text = "테스트"
        textView.isSelectable = false
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false
        return textView
    }()

    init(viewModel: ClassDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupNavigation(viewModel.className)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = true
    }

    override func configureHierarchy() {
        super.configureHierarchy()
        underBarBgView.addSubview(stackView)

        [collectionView, profileImageView, nickLabel, classInfoView, headLabel, introTextView, underBarBgView].forEach { view.addSubview($0) }
    }

    override func configureLayout() {
        super.configureLayout()
        configureStackSubViewLayout()

        collectionView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }

        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.size.equalTo(30)
            make.leading.equalToSuperview().offset(20)
        }

        nickLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }

        classInfoView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(131)
        }

        headLabel.snp.makeConstraints { make in
            make.top.equalTo(classInfoView.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

        introTextView.snp.makeConstraints { make in
            make.top.equalTo(headLabel.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
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

    private func configureDetailView(data: ClassDetail) {
        nickLabel.text = data.creator.nick
        classInfoView.configureInfoView(data: data)
        introTextView.text = data.description
    }

    private func changeButtonState(_ isOn: Bool) {
        if isOn {
            commentButton.isEnabled = true
            commentButton.backgroundColor = ColorSet.lightOrange.color
        } else {
            commentButton.isEnabled = false
            commentButton.backgroundColor = ColorSet.darkGray.color
        }
    }

    private func setupNavigation(_ title: String) {
        navigationItem.title = title
    }
}

extension ClassDetailViewController {
    private func makeCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = .zero
        layout.minimumLineSpacing = .zero
        let deviceWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: deviceWidth, height: deviceWidth * 1.2)
        return layout
    }
}


//MARK: Rx Binding
extension ClassDetailViewController {
    private func bind() {

        let input = ClassDetailViewModel.Input(viewDidLoadTrigger: Observable.just(()), commentButtonTap: commentButton.rx.tap)

        let output = viewModel.transform(input: input)

        output.detailData
            .bind(with: self) { owner, value in
                owner.configureDetailView(data: value)
            }
            .disposed(by: disposeBag)

        output.commentData
            .bind(with: self) { owner, value in
                owner.changeButtonState(value.data.count > 0)
                owner.commentButton.setTitle("댓글보기 (\(value.data.count))", for: .normal)
            }
            .disposed(by: disposeBag)

        output.selectedClassId
            .bind(with: self) { owner, value in
                let viewModel = ClassCommentViewModel(classId: value, className: owner.viewModel.className, commentId: "")
                let vc = ClassCommentViewController(viewModel: viewModel)
                owner.navigationItem.backButtonTitle = ""
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
