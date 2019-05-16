//
//  AppInfo.swift
//  test
//
//  Created by HeHeAdmin on 2019/5/10.
//  Copyright © 2019 HeHeAdmin. All rights reserved.
//

import UIKit

class AppInfo: NSObject {
    static let infoDictionary = Bundle.main.infoDictionary
    
    static let appDisplayName: String = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String //App 名称
    
    static let bundleIdentifier:String = Bundle.main.bundleIdentifier! // Bundle Identifier
    
    static let appVersion:String = Bundle.main.infoDictionary! ["CFBundleShortVersionString"] as! String// App 版本号
    
    static let buildVersion : String = Bundle.main.infoDictionary! ["CFBundleVersion"] as! String //Bulid 版本号
    
    static let iOSVersion:String = UIDevice.current.systemVersion //ios 版本
    
    static let identifierNumber = UIDevice.current.identifierForVendor //设备 udid
    
    static let systemName = UIDevice.current.systemName //设备名称
    
    static let model = UIDevice.current.model // 设备型号
    
    static let localizedModel = UIDevice.current.localizedModel  //设备区域化型号

}
