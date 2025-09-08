//
//  CommentCell.swift
//  HaeraClass
//
//  Created by Lee on 9/5/25.
//

import UIKit
import RxSwift
import RxCocoa

final class CommentCell: BaseTableViewCell, ReusableViewProtocol {

    var disposeBag = DisposeBag()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.backgroundColor = .blue
        return imageView
    }()

    private let nickLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "n분전"
        label.textColor = ColorSet.darkGray.color
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()

    fileprivate let dotButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageSet.ellipsis.image, for: .normal)
        button.tintColor = ColorSet.darkGray.color
        return button
    }()

    private lazy var nickTimeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nickLabel, timeLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var profileNickStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, nickTimeStackView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileNickStackView, dotButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private let bankView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.text = "코멘트코멘트코멘트코멘트코멘트코멘트코멘트코멘트코멘트코멘트코멘트코멘트코멘트코멘트코멘트코멘트코멘트코멘트코멘트코멘트코멘트"
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()

    private lazy var commentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bankView, commentLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var totalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStackView, commentStackView])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func configureHierarchy() {
        super.configureHierarchy()
        [totalStackView, dotButton].forEach { contentView.addSubview($0) }
    }

    override func configureLayout() {
        configureStackSubViewLayout()
        super.configureLayout()
    }

    private func configureStackSubViewLayout() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
        }

        dotButton.snp.makeConstraints { make in
            make.centerY.equalTo(topStackView)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.size.equalTo(36)
        }

        bankView.snp.makeConstraints { make in
            make.width.equalTo(30)
        }

        bankView.setContentHuggingPriority(.defaultLow, for: .horizontal)

        totalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }

    override func configureView() {
        super.configureView()
    }

    func configureCell(_ data: CommentData) {
        profileImageView.kf.setImageWithHeaders(with: data.creator.bindImageUrl)
        nickLabel.text = data.creator.nick
        let relativeTime = DateManager.getRelativeDate(value: data.createdAt)
        timeLabel.text = relativeTime
        commentLabel.text = data.content
    }

    func dotButtonHidden(_ isHidden: Bool) {
        dotButton.isHidden = isHidden
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

extension Reactive where Base: CommentCell {
    var dotButtonTapped: ControlEvent<Void> {
        return base.dotButton.rx.tap
    }
}
