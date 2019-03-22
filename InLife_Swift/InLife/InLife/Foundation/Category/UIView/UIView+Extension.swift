//
//  UIView+Extension.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

/// 对UIView的扩展
extension UIView {
    /// X值
    var x: CGFloat {
        return self.frame.origin.x
    }
    /// Y值
    var y: CGFloat {
        return self.frame.origin.y
    }
    /// 宽度
    var width1: CGFloat {
        return self.frame.size.width
    }
    ///高度
    var height1: CGFloat {
        return self.frame.size.height
    }
    var size1: CGSize {
        return self.frame.size
    }
    var point: CGPoint {
        return self.frame.origin
    }
    
   
    /**view所在的控制器*/
    var hj_viewController:UIViewController? {
        get {
            var responder = self.next
            while responder != nil {
                if true == responder?.isKind(of: UIViewController.classForCoder()) {
                    return responder as? UIViewController
                }
                responder = responder?.next
            }
            return nil
        }
    }
    
    /**只有设置了autoLayout的才可以*/
    var hj_autoLayoutHeight: CGFloat {
        get {
            let widthFenceConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: UIScreen.main.bounds.size.width)
            self.addConstraint(widthFenceConstraint)
            let size = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            return size.height
        }
    }

    /**width*/
    var hj_width: CGFloat {
        get {
            return frame.size.width
        }
        set (new) {
            frame.size.width = new
        }
    }
    /**centerX*/
    var hj_centerX: CGFloat {
        get {
            return center.x
        }
        set (new) {
            center.x = new
        }
    }
    
    /**centerY*/
    var hj_centerY: CGFloat {
        get {
            return center.y
        }
        set (new) {
            center.y = new
        }
    }
    
    func cyl_setX(_ rationX:CGFloat){
        var rect = self.frame
        rect.origin.x = x
        self.frame = rect
    }
    
    func yx_top(top:CGFloat) {
        var frame = self.frame
        frame.origin.y = top
        self.frame = frame
    }
    
    func yx_Left(left:CGFloat) {
        var frame = self.frame
        frame.origin.x = left
        self.frame = frame
    }
    
    func yx_bottom(bottom:CGFloat) {
        var frame = self.frame
        frame.origin.y = bottom - frame.size.height
        self.frame = frame
    }
    
    func yx_size(size:CGSize) {
        self.frame.size = size
    }
    
    var cyl_capture:UIImage{
        get{
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 270, height: self.bounds.size.height), self.isOpaque, 0.0)
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
             UIGraphicsEndImageContext()
            return image!
        }
    }
}

