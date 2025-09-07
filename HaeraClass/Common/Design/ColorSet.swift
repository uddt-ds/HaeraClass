//
//  ColorSet.swift
//  HaeraClass
//
//  Created by Lee on 9/2/25.
//

import UIKit

enum ColorSet {
    case lightOrange
    case orange
    case lightGray
    case darkNavy
    case darkGray

    var color: UIColor {
        switch self {
        case .lightOrange: return .init(hexCode: "FFA979", alpha: 1.0)
        case .orange: return .init(hexCode: "FF6E1D", alpha: 1.0)
        case .lightGray: return .init(hexCode: "D0D0D0", alpha: 1.0)
        case .darkNavy: return .init(hexCode: "334155", alpha: 1.0)
        case .darkGray: return .init(hexCode: "ABABAE", alpha: 1.0)
        }
    }
}
