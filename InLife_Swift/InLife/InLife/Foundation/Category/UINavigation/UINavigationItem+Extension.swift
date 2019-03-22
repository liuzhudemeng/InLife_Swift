//
//  UINavigationItem+Extension.swift
//  NewStoreSpace
//
//  Created by apple on 16/12/21.
//  Copyright © 2016年 lyx. All rights reserved.
//

import UIKit

extension UINavigationItem {
    // ------navigation bar------
    func setNavBarTitle(title: String) -> Void {
        let label = UILabel()
        label.textColor = UIColor.colorWithHexString("#41444e")
        label.font = FontR(18)
        self.titleView = label
        label.text = title
        label.sizeToFit()
    }
    
    func setNavBarImage(image: UIImage) -> Void {
        let imgView = UIImageView()
        imgView.image = image
        self.titleView = imgView
    }
    
    // image
    func setLeftButtonWithImage(image:UIImage, highlight hlImage:UIImage?, target:AnyObject?, action:Selector) {
        let barButtonItem = NEBarButtonItem(title:nil,
                                            normalImage:image,
                                            highligtedImage:hlImage,
                                            target:target,
                                            action:action)
        self.setLeftBarButton(barButtonItem, animated: false)
    }
    
    // title
    func setLeftButtonWithTitle(title:String, target:AnyObject?, action:Selector) {
        let barButtonItem = NEBarButtonItem(title:title,
                                            normalImage:nil,
                                            highligtedImage:nil,
                                            target:target,
                                            action:action)
        barButtonItem?.textLabel.font = FontR(15)
        barButtonItem?.textLabel.textColor = UIColor.colorWithHexString("#41444e")
        self.setLeftBarButton(barButtonItem, animated: false)
    }
    
    // ------right button------
    // image
    func setRightButtonWithImage(image:UIImage, highlight hlImage:UIImage?, target:AnyObject?, action:Selector) {
        let barButtonItem = NEBarButtonItem(title:nil,
                                            normalImage:image,
                                            highligtedImage:hlImage,
                                            target:target,
                                            action:action)
        self.setRightBarButton(barButtonItem, animated: false)
    }
    // title
    func setRightButtonWithTitle(title:String, target:AnyObject?, action:Selector) {
        let barButtonItem = NEBarButtonItem(title:title,
                                            normalImage:nil,
                                            highligtedImage:nil,
                                            target:target,
                                            action:action)
        barButtonItem?.textLabel.font = FontR(15)
        barButtonItem?.textLabel.textColor = UIColor.colorWithHexString("#41444e")
        self.setRightBarButton(barButtonItem, animated: false)
    }
    
    // ------specified button------
    func setBackButton(target:AnyObject?, action:Selector) {
        //        self.hidesBackButton = true
        let barButtonItem = NEBarButtonItem(title:title,
                                            normalImage:ImageNamed("icon_back"),
                                            highligtedImage:ImageNamed("icon_back"),
                                            target:target,
                                            action:action)
        self.setLeftBarButton(barButtonItem, animated: false)
    }

    
    //--------设置prent 关闭按钮
    func setPreCloseButton(target:AnyObject?, action:Selector) {
        //        self.hidesBackButton = true
        let barButtonItem = NEBarButtonItem(title:title,
                                            normalImage:ImageNamed("icon_right_back"),
                                            highligtedImage:ImageNamed("icon_right_back"),
                                            target:target,
                                            action:action)
        self.setLeftBarButton(barButtonItem, animated: false)
    }

}
