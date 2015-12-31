//
//  UIColorExtension.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-30.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    var appBlue: UIColor {
        return UIColor(red: 18.0/255.0, green: 89.0/255.0, blue: 162.0/255.0, alpha: 1.0)
    }
}
