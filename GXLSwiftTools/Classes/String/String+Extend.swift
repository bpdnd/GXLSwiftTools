//
//  String+Extend.swift
//  GLSwiftProject
//
//

import UIKit

//MARK:---- 字符串拆分 ----
extension String {
    
    ///字符串截取
    public func gxl_subStringFrom(index:Int,length:Int) -> String {
        
        if (self.count > index) {
            
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(self.startIndex, offsetBy: index + length)
            
            let subString = self[startIndex ..< endIndex]
            return String(subString)
        }else {
            return self
        }
    }
    
    ///字符串截取
    func gxl_substring(from: Int,to: Int) -> String {
        
        let fromIndex = index(startIndex, offsetBy: from)
        let toIndex = index(startIndex, offsetBy: to)
        guard fromIndex >= startIndex,fromIndex < toIndex,toIndex <= endIndex else {
            return ""
        }
        
        return String(self[fromIndex ..< toIndex])
    }
    
    ///字符串截取
    func gxl_substring(from: Int?,to: Int?) -> String {
        return gxl_substring(from: from ?? 0, to: to ?? count)
    }
    
    ///字符串截取
    func gxl_substring(from: Int) -> String {
        return gxl_substring(from: from, to: nil)
    }
    
    ///字符串截取
    func gxl_substring(to: Int) -> String {
        return gxl_substring(from: nil, to: to)
    }
    
    ///替换指定范围内的字符串
    mutating func gxl_stringByReplacingCharactersInRange(index:Int,length:Int,replacText:String) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: index)
        self.replaceSubrange(startIndex ..< self.index(startIndex, offsetBy: length), with: replacText)
        return self
    }
    
    ///替换指定字符串
    mutating func gxl_stringByReplacingStringInOccurrences(text:String,replacText:String) -> String {
        return self.replacingOccurrences(of: text, with: replacText)
    }
    
    ///删除最后一个字符
    mutating func gxl_deleteEndCharacter() -> String {
        self.remove(at: self.index(before: self.endIndex))
        return self
    }
    
    ///删除指定字符串
    mutating func gxl_deleteOccurrencesString(string:String) -> String {
        return self.replacingOccurrences(of: string, with: "")
    }
    
    ///字符的插入
    mutating func gxl_insertString(text:Character,index:Int) -> String {
        
        let startIndex = self.index(self.startIndex, offsetBy: index)
        self.insert(text, at: startIndex)
        return self
    }
    
    ///字符的插入
    mutating func gxl_insertString(text:String,index:Int) -> String {
        
        let startIndex = self.index(self.startIndex, offsetBy: index)
        self.insert(contentsOf: text, at: startIndex)
        return self
    }
    
    /// 通过特定字符分割成字符串数组
    ///
    /// - Parameter string: 特定的分割字符
    /// - Returns: 字符串数组
    func gxl_splitStringToArray(string:String) -> [String] {
        
        return NSString(string: self).components(separatedBy: string)
    }
}

//MARK: ---- 获取文本宽高 ----
extension String {
    
    /// 获取文本高度
    ///
    /// - Parameters:
    ///   - font: 字体,默认17
    ///   - fixedWidth: 固定宽度
    /// - Returns: 高度
    func gxl_getTextWidth(font:UIFont = UIFont.systemFont(ofSize: 17),fixedWidth:CGFloat) -> CGFloat {
        
        guard count > 0 && fixedWidth > 0 else {
            return 0
        }
        let size = CGSize(width:fixedWidth, height:CGFloat.greatestFiniteMagnitude)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context:nil)
        return rect.size.height
    }
    
    /// 获取文本宽度
    ///
    /// - Parameter font: 字体,默认17
    /// - Returns: 宽度
    func gxl_getTextWidth(font:UIFont = UIFont.systemFont(ofSize: 17)) -> CGFloat {
        
        guard count > 0 else {
            return 0
        }
        
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
        return rect.size.width
    }
}


//MARK: ---- 正则与验证 ----
extension String {
    
    ///正则
    private func gxl_isValidateBy(regex:String) -> Bool {
        
        let predicate = NSPredicate(format: "SELF MATCHES " + regex)
        return predicate.evaluate(with:self)
    }
    
    ///是否是手机号
    func gxl_isMobileNumber() -> Bool {
        
        let regex = "^(0|86|17951)?(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$"
        return self.gxl_isValidateBy(regex: regex)
    }
    
    ///是否是邮箱号
    func gxl_isEmail() -> Bool {
        
        let regex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return self.gxl_isValidateBy(regex: regex)
    }
    
    ///是否为纯数字
    func gxl_isJustNumber() -> Bool {
        let regex = "^[0-9]+$"
        return self.gxl_isValidateBy(regex: regex)
    }
    
    ///身份证粗验证
    func gxl_IDCardShallowValidation() -> Bool {
        let regex = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        return self.gxl_isValidateBy(regex: regex)
    }
    
    ///是否是网址
    func gxl_isUrl() -> Bool {
        let regex = "^((http)|(https))+:[^\\s]+\\.[^\\s]*$"
        return self.gxl_isValidateBy(regex: regex)
    }
    
    ///身份证精准校验
    
    
    ///检验字符串是否为空或者仅由空格和换行符组成
    var gxl_isBlank:Bool {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty
    }
}

//MARK: ---- 编码 ----
extension String {
    
    ///base64 编码
    var gxl_base64:String {
        
        let plainData = (self as NSString).data(using: String.Encoding.utf8.rawValue)
        let base64String = plainData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String
    }
    
    ///base64解码
    var gxl_base64Decode:String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    ///URL编码
    var gxl_urlEncoded:String? {
        
        let characterSet = CharacterSet(charactersIn: ":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`")
        return self.addingPercentEncoding(withAllowedCharacters: characterSet)!
    }
    
    ///URL解码
    var gxl_urlDecode:String? {
        return self.removingPercentEncoding
    }
    
    ///将String转换为NSString
    var gxl_toNSString:NSString {
        return self as NSString
    }
}
