//
//  ReusableViewProtocol.swift
//  HaeraClass
//
//  Created by Lee on 9/2/25.
//

import Foundation

protocol ReusableViewProtocol {
    static var identifier: String { get }
}

extension ReusableViewProtocol {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
