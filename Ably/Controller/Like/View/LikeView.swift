//
//  LikeView.swift
//  Ably
//
//  Created by 김희진 on 2022/09/04.
//

import Foundation
import UIKit

class LikeView {
    
    func makeCollectionView() -> UICollectionView {
        let likeCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0

            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.Id)
            collectionView.backgroundColor = .white
            return collectionView
        }()
        return likeCollectionView
    }
    
    func makeEmptyLabel() -> UILabel {
        let emptyLabel: UILabel = {
            let label = UILabel()
            label.text = "좋아요한 상품이 없습니다"
            label.font = .systemFont(ofSize: 15)
            return label
        }()
        return emptyLabel
    }
    
}
