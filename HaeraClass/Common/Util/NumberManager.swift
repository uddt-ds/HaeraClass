//
//  NumberManager.swift
//  HaeraClass
//
//  Created by Lee on 9/6/25.
//

import Foundation

final class NumberManager {

    static let numberfotmatter = NumberFormatter()

    private init() { }

    static func setupNumber(value: Int) -> String {
        numberfotmatter.numberStyle = .decimal
        return numberfotmatter.string(for: value) ?? ""
    }
}
