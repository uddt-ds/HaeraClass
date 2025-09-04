//
//  ClassIntroCell.swift
//  HaeraClass
//
//  Created by Lee on 9/3/25.
//

import UIKit
import SnapKit

final class ClassIntroCell: BaseTableViewCell, ReusableViewProtocol {

    let headLabel: UILabel = {
        let label = UILabel()
        label.text = "클래스 소개"
        label.textColor = ColorSet.darkGray.color
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()

    let introTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = ColorSet.darkGray.color
        textView.text = "테스트"
        textView.isEditable = false
        return textView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func configureHierarchy() {
        super.configureHierarchy()
        [headLabel, introTextView].forEach { contentView.addSubview($0) }
    }

    override func configureLayout() {
        super.configureLayout()
        headLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }

        introTextView.snp.makeConstraints { make in
            make.top.equalTo(headLabel.snp.bottom).offset(20)
            make.directionalHorizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
    }

    override func configureView() {
        super.configureView()
    }
}
