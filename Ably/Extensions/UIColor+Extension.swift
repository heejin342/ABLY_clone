//
//  UIColor+Extension.swift
//  Ably
//
//  Created by 김희진 on 2022/09/05.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}

extension UIColor {
    static let pointColor = UIColor(red: 236, green: 94, blue: 101)
    static let primaryTextColor = UIColor(red: 0, green: 0, blue: 0)
    static let secondaryTextColor = UIColor(red: 119, green: 119, blue: 119)
}
