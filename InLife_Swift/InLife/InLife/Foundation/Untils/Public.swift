//
//  Public.swift
//  StoreSpace_Swift
//
//  Created by apple on 17/1/6.
//  Copyright © 2017年 lyx. All rights reserved.
//

import UIKit

class Public: NSObject {

    //设置导航背景颜色和字体颜色
    class func setNavigageColor(_ naviegation:UINavigationController,backGroundColor:UIColor,titleColor:UIColor){
        naviegation.navigationBar.barTintColor = backGroundColor
        naviegation.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: titleColor]
    }

}
