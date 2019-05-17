//
//  UIColor+Extend.swift
//  Wardrobe
//
//  Created by MAC on 2019/5/5.
//  Copyright © 2019 MAC. All rights reserved.
//

import Foundation
import UIKit
extension UIColor{
    
    /// 十六进制颜色
    ///
    /// - Parameter hexadecimal: 十六进制颜色名称 如 #a6e3e9
    /// - Returns: 返回颜色
    class func hexadecimalColor(hexadecimal:String)->UIColor{
        var cstr = hexadecimal.trimmingCharacters(in:  CharacterSet.whitespacesAndNewlines).uppercased() as NSString;
        if(cstr.length < 6){
            return UIColor.clear;
        }
        if(cstr.hasPrefix("0X")){
            cstr = cstr.substring(from: 2) as NSString
        }
        if(cstr.hasPrefix("#")){
            cstr = cstr.substring(from: 1) as NSString
        }
        if(cstr.length != 6){
            return UIColor.clear;
        }
        var range = NSRange.init()
        range.location = 0
        range.length = 2
        //r
        let rStr = cstr.substring(with: range);
        //g
        range.location = 2;
        let gStr = cstr.substring(with: range)
        //b
        range.location = 4;
        let bStr = cstr.substring(with: range)
        var r :UInt32 = 0x0;
        var g :UInt32 = 0x0;
        var b :UInt32 = 0x0;
        Scanner.init(string: rStr).scanHexInt32(&r);
        Scanner.init(string: gStr).scanHexInt32(&g);
        Scanner.init(string: bStr).scanHexInt32(&b);
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1);
    }
    
    
    /// 随机色
    ///
    /// - Returns: 颜色
    static func gxl_randomColor() -> UIColor {
        return gxl_colorWithRGB(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    
    /// red，green，blue，alpha
    ///
    /// - Parameters:
    ///   - r: 红色
    ///   - g: 绿色
    ///   - b: 蓝色
    ///   - alpha: 透明度
    /// - Returns: 颜色
    static func gxl_colorWithRGBA(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat) -> UIColor {
        
        return self.init(red:r / 255.0,green:g/255.0,blue:b / 255.0,alpha:alpha)
    }
    
    
    ///   red，green，blue
    ///
    /// - Parameters:
    ///   - r: 红色
    ///   - g: 绿色
    ///   - b: 蓝色
    /// - Returns: f颜色
    static func gxl_colorWithRGB(r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor {
        return gxl_colorWithRGBA(r: r, g: g, b: b, alpha: 1.0)
    }
    
    static func gxl_colorWithHex(hex:Int,alpha:CGFloat) -> UIColor {
        return UIColor.init(red:CGFloat((hex >> 16) & 0xFF) / 255.0,green:CGFloat((hex >> 8) & 0xFF) / 255.0,blue:CGFloat(hex & 0xFF) / 255.0,alpha:alpha)
    }
    
}
