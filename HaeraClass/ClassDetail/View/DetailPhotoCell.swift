//
//  DetailPhotoCell.swift
//  HaeraClass
//
//  Created by Lee on 9/3/25.
//

import UIKit
import SnapKit
import Kingfisher

final class DetailPhotoCell: BaseCollectionViewCell, ReusableViewProtocol {

    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.addSubview(photoImageView)
    }

    override func configureLayout() {
        super.configureLayout()
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func configureView() {
        super.configureView()
    }

    func configureCell(with data: String) {
        guard let url = URL(string: BaseURL.url + "/v1" + data) else { return }
        photoImageView.kf.setImageWithHeaders(with: url)
    }
}
