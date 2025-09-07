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

    let disposeBag = DisposeBag()

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

    fileprivate let heartButton: UIButton = {
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

    func updateHeartButton() {
        heartButton.isSelected.toggle()
        if heartButton.isSelected {
            heartButton.setImage(.likeButtonFill, for: .normal)
        } else {
            heartButton.setImage(.likeButton, for: .normal)
        }
        print(heartButton.isSelected)
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
        rawPrice.text = data.bindPrice
        price.text = data.bindSalePrice
        percentLabel.text = data.persent

        if data.bindSalePrice == "무료" {
            rawPrice.isHidden = true
        } else {
            rawPrice.isHidden = false
        }

        heartButton.isSelected = data.isLiked
        //하트 버튼을 눌렀을 때, UI는 기본적으로 변하게 하기
        //하트 버튼을 눌렀을 때 서버와 통신해서 Boolean 값 변경하기
        //String message는 별도로 처리해야하는데 하나씩 순서대로 처리
    }
}

extension Reactive where Base: ClassSearchCell {
    var heartButtonTap: Observable<Bool> {
        return base.heartButton.rx.tap
            .map {
                print("현재 상태: ", base.heartButton.isSelected)
                return base.heartButton.isSelected
            }
    }
}

