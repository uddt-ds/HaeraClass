//
//  SortButton.swift
//  HaeraClass
//
//  Created by Lee on 9/2/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SortButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("최신순", for: .normal)
        setTitle("금액 높은순", for: .selected)
        titleLabel?.font = .boldSystemFont(ofSize: 12)
        setTitleColor(ColorSet.lightOrange.color, for: .normal)
        setTitleColor(ColorSet.lightOrange.color, for: .selected)
        setImage(.sort, for: .normal)
        semanticContentAttribute = .forceRightToLeft
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
