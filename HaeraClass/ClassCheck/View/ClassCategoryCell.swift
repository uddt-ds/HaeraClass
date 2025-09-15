//
//  ClassCheckCell.swift
//  HaeraClass
//
//  Created by Lee on 9/2/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ClassCategoryCell: BaseCollectionViewCell, ReusableViewProtocol {

    var disposeBag = DisposeBag()

    fileprivate let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorSet.lightGray.color, for: .normal)
        button.setTitleColor(ColorSet.lightOrange.color, for: .selected)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.layer.borderWidth = 2
        button.layer.borderColor = ColorSet.lightGray.color.cgColor
        button.layer.cornerRadius = 14
        button.backgroundColor = .white
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func configureHierarchy() {
        super.configureHierarchy()
        [button].forEach { contentView.addSubview($0) }
    }

    override func configureLayout() {
        super.configureLayout()
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func configureView() {
        super.configureView()
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }

    func configureCell(with data: String, tag: Int) {
        button.setTitle(data, for: .normal)
        button.tag = tag
        button.isSelected = isSelected
    }

    func setupButton(isSelected: Bool) {
        button.isSelected = isSelected
        button.layer.borderColor = button.isSelected ? ColorSet.lightOrange.color.cgColor : ColorSet.lightGray.color.cgColor
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

}

extension Reactive where Base: ClassCategoryCell {
    var buttonTag: Observable<Int> {
        return base.button.rx.tap
            .map { base.button.tag }
    }

    var isSelected: Binder<Bool> {
        return .init(base) { cell, isSelected in
            cell.setupButton(isSelected: isSelected)
        }
    }
}
