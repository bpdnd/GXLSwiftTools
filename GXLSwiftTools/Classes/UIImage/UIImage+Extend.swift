//
//  UIImage+Extend.swift
//  Wardrobe
//
//  Created by MAC on 2019/5/5.
//  Copyright © 2019 MAC. All rights reserved.
//

import Foundation
import UIKit
extension UIImage{
    
   /// 纯色图片
   ///
   /// - Parameter color: 颜色
   /// - Returns: 返回image
   class func creatImageWithColor(color:UIColor)->UIImage{
        let rect = CGRect(x:0,y:0,width:1,height:1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
