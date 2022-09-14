//
//  HomeView.swift
//  Ably
//
//  Created by 김희진 on 2022/09/03.
//

import Foundation
import UIKit

class HomeView {
    
    func makeCollectionView() -> UICollectionView {

        let contentCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0

            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.Id)
            collectionView.backgroundColor = .white
            collectionView.register(BannerView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BannerView.Id)
            collectionView.register(LoadingView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingView.Id)
            
            return collectionView
        }()
        
        return contentCollectionView
    }
    
}
