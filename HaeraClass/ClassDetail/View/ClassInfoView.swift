//
//  ClassInfoView.swift
//  HaeraClass
//
//  Created by Lee on 9/4/25.
//

import UIKit

final class ClassInfoView: UIView {

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

    private let timeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .time
        return imageView
    }()

    private let timeDetailLabel: UILabel = {
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

    private let peopleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .people
        return imageView
    }()

    private let peopleDetailLabel: UILabel = {
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureHierarchy() {
        [locationLabel, locationStackView, timeLabel, timeStackView, peopleLabel, peopleStackView]
            .forEach { self.addSubview($0) }
    }

    private func configureLayout() {
        configureStackSubViewLayout()

        locationLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
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

    private func configureStackSubViewLayout() {
        [locationImage, timeImage, peopleImage].forEach {
            $0.snp.makeConstraints { make in
                make.size.equalTo(16)
            }
        }
    }

    private func configureView() {
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1
        self.layer.borderColor = ColorSet.darkGray.color.cgColor
        self.clipsToBounds = true
    }

    func configureInfoView(data: ClassDetail) {
        let date = DateManager.setupDate(value: data.date)

        locationDetailLabel.text = data.location
        timeDetailLabel.text = date
        peopleDetailLabel.text = data.capacity
    }
}

extension ClassInfoView {
    enum ClassInfoTitle: String {
        case place = "장소"
        case time = "시간"
        case people = "인원"
    }
}
