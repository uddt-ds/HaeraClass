//
//  ClassCategoryTableViewCell.swift
//  HaeraClass
//
//  Created by Lee on 9/2/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class ClassCategoryTableViewCell: BaseTableViewCell, ReusableViewProtocol {

    var disposeBag = DisposeBag()

    private let classImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()

    fileprivate let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(.likeButton, for: .normal)
        button.setImage(.likeButtonFill, for: .selected)
        return button
    }()

    private let headTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

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

    private lazy var headStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headTitleLabel, categoryTag])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()

    private let contentTitle: UILabel = {
        let label = UILabel()
        label.text = "콘텐츠 테스트"
        label.textColor = ColorSet.lightGray.color
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()

    private let cancelLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorSet.lightGray.color
        return view
    }()

    private lazy var rawPrice: UILabel = {
        let label = UILabel()
        label.addSubview(cancelLineView)
        label.text = "원가"
        label.textColor = ColorSet.lightGray.color
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    private let price: UILabel = {
        let label = UILabel()
        label.text = "정가"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    private let percentLabel: UILabel = {
        let label = UILabel()
        label.text = "정가"
        label.textColor = ColorSet.orange.color
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    private let priceBlankView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var priceStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [rawPrice, price, percentLabel, priceBlankView])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func configureHierarchy() {
        [classImageView, heartButton, headStackView, contentTitle, priceStackView].forEach { contentView.addSubview($0) }
    }

    override func configureLayout() {
        configureStackSubViewLayout()

        classImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }

        heartButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.equalTo(classImageView.snp.top).offset(16)
            make.trailing.equalTo(classImageView.snp.trailing).offset(-16)
        }

        headStackView.snp.makeConstraints { make in
            make.top.equalTo(classImageView.snp.bottom).offset(12)
            make.height.equalTo(20)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.trailing.lessThanOrEqualToSuperview().inset(20)
        }

        contentTitle.snp.makeConstraints { make in
            make.top.equalTo(headStackView.snp.bottom).offset(12)
            make.directionalHorizontalEdges.equalTo(classImageView)
        }

        priceStackView.snp.makeConstraints { make in
            make.top.equalTo(contentTitle.snp.bottom).offset(12)
            make.directionalHorizontalEdges.equalTo(classImageView)
            make.bottom.equalToSuperview().inset(12)
        }

        cancelLineView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo(2)
        }
    }

    private func configureStackSubViewLayout() {
        categoryTag.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.width.equalTo(30)
        }

        headTitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        priceBlankView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    override func configureView() {
        super.configureView()
    }

    func configureCell(with data: Data) {
        guard let headerKey = Bundle.main.object(forInfoDictionaryKey: "SesacKey") as? String else { return }

        let modifier = AnyModifier { request in
            var header = request
            header.setValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "Authorization")
            header.setValue(headerKey, forHTTPHeaderField: "SesacKey")
            return header
        }

        classImageView.kf.setImage(with: data.bindImageUrl,
                                   options: [
                                    .requestModifier(modifier)
                                   ]
        )
        headTitleLabel.text = data.title
        categoryTag.setTitle(data.categoryTitle, for: .normal)
        contentTitle.text = data.description
        rawPrice.text = data.bindPrice
        price.text = data.bindSalePrice
        percentLabel.text = data.persent

        heartButton.isSelected = data.isLiked
        
        if data.bindSalePrice == "무료" {
            rawPrice.isHidden = true
            price.textColor = ColorSet.orange.color
        } else {
            rawPrice.isHidden = false
            price.textColor = .black
        }
    }

    func updateHeartButton() {
        if heartButton.isSelected {
            heartButton.setImage(.likeButtonFill, for: .normal)
        } else {
            heartButton.setImage(.likeButton, for: .normal)
        }
        print(heartButton.isSelected)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

extension Reactive where Base: ClassCategoryTableViewCell {
    var heartButtonTap: Observable<Bool> {
        return base.heartButton.rx.tap
            .map {
                base.heartButton.isSelected.toggle()
                return base.heartButton.isSelected
            }
    }
}

