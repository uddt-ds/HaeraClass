//
//  ClassCategoryTableViewCell.swift
//  HaeraClass
//
//  Created by Lee on 9/2/25.
//

import UIKit
import SnapKit

final class ClassCategoryTableViewCell: BaseTableViewCell, ReusableViewProtocol {

    private let classImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = .noProfile
        return imageView
    }()

    private let heartButton: UIButton = {
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

    private let blankView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var headStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headTitleLabel, categoryTag, blankView])
        stack.axis = .horizontal
        stack.spacing = 8
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
            make.directionalHorizontalEdges.equalTo(classImageView)
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
    }

    private func configureStackSubViewLayout() {
        categoryTag.snp.makeConstraints { make in
            make.height.equalTo(16)
        }

        blankView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        priceBlankView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
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
