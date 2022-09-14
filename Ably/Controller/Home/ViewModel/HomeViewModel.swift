//
//  HomeViewModel.swift
//  Ably
//
//  Created by 김희진 on 2022/09/03.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {

    let disposeBag = DisposeBag()
    let useCase = HomeUseCase()

    let responseData = BehaviorRelay<HomeModel?>(value: nil)
    
    var bannerData = BehaviorRelay<[Banners]>(value: [])
    var goodsData = BehaviorRelay<[GoodsViewModel]>(value: [])
    
    var isLoading = false
    var isFinish = false

    init() {
        populateData()
    }
        
    func populateData(){
        
        useCase.getHomeData()
            .subscribe(onNext: { data in
                self.useCase.getLikedData(firstId: data.goods.first?.id, lastId: data.goods.last?.id, data: data.goods) { returnData in
                    self.goodsData.accept(returnData)

                    if !data.banners.isEmpty {
                        let baner = data.banners
                        var newBannerArray = baner
                        newBannerArray.insert(baner[baner.count-1], at: 0)
                        newBannerArray.append(baner[0])
                        self.bannerData.accept(newBannerArray)
                    } else {
                        self.bannerData.accept(data.banners)
                    }
                }
            })
        .disposed(by: disposeBag)
    }
    
    func fetchMoreData(_ complete: @escaping ([IndexPath]) -> Void) {
    
        let lastItemId = goodsData.value.last?.id ?? -1
        
        useCase.getMoreGoodData(param: lastItemId)
            .subscribe(onNext: { data in
                
                if data.goods.isEmpty {
                    self.isLoading = false
                    self.isFinish = true
                    complete([])
                } else {
                    self.useCase.getLikedData(firstId: data.goods.first?.id, lastId: data.goods.last?.id, data: data.goods) { returnData in
                        
                        var beforedata = self.goodsData.value
                        var updateIndexPath: [IndexPath] = []

                        for (index,value) in returnData.enumerated() {
                            beforedata.append(value)
                            updateIndexPath.append(IndexPath(row: lastItemId + index, section: 0))
                        }
                        self.goodsData.accept(beforedata)
                        self.isLoading = false

                        complete(updateIndexPath)
                    }
                }
            })
        .disposed(by: disposeBag)
    }
}

