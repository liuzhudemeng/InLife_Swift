//
//  CustomerDefine.swift
//  imitateNewsDemo
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 lyx. All rights reserved.
//

import UIKit

/****
   **
 颜色定义
   **
 ****/
public let ColorLine_LightGray:UIColor = Color_RGB_String("#1ca96a")

public let ColorClear:UIColor    = UIColor.clear
public let ColorRed:UIColor      = UIColor.red
public let ColorWhite:UIColor    = UIColor.white
public let ColorBlack:UIColor    = UIColor.black
public let ColorDarkGray:UIColor = UIColor.darkGray
public let ColorLightGray:UIColor = UIColor.gray

//背景颜色
public let BgViewColor = Color_RGB_String("#efefef")
//背景线的颜色
public let bordColor = UIColor.colorWithCustom(219, g: 217, b: 216)
public let Color_Nav:UIColor = Color_RGB_String("#fbd85f")   //导航颜色
public let Title_Black:UIColor = Color_RGB_String("#404040")   //字体黑色
public let Title_gray:UIColor = Color_RGB_String("#888888")   //字体灰色
public let Title_Orange:UIColor = Color_RGB_String("#fdb352")   //字体橘色
public let Title_Red:UIColor = Color_RGB_String("#fc393d")   //字体红色

public let Btn_blue:UIColor = Color_RGB_String("#3e99d9")   //按钮蓝色

public func Color_RGB_String (_ string:String) -> UIColor{
    return UIColor.colorWithHexString(string)
}

/****
 **
 距离定义
 **
 ****/
public let Begin_X: CGFloat = UIScale(15)    //左边距
//导航和tabbar高度
public let navigateHeight:CGFloat = 64    //导航高度
public let tabbarHeight:CGFloat = 49    //导航高度
//判断数组是否为空
public func ArrayIsNull(_ array:[AnyObject]?) ->Bool{
    if array?.count == 0 || array == nil {
        return true
    }
    return false
}

//设置字体
public func systemFont(_ fontSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: fontSize)
}

public func systemBoldFont(_ fontSize: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: fontSize)
}


//判断设备
/**是否是iPhone 4*/

public let is_iPhone4: Bool =  UIScreen.main.bounds.size.equalTo(CGSize(width: 320, height: 480)) && UIScreen.main.scale == 1.0

/**是否是iPhone 4S*/
public let is_iPhone4s: Bool = UIScreen.main.bounds.size.equalTo(CGSize(width: 320, height: 480)) && UIScreen.main.scale == 2.0

/**是否是iPhone 5 、 iPhone 5S or iPhone SE*/
public let is_iPhone5: Bool = UIScreen.main.bounds.size.equalTo(CGSize(width: 320, height: 568))

/**是否是iPhone 6 or iPhone 6S*/
public let is_iPhone6: Bool = UIScreen.main.bounds.size.equalTo(CGSize(width: 375, height: 667))

/**是否是iPhone 6 Plus or iPhone 6S Plus*/
public let is_iPhone6p: Bool = UIScreen.main.bounds.size.equalTo(CGSize(width: 414, height: 736))

/**是否显示引导图key*/
public let is_showGuide: String = "is_showGuide"

public func AppBundleVersion() -> String {
    return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
}


public let CustomerTelePhone:String =  "0571-87791393"      //客服电话
public let SystemVersion:String = Bundle.main.infoDictionary! ["CFBundleShortVersionString"] as! String              //当前版本
/// 自定义打印
/// - 需要在Build Setting --->  custom flags ---> Other Swift Flags ---->  Debug 里面添加-D DEBUG, 当发布release版本的时候不会打印, DEBUG模式才会输出!
/// - parameter items:        需要打印的参数
/// - parameter fileName:     文件名
/// - parameter functionName: 方法名
/// - parameter lineNumber:   行数
func HHLog(_ items: Any..., fileName: String = #file, functionName: String = #function, lineNumber: Int = #line) {
    #if DEBUG
        var string = "时间: \(Date().timeIntervalSinceNow) 文件:\((fileName as NSString).lastPathComponent) 方法:\(functionName) [\(lineNumber)行] "
        for item in items {
            string.append(" \(item)")
        }
        print(string)
    #endif
}


//保存token
let tokenKey: String = "UserDefault_Token_Key"
//保存账户
let  customerKey: String = "UserDefault_Customer_Key"
let accountKey:String = "UserDefault_Account_Key"

var file : Any = NSHomeDirectory() as NSString
var pathTxt = (file as! NSString).appendingPathComponent("Documents/userInfo.archive")

public let HKLOGINVAILDTIME:String = "3600"   //海康登陆有效时间1小时

/// 极光推送key
let JPushAppKey = "20f6371f7253dd02a2999120"
let isProduction:Bool = false  //是否是生成环境  ture  生成环境   false 开发环境

public let NOTIFYAPProal:String = "Notify_approal"  //审批通过通知（进入仓库申请）
public let APPLYMONITORAPPROAL_BSP:String = "applyMonitor_bsp"  //申请监控通知（查看仓库申请）
public let UPDATESYSTEM:String = "updateStystem"   //更新个人中心系统显示
public let STOPWATCH:String = "stopwatch"          //停止观看

public let API_KEY:String = "EZJ6H9EWxQ5ay+zTDC6ADDKzr901VyoippHN6QaTTEZEc2UVfUI1Fyuzeoe6y165"

//测试环境暗号
//public let API_KEY:String = "LlfTaqsFIkkVVvNQ5V6S9LDfysFXdRN1/xY2Q/LzKxQ9lvBOxDVo86nPsGURkl0u"




