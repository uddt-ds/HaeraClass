//
//  CustomButton.swift
//  HaeraClass
//
//  Created by Lee on 9/2/25.
//

import UIKit

final class OrangePointButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(_ buttonTitle: String) {
        super.init(frame: .zero)
        setTitle(buttonTitle, for: .normal)
        configureButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureButton() {
        if isEnabled {
            backgroundColor = ColorSet.lightOrange.color
        } else {
            backgroundColor = ColorSet.darkGray.color
        }
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 14)
        layer.cornerRadius = 10
        clipsToBounds = true
    }

}
