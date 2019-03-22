//
//  YXTools.swift
//  imitateNewsDemo
//
//  Created by apple on 16/11/21.
//  Copyright © 2016年 lyx. All rights reserved.
//

import UIKit

class YXTools: NSObject {
    
    class func getAppDelegate() ->AppDelegate{
        return (UIApplication.shared.delegate as? AppDelegate)!
    }
    //
    /*****验证字符串是否为空******/
    class func stringIsNotNullTrim(s:String?) ->Bool{
        guard let ss = s else {
            return true
        }
        if ss.isEmpty ||  ss == "" || ss == "<null>" || ss == "(null)" || ss.characters.count == 0 {
            return true
        }
        return false
    }
    
    /*****初始化label******/
   class func allocLabel(title:String?,font:UIFont?,textColor:UIColor?,textAlignment:NSTextAlignment) ->UILabel{
        let label = UILabel()
        label.text = title
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.backgroundColor = UIColor.clear
        return label
    }
     /*****初始化button******/
    class  func allocButton(title:String?,font:UIFont?,textColor:UIColor?,nom_bg:UIImage?,hei_bg:UIImage?) ->UIButton{
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = font
        button.setImage(nom_bg, for: .normal)
        button.setImage(hei_bg, for: .highlighted)
        return button
    }
      /*****初始化线******/
    class func allocline(frame:CGRect,bgColor:UIColor) ->UIView{
        let view = UIView()
        view.frame = frame
        view.backgroundColor = bgColor
        return view
    }
    
    /*****设置字符串中数字的颜色*****/
    class func converToDigitalString(string:String,color:UIColor,fontSize:CGFloat) -> NSMutableAttributedString {
        let scanner = Scanner(string: string)
        scanner.scanUpToCharacters(from: CharacterSet.decimalDigits, into: nil)   //扫描字符串中的数字
        var number :Double = 0       //这里定义为double 类型，可以扫描出小数，否则只能扫描整数部分
        scanner.scanDouble(&number)
        let numberStr = String(number).cleanDecimalPointZear()  //如果不去除末尾的零的话，会获取不到范围
        let result = NSMutableAttributedString(string: string)
        let font = UIFont.boldSystemFont(ofSize: fontSize)
        let rangeIndex = string.range(of: numberStr)
        let range = string.nsRangeFromRange(range: rangeIndex!)
        result.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        result.addAttribute(NSFontAttributeName, value:font, range: range)
        return result
    }
    
    
    class func cATransitionAnimation(toView:UIView,typeIndex:NSInteger,subTypeIndex:NSInteger,duration:TimeInterval,animation:(()->())?){
        let transtion = CATransition()
        transtion.duration = duration
        transtion.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        switch typeIndex {
        case 0:
            transtion.type = kCATransitionFade  //翻页
            break
        case 1:
            transtion.type = kCATransitionPush   //推出
            break
        case 2:
            transtion.type = kCATransitionReveal  //移除
            break
        case 3:
            transtion.type = kCATransitionMoveIn  //弹出
            break
        case 4:
            transtion.type = "cube"   //立方体
            break
        case 5:
            transtion.type = "suckEffect"   //吸收
            break
        case 6:
            transtion.type = "oglFlip"  //翻转
            break
        case 7:
            transtion.type = "rippleEffect"  //波纹
            break
        case 8:
            transtion.type = "pageCurl"   //卷页
            break
        case 9:
            transtion.type = "pageUnCurl"  //铺开
            break
        case 10:
            transtion.type = "cameraIrisHollowOpen"  //镜头开
            break
        case 11:
            transtion.type = "cameraIrisHollowClose" //镜头关
            break
        default:
            transtion.type = kCATransitionFade  //翻页
            break
        }
        
        switch (subTypeIndex) {
        case 0:
            transtion.subtype = kCATransitionFromLeft  //从左侧开始实现过渡动画
            break
        case 1:
            transtion.subtype = kCATransitionFromRight  //从右侧开始实现过渡动画
            break
        case 2:
            transtion.subtype = kCATransitionFromBottom  //从底部开始实现过渡动画
            break
        case 3:
            transtion.subtype = kCATransitionFromTop  //从顶部开始实现过渡动画
            break
        default:
            transtion.subtype = kCATransitionFromLeft  //从左侧开始实现过渡动画
            break
        }
        animation?()
        if toView.layer != NSNull() {
            toView.layer.add(transtion, forKey: "animation")
        }

    }
    
    
    /**隐藏键盘*/
    class func autohideKeyBoard(view:UIView){
        for inView in view.subviews {
            if inView.isKind(of: UITextField.self) || inView.isKind(of: UITextView.self) {
                inView.resignFirstResponder()
            }
            if inView.subviews.count > 0 {
                self.autohideKeyBoard(view: inView)
            }
        }
    }
    
    
    class func uiViewAnimationTransition(toView:UIView?,typeIndex:NSInteger,duration:TimeInterval,animation:(()->())?){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(.easeInOut)
        UIView.setAnimationDuration(duration)
        guard toView != nil else {
            animation?()
            UIView.commitAnimations()
            return
        }
        switch typeIndex {
        case 0:
            UIView.setAnimationTransition(.curlUp, for: toView!, cache: true)
            break
        case 1:
             UIView.setAnimationTransition(.curlDown, for: toView!, cache: true)
            break
        case 2:
             UIView.setAnimationTransition(.flipFromLeft, for: toView!, cache: true)
            break
        case 3:
             UIView.setAnimationTransition(.flipFromRight, for: toView!, cache: true)
            break
        default:
             UIView.setAnimationTransition(.curlUp, for: toView!, cache: true)
            break
        }
        animation?()
        UIView.commitAnimations()
    }
    
    /**获取当前时间*/
    class func getNowDateStr() ->String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-ddHH:mm:ss"
        let str = formatter.string(from: date)
        return str
    }
    
    /**将字符串转化为date**/
    class func dateWithString(string:String?) ->NSDate?{
        if string == nil {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // k
        let outPutDate = dateFormatter.date(from: string!)
        return outPutDate as NSDate?
    }
    
    /**将date转化为时间戳**/
    class func TimeStampWithDate(date:Date?) ->String?{
        if date == nil {
            return nil
        }
        let timeInterval:TimeInterval = date!.timeIntervalSince1970
        let timeStamp = String(timeInterval)
        return timeStamp
    }
    
   //MARK:将时间戳转化为时间字符串
   class func getDateStrFrameTimeStamp(timeStamp:String?,format:String) ->String?{
        guard let string = timeStamp else {
            return nil
        }
        let time = string.doubleValue
        let datailDate = Date.init(timeIntervalSince1970: time!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = format
        let currentDate = dateFormatter.string(from: datailDate)
        return currentDate
    }
    
  
}
