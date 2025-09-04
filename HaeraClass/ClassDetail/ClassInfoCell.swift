//
//  ClassInfoCell.swift
//  HaeraClass
//
//  Created by Lee on 9/3/25.
//

import UIKit
import SnapKit

final class ClassInfoCell: BaseTableViewCell, ReusableViewProtocol {

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
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

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = ClassInfoTitle.place.rawValue
        label.textColor = ColorSet.lightGray.color
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = ClassInfoTitle.time.rawValue
        label.textColor = ColorSet.lightGray.color
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    private let peopleLabel: UILabel = {
        let label = UILabel()
        label.text = ClassInfoTitle.people.rawValue
        label.textColor = ColorSet.lightGray.color
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    private let locationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .location
        return imageView
    }()

    private let locationDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트"
        label.textColor = ColorSet.lightGray.color
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    private lazy var locationStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [locationImage, locationDetailLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()

    let timeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .time
        return imageView
    }()

    let timeDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트"
        label.textColor = ColorSet.lightGray.color
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    private lazy var timeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [timeImage, timeDetailLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()

    let peopleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .people
        return imageView
    }()

    let peopleDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트"
        label.textColor = ColorSet.lightGray.color
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    private lazy var peopleStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [peopleImage, peopleDetailLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()

    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = ColorSet.lightGray.color.cgColor
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }


    override func configureHierarchy() {
        super.configureHierarchy()

        [profileImageView, nickLabel, bgView].forEach { contentView.addSubview($0) }

        [locationLabel, locationStackView, timeLabel, timeStackView, peopleLabel, peopleStackView]
            .forEach { bgView.addSubview($0) }

    }

    override func configureLayout() {
        super.configureLayout()
        configureStackSubViewLayout()

        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.size.equalTo(30)
        }

        nickLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }

        bgView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.directionalHorizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }

        locationLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(30)
        }

        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(20)
            make.leading.equalTo(locationLabel.snp.leading)
        }

        peopleLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
            make.leading.equalTo(locationLabel.snp.leading)
        }

        locationStackView.snp.makeConstraints { make in
            make.centerY.equalTo(locationLabel)
            make.leading.equalTo(locationLabel.snp.trailing).offset(20)
        }

        timeStackView.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.leading.equalTo(locationLabel.snp.trailing).offset(20)
        }

        peopleStackView.snp.makeConstraints { make in
            make.centerY.equalTo(peopleLabel)
            make.leading.equalTo(locationLabel.snp.trailing).offset(20)
        }
    }

    override func configureView() {
        super.configureView()
    }

    private func configureStackSubViewLayout() {
        [locationImage, timeImage, peopleImage].forEach {
            $0.snp.makeConstraints { make in
                make.size.equalTo(16)
            }
        }
    }
}

extension ClassInfoCell {
    enum ClassInfoTitle: String {
        case place = "장소"
        case time = "시간"
        case people = "인원"
    }
}
