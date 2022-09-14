//
//  LikeListRealmManager.swift
//  Ably
//
//  Created by 김희진 on 2022/09/04.
//

import Realm
import RealmSwift

class LikeListRealmManager {

    let realm = try! Realm()
    static let shared = LikeListRealmManager()

    private init() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func realmRead(_ complete: @escaping ([GoodsViewModel]) -> Void) {
        DispatchQueue.main.async {
            let returnData = Array(self.realm.objects(GoodsViewModel.self))
            complete(returnData)
        }
    }
        
    func realmFindByRange(firstId: Int, lastId: Int, _ complete: @escaping ([GoodsViewModel]) -> Void) {
        var returnData: [GoodsViewModel] = []

        DispatchQueue.main.async {
            returnData = Array(self.realm.objects(GoodsViewModel.self).filter("id >= %@ AND id <= %@", firstId, lastId))
            complete(returnData)
        }
    }
    
    func realmUpdate(data: GoodsViewModel){
        try! realm.write {
            if data.isLike {
                realm.add(data)
            } else {
                let taskToDelete = realm.objects(GoodsViewModel.self).filter("id == %@", data.id)
                realm.delete(taskToDelete)
            }
        }
    }
    
    func realmDeleteSchema(){
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [
                realmURL,
                realmURL.appendingPathExtension("lock"),
                realmURL.appendingPathExtension("note"),
                realmURL.appendingPathExtension("management")
            ]
        for URL in realmURLs {
            do {
                try FileManager.default.removeItem(at: URL)
            } catch {}
        }
    }
}
