//
//  KingFisherManager.swift
//  HaeraClass
//
//  Created by Lee on 9/8/25.
//

import Foundation
import Kingfisher

extension KingfisherManager {
    func setHeaderes() {
        guard let headerKey = Bundle.main.object(forInfoDictionaryKey: "SesacKey") as? String else { return }

        let modifier = AnyModifier { request in
            var header = request
            header.setValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "Authorization")
            header.setValue(headerKey, forHTTPHeaderField: "SesacKey")
            return header
        }

        KingfisherManager.shared.defaultOptions = [
            .requestModifier(modifier)
        ]
    }
}
