//  ClassSearchCell.swift
//  HaeraClass
//
//  Created by Lee on 9/2/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

final class ClassSearchCell: BaseTableViewCell, ReusableViewProtocol {

    var disposeBag = DisposeBag()

    private let classImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private let categoryTag: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorSet.lightOrange.color, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 10)
        button.layer.borderColor = ColorSet.lightOrange.color.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.isUserInteractionEnabled = false
        return button
    }()

    private let headTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
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
        label.textColor = ColorSet.lightGray.color
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    private let price: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    private let percentLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorSet.orange.color
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    fileprivate let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(.likeButton.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.setImage(.likeButtonFill, for: .selected)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func configureHierarchy() {
        [classImageView, categoryTag, headTitleLabel, rawPrice, price, percentLabel, heartButton].forEach { contentView.addSubview($0) }
    }

    override func configureLayout() {
        classImageView.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(100)
            make.top.leading.bottom.equalToSuperview().inset(20)
        }

        categoryTag.snp.makeConstraints { make in
            make.top.equalTo(classImageView)
            make.leading.equalTo(classImageView.snp.trailing).offset(20)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(36)
        }

        headTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryTag.snp.bottom).offset(4)
            make.leading.equalTo(categoryTag)
            make.trailing.equalToSuperview().inset(40)
        }

        rawPrice.snp.makeConstraints { make in
            make.top.equalTo(headTitleLabel.snp.bottom).offset(16)
            make.leading.equalTo(categoryTag)
        }

        price.snp.makeConstraints { make in
            make.top.equalTo(rawPrice.snp.bottom).offset(4)
            make.leading.equalTo(categoryTag)
        }

        percentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(price)
            make.leading.equalTo(price.snp.trailing).offset(12)
        }

        heartButton.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }

        cancelLineView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo(2)
        }
    }

    override func configureView() {
        super.configureView()
    }

    func updateHeartButton() {
        if heartButton.isSelected {
            heartButton.setImage(.likeButtonFill, for: .normal)
        } else {
            heartButton.setImage(.likeButton.withRenderingMode(.alwaysTemplate), for: .normal)
            heartButton.tintColor = .gray
        }
    }


    func configureCell(with data: Data) {

        classImageView.kf.setImageWithHeaders(with: data.bindImageUrl)
        headTitleLabel.text = data.title
        categoryTag.setTitle(data.categoryTitle, for: .normal)
        rawPrice.text = data.bindPrice
        price.text = data.bindSalePrice
        percentLabel.text = data.persent

        if data.bindSalePrice == "무료" {
            rawPrice.isHidden = true
            price.textColor = ColorSet.orange.color
        } else {
            rawPrice.isHidden = false
            price.textColor = .black
        }

        heartButton.isSelected = data.isLiked
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

extension Reactive where Base: ClassSearchCell {
    var heartButtonTap: Observable<Bool> {
        return base.heartButton.rx.tap
            .map {
                base.heartButton.isSelected.toggle()
                return base.heartButton.isSelected
            }
    }
}

