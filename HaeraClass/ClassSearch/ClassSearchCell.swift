//  ClassSearchCell.swift
//  HaeraClass
//
//  Created by Lee on 9/2/25.
//

import UIKit
import SnapKit

final class ClassSearchCell: BaseTableViewCell, ReusableViewProtocol {

    private let classImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
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

    private let headTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    // TODO: AttributedString 취소선으로 변경
    private let rawPrice: UILabel = {
        let label = UILabel()
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

    private let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(.likeButton, for: .normal)
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
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    override func configureView() {
        super.configureView()
    }

    func configureCell(with data: Dummy) {
        classImageView.image = data.image
        headTitleLabel.text = data.header
        categoryTag.setTitle(data.category, for: .normal)
        rawPrice.text = data.price
        price.text = data.salePrice
        percentLabel.text = data.persent
    }
}

