//
//  String+Extension.swift
//  Ably
//
//  Created by 김희진 on 2022/09/03.
//

import Foundation

extension String {
    var makeComma: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let price = Double(self)!
        return numberFormatter.string(from: NSNumber(value:price))!
    }
}

