//
//  HomeModel.swift
//  Ably
//
//  Created by 김희진 on 2022/09/02.
//

import Foundation
import Realm
import RealmSwift

struct HomeModel: Codable {
    var banners: [Banners]
    var goods: [Goods]
}

struct Banners: Codable {
    var id: Int
    var image: String
}

struct Goods: Codable {
    var id: Int
    var name: String
    var image: String
    var actualPrice: Int
    var price: Int
    var isNew: Bool
    var sellCount: Int

    enum CodingKeys: String, CodingKey {
        case actualPrice = "actual_price"
        case price = "price"
        case isNew = "is_new"
        case sellCount = "sell_count"
        case id, name, image
    }
}

struct HomeGoodsModel: Codable {
    var goods: [Goods]
}


class GoodsViewModel: Object {
    @Persisted var id: Int
    @Persisted var name: String
    @Persisted var image: String
    @Persisted var actualPrice: Int
    @Persisted var price: Int
    @Persisted var isNew: Bool
    @Persisted var sellCount: Int
    @Persisted var isLike: Bool
    @Persisted var createdAt: Date

    convenience init(id: Int, name: String, image: String, actualPrice: Int, price: Int, isNew:Bool, sellCount: Int, isLike: Bool, createdAt: Date) {
        self.init()
        self.id = id
        self.name = name
        self.image = image
        self.actualPrice = actualPrice
        self.price = price
        self.isNew = isNew
        self.sellCount = sellCount
        self.isLike = isLike
        self.createdAt = createdAt
    }
}
