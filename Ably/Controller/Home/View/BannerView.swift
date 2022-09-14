//
//  BannerView.swift
//  Ably
//
//  Created by 김희진 on 2022/09/02.
//

import UIKit
import RxCocoa
import RxSwift

class BannerView: UICollectionReusableView {
    var timer: Timer?

    var currentIndex = 1
    var imageArray: [Banners] = []
    private let disposeBag = DisposeBag()
    
    private lazy var sliderCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = .zero
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.isPagingEnabled = true
        view.backgroundColor = .white
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        view.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.Id)
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        [sliderCollectionView].forEach{ addSubview($0) }
        sliderCollectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func prepare(banners: [Banners]) {
        imageArray = banners
        if !banners.isEmpty {
            sliderCollectionView.reloadData()
            sliderCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: [.centeredVertically, .centeredHorizontally], animated: false)
        }
    }
    
    func initTimer() {
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(pageValueDidChanged), userInfo: nil, repeats: false)
        
    }
    
    
    func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(pageValueDidChanged), userInfo: nil, repeats: false)
    }

    @objc func pageValueDidChanged() {
        currentIndex += 1
        sliderCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: [.centeredVertically, .centeredHorizontally], animated: true)
        
        resetTimer()
    }
}

extension BannerView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.Id, for: indexPath) as? BannerCollectionViewCell else { return UICollectionViewCell() }

        let data = imageArray[indexPath.row]
        cell.configure(banner: data, totalCount: imageArray.count - 2)        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPosition = scrollView.contentOffset.x / sliderCollectionView.frame.size.width
        let isFirstImage = Int(currentPosition) == imageArray.count - 1
        let isLastImage = currentPosition <= 0
        
        if isFirstImage || isLastImage {
            currentIndex = isLastImage ? imageArray.count - 2 : 1
            sliderCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: [.centeredVertically, .centeredHorizontally], animated: false)
        } else {
            currentIndex = Int(currentPosition)
        }

        resetTimer()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 0
    }
}
