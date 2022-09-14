//
//  HomeRepository.swift
//  Ably
//
//  Created by 김희진 on 2022/09/05.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class HomeRepository {
    
    let disposdBag = DisposeBag()
    private let homeProvider = MoyaProvider<HomeSerice>()
    
    func getHomeData() -> Single<HomeModel> {
        return Single<HomeModel>.create { single in
            self.homeProvider.request(.home) { result in
                switch result {
                case let .success(response):
                    let result = try? response.map(HomeModel.self)
                    guard let result = result else { return }
                    return single(.success(result))
                 case let .failure(error):
                    print(error.localizedDescription)
                }
            }
             return Disposables.create {}
        }
    }
    
    func getHomeMoreGoods(params: Int) -> Single<HomeGoodsModel> {
        return Single<HomeGoodsModel>.create { single in
            self.homeProvider.request(.goodsByLastId(params)) { result in
                switch result {
                case let .success(response):
                    let result = try? response.map(HomeGoodsModel.self)
                    guard let result = result else { return }
                    return single(.success(result))
                 case let .failure(error):
                    print(error.localizedDescription)
                }
            }
             return Disposables.create {}
        }
    }
}
