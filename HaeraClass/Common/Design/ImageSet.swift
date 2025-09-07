//
//  ImageSet.swift
//  HaeraClass
//
//  Created by Lee on 9/2/25.
//

import UIKit

enum ImageSet: String {
    case xmark
    case ellipsis
    case house = "house.fill"
    case magnifyingglass
    case person = "person.fill"

    var image: UIImage {
        return UIImage(systemName: self.rawValue) ?? UIImage()
    }
}
