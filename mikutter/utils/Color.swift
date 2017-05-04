//
//  Color.swift
//  mikutter
//
//  Created by ahiru on 2017/05/04.
//  Copyright © 2017年 mikutter. All rights reserved.
//

import UIKit

extension UIColor {
    class func rgb(r: Int, g: Int, b: Int, a: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    class var mikutter: UIColor {
        return UIColor.rgb(r: 63, g: 189, b: 255, a: 1.0)
    }
}
