//
//  UIButton+Extend.swift
//  GLSwiftProject
//
//  Created by HeHeAdmin on 2019/5/16.
//  Copyright © 2019 HeHeAdmin. All rights reserved.
//

import UIKit

//MARK: ---- 初始化 ----
extension UIButton {
    
    convenience init(x:CGFloat,y:CGFloat,w:CGFloat,h:CGFloat,style:UIButton.ButtonType) {
        
        self.init(type: style)
        frame = CGRect(x: x, y: y, width: w, height: h)
    }
}

//MARK: ---- 常见set方法 ----
extension UIButton {
    
    /// 设置选中和非选中文字颜色
    ///
    /// - Parameters:
    ///   - normalColor: normalColor
    ///   - selectedColor: selectedColor
    func set_GLTitleColor(normalColor:UIColor,selectedColor:UIColor) {
        setTitleColor(normalColor, for: .normal)
        setTitleColor(selectedColor, for: .selected)
    }
    
    /// 设置选中和非选中图片
    ///
    /// - Parameters:
    ///   - normalImage: normalImage
    ///   - selecedImage: selecedImage
    func set_GLImage(normalImage:UIImage,selecedImage:UIImage) {
        
        setImage(normalImage, for: .normal)
        setImage(selecedImage, for: .selected)
    }
    
    /// 设置非选中状态的title和color
    ///
    /// - Parameters:
    ///   - title: title
    ///   - titleColor: titleColor
    func set_GLTitleWithTitleColor(title:String,titleColor:UIColor) {
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
    }
    
    /// 设置未选中状态下的title和image
    ///
    /// - Parameters:
    ///   - title: title
    ///   - image: image
    func set_GLTitleWithImage(title:String,image:UIImage) {
        
        setImage(image, for: .normal)
        setTitle(title, for: .normal)
    }
}


//MARK: ---- runtime添加属性 ----
struct RunTimeButtonKey {
    
    ///连续两次的点击相差的时间
    static let timeInterval = UnsafeRawPointer.init(bitPattern: "timeInterval".hashValue)
    
    ///点击区域
    static let topNameKey = UnsafeRawPointer.init(bitPattern: "topNameKey".hashValue)
    static let rightNameKey = UnsafeRawPointer.init(bitPattern: "rightNameKey".hashValue)
    static let bottomNameKey = UnsafeRawPointer.init(bitPattern: "bottomNameKey".hashValue)
    static let leftNameKey = UnsafeRawPointer.init(bitPattern: "leftNameKey".hashValue)
    
}

extension UIButton {
    
    //添加属性，设置timeInterval时，修改button的执行事件
    var timeInterval:CGFloat? {
        set {
            objc_setAssociatedObject(self, RunTimeButtonKey.timeInterval!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            UIButton.changeFunction
        }
        get {
            return objc_getAssociatedObject(self, RunTimeButtonKey.timeInterval!) as? CGFloat
        }
    }
    
    private static let changeFunction: () = {
        //交换方法
        let systemMethod = class_getInstanceMethod(UIButton.classForCoder(), #selector(UIButton.sendAction(_:to:for:)))
        let swizzMethod = class_getInstanceMethod(UIButton.classForCoder(), #selector(UIButton.mySendAction(_:to:for:)))
        method_exchangeImplementations(systemMethod!, swizzMethod!)
    }()
    
    @objc private dynamic func mySendAction(_ action:Selector,to target:Any?,for event:UIEvent?){
        
        isUserInteractionEnabled = false
        let time:TimeInterval = TimeInterval(timeInterval ?? 0.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            self.isUserInteractionEnabled = true
        }
        mySendAction(action, to: target, for: event)
    }
    
    //扩大点击响应事件
    var topEdge:CGFloat? {
        
        set {
            objc_setAssociatedObject(self, RunTimeButtonKey.topNameKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, RunTimeButtonKey.topNameKey!) as? CGFloat
        }
    }
    
    var leftEdge:CGFloat? {
        set {
            objc_setAssociatedObject(self, RunTimeButtonKey.leftNameKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, RunTimeButtonKey.leftNameKey!) as? CGFloat
        }
    }
    
    var rightEdge:CGFloat? {
        set {
            objc_setAssociatedObject(self, RunTimeButtonKey.rightNameKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, RunTimeButtonKey.rightNameKey!) as? CGFloat
        }
    }
    
    var bottomEdge:CGFloat? {
        set {
            objc_setAssociatedObject(self, RunTimeButtonKey.bottomNameKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, RunTimeButtonKey.bottomNameKey!) as? CGFloat
        }
    }
    
    /// 扩大点击区域
    ///
    /// - Parameters:
    ///   - top: 上
    ///   - right: 右
    ///   - bottom: 下
    ///   - left: 左
    func gl_setEnlargeEdge(top:CGFloat,right:CGFloat,bottom:CGFloat,left:CGFloat) {
        
        self.topEdge = top
        self.rightEdge = right
        self.bottomEdge = bottom
        self.leftEdge = left
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let left = self.leftEdge ?? 0
        let right = self.rightEdge ?? 0
        let bottom = self.bottomEdge ?? 0
        let top = self.topEdge ?? 0
        
        var rect:CGRect
        if (left > 0 || right > 0 || bottom > 0 || top > 0) {
            rect = CGRect(x: self.bounds.origin.x - left, y: self.bounds.origin.y - top, width:self.bounds.size.width + left + right, height: self.bounds.size.height + top + bottom)
        }else {
            rect = self.bounds
        }
        
        if (rect.contains(self.bounds)) {
            return super.hitTest(point, with: event)
        }
        
        return rect.contains(point) ? self : nil
    }
}


extension UIButton {
    
    /// 整体居中，图片左，标题右
    ///
    /// - Parameters:
    ///   - imageWidth: imageWidth
    ///   - space: image和button的间距
    func gl_setImageTheLeftWithTitleRight(imageWidth:CGFloat,space:CGFloat) {
        
        let image = UIImage.scaleTo(image: imageView!.image!, width: imageWidth, height: imageWidth)
        setImage(image, for: .normal)
        
        let insetAmount = space / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
    }
    
    /// 整体居左，图片左，标题右
    ///
    /// - Parameters:
    ///   - imageWidth: imageWidth
    ///   - space: image和button的间距
    ///   - buttonWidth: buttonWidth
    func gl_setImageTheLeftWithTitleRightAndAlignmentForLeft(imageWidth:CGFloat,space:CGFloat,buttonWidth:CGFloat) {
        let image = UIImage.scaleTo(image: imageView!.image!, width: imageWidth, height: imageWidth)
        setImage(image, for: .normal)
        
        let titleLabelWidth = titleLabel?.text?.gxl_getTextWidth(font: (titleLabel?.font)!) ?? 0
        
        let spaceW = (buttonWidth - titleLabelWidth - imageWidth) / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -spaceW + space, bottom: 0, right: spaceW - space)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -spaceW + 2 * space, bottom: 0, right: spaceW - space)
    }
    
    /// 上下结构,图上，文字下
    ///
    /// - Parameters:
    ///   - imageWidth: imageWidth
    ///   - space: space
    func gl_setImageTheTopWithTitleBottom(imageWidth:CGFloat, space:CGFloat) {
        
        let image = UIImage.scaleTo(image: imageView!.image!, width: imageWidth, height: imageWidth)
        setImage(image, for: .normal)
        
        //布局界面
        let titleLabelWidth = titleLabel?.text?.gxl_getTextWidth(font: (titleLabel?.font)!) ?? 0
        let labelHeight = CGFloat((self.titleLabel?.font.pointSize)!)
        
        imageEdgeInsets = UIEdgeInsets(top: -labelHeight-space/2, left: 0, bottom: 0, right: -titleLabelWidth)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageWidth-space/2, right: 0)
    }

}

//MARK: 渐变色
extension UIButton {
    
    /// 背景色 -- 渐变色
    ///
    /// - Parameters:
    ///   - colors: 颜色
    ///   - direction: 方向
    ///   - state: 状态
    public func setGradientBackgroundColors(_ colors: [UIColor], direction: DTImageGradientDirection, for state: UIControlState) {
        if colors.count > 1 {
            // Gradient background
            setBackgroundImage(UIImage(size: CGSize(width: 1, height: 1), direction: direction, colors: colors), for: state)
        }
        else {
            if let color = colors.first {
                // Mono color background
                setBackgroundImage(UIImage(color: color, size: CGSize(width: 1, height: 1)), for: state)
            }
            else {
                // Default background color
                setBackgroundImage(nil, for: state)
            }
        }
    }
}


