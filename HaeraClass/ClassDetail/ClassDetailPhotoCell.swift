//
//  ClassDetailPhotoCell.swift
//  HaeraClass
//
//  Created by Lee on 9/3/25.
//

import UIKit

final class ClassDetailPhotoCell: BaseTableViewCell, ReusableViewProtocol {

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.makeCollectionViewLayout())
        collectionView.register(DetailPhotoCell.self, forCellWithReuseIdentifier: DetailPhotoCell.identifier)
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.addSubview(collectionView)
    }

    override func configureLayout() {
        super.configureLayout()
    }

    override func configureView() {
        super.configureView()
    }

    private func makeCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = .zero
        layout.minimumLineSpacing = .zero
        let deviceWidth = UIScreen.main.bounds.width
        layout.itemSize = .init(width: deviceWidth, height: deviceWidth * 1.2)
        return layout
    }
}
