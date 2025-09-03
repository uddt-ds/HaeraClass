//
//  ViewModelProtocol.swift
//  HaeraClass
//
//  Created by Lee on 9/3/25.
//

import Foundation

protocol ViewModelProtocol {

    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
