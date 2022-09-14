//
//  HomeUseCase.swift
//  Ably
//
//  Created by 김희진 on 2022/09/05.
//

import Foundation
import RxSwift
import RxCocoa

class HomeUseCase {
    let disposdBag = DisposeBag()
    let repository = HomeRepository()
    let realmManager = LikeListRealmManager.shared

    func getHomeData() -> Observable<HomeModel> {
        return Observable<HomeModel>.create { emit in
            self.repository.getHomeData().subscribe { event in
                switch event {
                case .success(let data):
                    emit.onNext(data)
                case .failure(let error):
                    emit.onError(error)
                }
            }
        }
    }
    
    func getLikedData(firstId: Int?, lastId: Int?, data: [Goods], _ complete: @escaping ([GoodsViewModel]) -> Void) {
        if let fId = firstId, let lId = lastId {
            self.realmManager.realmFindByRange(firstId: fId, lastId: lId) { savedData in
               let returnData = data.map { data -> GoodsViewModel in
                    if let likedData = savedData.first(where: { $0.id == data.id }) {
                        return GoodsViewModel(value: likedData)
                    } else {
                        return GoodsViewModel(id: data.id, name: data.name, image: data.image, actualPrice: data.actualPrice, price: data.price, isNew: data.isNew, sellCount: data.sellCount, isLike: false, createdAt: Date())
                    }
                }
                complete(returnData)
            }
        } else {
            complete([])
        }
    }
    
    func getMoreGoodData(param: Int) -> Observable<HomeGoodsModel> {
        return Observable<HomeGoodsModel>.create { emit in
            self.repository.getHomeMoreGoods(params: param).subscribe { event in
                switch event {
                case .success(let data):
                    emit.onNext(data)
                case .failure(let error):
                    emit.onError(error)
                }
            }
        }
    }

}
