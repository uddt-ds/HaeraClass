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

final class ClassCategoryCell: UICollectionViewCell, ReusableViewProtocol {

    let disposeBag = DisposeBag()

    fileprivate let button: UIButton = {
        let button = UIButton()
        button.setTitle("테스트", for: .normal)
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
        configureHierarchy()
        configureLayout()
        configureView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureHierarchy() {
        [button].forEach { contentView.addSubview($0) }
    }

    private func configureLayout() {
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func configureView() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }

    func configureCell(with data: String) {
        button.setTitle(data, for: .normal)
    }

    func changeButtonState() {
        button.isSelected.toggle()

        if button.isSelected {
            button.layer.borderColor = ColorSet.lightOrange.color.cgColor
        } else {
            button.layer.borderColor = ColorSet.lightGray.color.cgColor
        }
    }

}
//
//extension Reactive where Base: ClassCategoryCell {
//    var buttonTap: ControlEvent<Void> {
//        return base.button.rx.tap
//    }
//}
