//
//  UIImage+Extend.swift
//  Wardrobe
//
//  Created by MAC on 2019/5/5.
//  Copyright © 2019 MAC. All rights reserved.
//

import Foundation
import UIKit
//按钮背景--渐变色
public enum DTImageGradientDirection {
    case toLeft
    case toRight
    case toTop
    case toBottom
    case toBottomLeft
    case toBottomRight
    case toTopLeft
    case toTopRight
}
extension UIImage {
    public convenience init?(size: CGSize, direction: DTImageGradientDirection, colors: [UIColor]) {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil } // If the size is zero, the context will be nil.
        
        guard colors.count >= 1 else { return nil } // If less than 1 color, return nil
        
        if colors.count == 1 {
            // Mono color
            let color = colors.first!
            color.setFill()
            
            let rect = CGRect(origin: CGPoint.zero, size: size)
            UIRectFill(rect)
        }
        else {
            // Gradient color
            var location: CGFloat = 0
            var locations: [CGFloat] = []
            
            for (index, _) in colors.enumerated() {
                let index = CGFloat(index)
                locations.append(index / CGFloat(colors.count - 1))
            }
            
            guard let gradient = CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB(), colorComponents: colors.flatMap { $0.cgColor.components }.flatMap { $0 }, locations: locations, count: colors.count) else {
                return nil
            }
            
            var startPoint: CGPoint
            var endPoint: CGPoint
            
            switch direction {
            case .toLeft:
                startPoint = CGPoint(x: size.width, y: size.height/2)
                endPoint = CGPoint(x: 0.0, y: size.height/2)
            case .toRight:
                startPoint = CGPoint(x: 0.0, y: size.height/2)
                endPoint = CGPoint(x: size.width, y: size.height/2)
            case .toTop:
                startPoint = CGPoint(x: size.width/2, y: size.height)
                endPoint = CGPoint(x: size.width/2, y: 0.0)
            case .toBottom:
                startPoint = CGPoint(x: size.width/2, y: 0.0)
                endPoint = CGPoint(x: size.width/2, y: size.height)
            case .toBottomLeft:
                startPoint = CGPoint(x: size.width, y: 0.0)
                endPoint = CGPoint(x: 0.0, y: size.height)
            case .toBottomRight:
                startPoint = CGPoint(x: 0.0, y: 0.0)
                endPoint = CGPoint(x: size.width, y: size.height)
            case .toTopLeft:
                startPoint = CGPoint(x: size.width, y: size.height)
                endPoint = CGPoint(x: 0.0, y: 0.0)
            case .toTopRight:
                startPoint = CGPoint(x: 0.0, y: size.height)
                endPoint = CGPoint(x: size.width, y: 0.0)
            }
            
            context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions())
        }
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            return nil
        }
        
        self.init(cgImage: image)
        
        defer { UIGraphicsEndImageContext() }
    }
    
    public convenience init?(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIRectFill(rect)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            return nil
        }
        
        self.init(cgImage: image)
        
        defer { UIGraphicsEndImageContext() }
    }
}



//-------------
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
    public class func scaleTo(image:UIImage,width:CGFloat,height:CGFloat) -> UIImage {
        let newSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    ///返回一个调整了宽度的图片，可能是一个低质量的
    public func resizeWithWidth(_ width:CGFloat) -> UIImage {
        
        let aspectSize = CGSize(width: width, height: aspectHeightForWidth(width))
        UIGraphicsBeginImageContext(aspectSize)
        draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    ///返回一个调整了宽度的图片，可能是一个低质量的
    public func resizeWithHeight(_ height:CGFloat) -> UIImage {
        
        let aspectSize = CGSize(width: aspectWidthForHeight(height), height: height)
        UIGraphicsBeginImageContext(aspectSize)
        draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    public func aspectHeightForWidth(_ width:CGFloat) -> CGFloat {
        return (width * self.size.height) / self.size.width
    }
    
    public func aspectWidthForHeight(_ height:CGFloat) -> CGFloat {
        return (height * self.size.width) / self.size.height
    }
    
    ///返回一个裁剪后的图片
    public func croppedImage(_ bound:CGRect) -> UIImage? {
        guard self.size.width > bound.origin.x else {
            
            print("裁剪的x坐标大于图片宽度")
            return nil
        }
        guard self.size.height > bound.origin.y else {
            print("裁剪的Y坐标大于图片高度")
            return nil
        }
        
        let scaledBounds : CGRect = CGRect(x: bound.origin.x * self.scale, y: bound.origin.y * self.scale, width: bound.width * self.scale, height: bound.height * self.scale)
        let imageRef = self.cgImage?.cropping(to: scaledBounds)
        let croppedImage:UIImage = UIImage(cgImage: imageRef!, scale: self.scale, orientation: UIImage.Orientation.up)
        return croppedImage
    }
    
}
