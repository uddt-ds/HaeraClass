//
//  BaseTableViewCell.swift
//  HaeraClass
//
//  Created by Lee on 9/2/25.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
