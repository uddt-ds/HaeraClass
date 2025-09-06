//
//  CommentEdit.swift
//  HaeraClass
//
//  Created by Lee on 9/5/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CommentEditViewController: BaseViewController {

    let placeHolder = "댓글을 작성해주세요"
    let disposeBag = DisposeBag()

    let viewModel: CommentEditViewModel

    init(viewModel: CommentEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    private let categoryTag: UIButton = {
        let button = UIButton()
        button.setTitle("테스트", for: .normal)
        button.setTitleColor(ColorSet.lightOrange.color, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 10)
        button.layer.borderColor = ColorSet.lightOrange.color.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.isUserInteractionEnabled = false
        return button
    }()

    private let classTitle: UILabel = {
        let label = UILabel()
        label.text = "테스트"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    private lazy var textView: UITextView = {
        let txtView = UITextView()
        txtView.font = .systemFont(ofSize: 14)
        txtView.textContainerInset = .init(top: 20, left: 20, bottom: 20, right: 20)
        txtView.layer.cornerRadius = 10
        txtView.layer.borderWidth = 1
        txtView.text = placeHolder
        txtView.textColor = ColorSet.lightGray.color
        txtView.layer.borderColor = ColorSet.lightGray.color.cgColor
        txtView.delegate = self
        return txtView
    }()

    private let stringCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorSet.darkGray.color
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageSet.xmark.image, for: .normal)
        button.tintColor = .black
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupNav()
        setInitialText()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name("isPop"), object: nil)
    }

    override func configureHierarchy() {
        super.configureHierarchy()
        [categoryTag, classTitle, textView, stringCountLabel].forEach { view.addSubview($0) }
    }

    override func configureLayout() {
        super.configureLayout()

        categoryTag.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(16)
            make.width.equalTo(30)
        }

        classTitle.snp.makeConstraints { make in
            make.top.equalTo(categoryTag.snp.bottom).offset(12)
            make.leading.equalTo(categoryTag)
        }

        textView.snp.makeConstraints { make in
            make.top.equalTo(classTitle.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(200)
        }

        stringCountLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(12)
            make.trailing.equalTo(textView.snp.trailing)
        }
    }

    override func configureView() {
        super.configureView()
    }

    private func setupNav() {
        navigationItem.title = viewModel.navTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
    }

    func updateButton(isEnable: Bool) {
        if isEnable {
            saveButton.setTitleColor(.black, for: .normal)
        } else {
            saveButton.setTitleColor(ColorSet.lightGray.color, for: .normal)
        }
    }

    //TODO: ViewModel로 보내서 처리할지 고민
    private func setInitialText() {
        if let text = viewModel.content {
            textView.text = text
            textView.textColor = .darkGray
        }
    }
}

//MARK: Rx Binding
extension CommentEditViewController: UIScrollViewDelegate {
    private func bind() {
        
        let input = CommentEditViewModel.Input(textField: textView.rx.text.orEmpty, saveButtonTap: saveButton.rx.tap)

        let output = viewModel.transform(input: input)

        output.textColor
            .bind(with: self) { owner, value in
                if value == "red" {
                    owner.stringCountLabel.textColor = .red
                } else {
                    owner.stringCountLabel.textColor = .black
                }
            }
            .disposed(by: disposeBag)

        output.textCount
            .bind(to: stringCountLabel.rx.text)
            .disposed(by: disposeBag)

        output.saveButtonState
            .bind(with: self) { owner, value in
                owner.saveButton.isEnabled = value
                owner.updateButton(isEnable: value)
            }
            .disposed(by: disposeBag)

        output.isSaved
            .bind(with: self) { owner, value in
                if value {
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)

        closeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension CommentEditViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolder {
            textView.text = nil
            textView.textColor = .darkGray
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeHolder
            textView.textColor = ColorSet.lightGray.color
        }
    }
}
