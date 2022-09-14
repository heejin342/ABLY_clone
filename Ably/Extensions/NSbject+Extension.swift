//
//  NSObject+Extension.swift
//  Ably
//
//  Created by 김희진 on 2022/09/02.
//

import Foundation

extension NSObject {
    static var Id: String {
        return String(describing: self)
    }
}
