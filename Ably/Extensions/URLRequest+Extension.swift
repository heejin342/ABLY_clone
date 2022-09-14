//
//  URLRequest+Extension.swift
//  Ably
//
//  Created by 김희진 on 2022/09/02.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

struct Resource<T: Decodable> {
    let url: URL
}

extension URLRequest {
    static func load<T>(resource: Resource<T>) -> Observable<T> {
        return Observable.just(resource.url)
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }.map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
    }
}
