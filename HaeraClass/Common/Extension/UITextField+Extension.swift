//
//  UITextField+Extension.swift
//  HaeraClass
//
//  Created by Lee on 9/2/25.
//

import UIKit

extension UITextField {
    func setField(placeHolder: String, borderColor: CGColor, borderWidth: CGFloat, radius: CGFloat) {
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        leftViewMode = .always
        placeholder = placeHolder
        font = .systemFont(ofSize: 12)
        textColor = .black
        layer.borderColor = borderColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = radius
    }
}
