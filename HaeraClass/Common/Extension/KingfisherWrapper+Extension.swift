//
//  KingfisherWrapper+Extension.swift
//  HaeraClass
//
//  Created by Lee on 9/8/25.
//

import Foundation
import Kingfisher

extension KingfisherWrapper where Base: KFCrossPlatformImageView {
    @MainActor @discardableResult
    func setImageWithHeaders(with resource: Resource?) -> DownloadTask? {
        KingfisherManager.shared.setHeaderes()
        return setImage(
            with: resource,
            placeholder: nil,
            options: nil,
            progressBlock: nil,
            completionHandler: nil)
    }
}
