//
//  Int+Extension.swift
//  HaeraClass
//
//  Created by Lee on 9/6/25.
//

import Foundation

extension Int {
    var demical: String {
        return NumberManager.setupNumber(value: self)
    }
}
