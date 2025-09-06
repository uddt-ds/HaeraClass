//
//  BaseTableViewCell.swift
//  HaeraClass
//
//  Created by Lee on 9/2/25.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {

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

    func configureHierarchy() {

    }

    func configureLayout() {

    }

    func configureView() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }

}
