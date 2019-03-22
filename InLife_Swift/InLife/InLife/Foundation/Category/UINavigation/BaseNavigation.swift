//
//  BaseNavigation.swift
//  YXSwiftDemo
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 lyx. All rights reserved.
//

import UIKit

class BaseNavigation: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.isTranslucent = false
        //设置状态栏颜色
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
        self.navigationBar.barTintColor = Color_Nav
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        //解决自定义leftBarButtonItem时,右滑失效问题
        self.interactivePopGestureRecognizer?.delegate = self
        
        //as操作符用来把某个实例转型为另外的类型，由于实例转型可能失败，因此Swift为as操作符提供了两种形式：选项形式as?和强制形式as
//        let navigationTitleAttribute : NSDictionary = NSDictionary(object:UIColor.white, forKey:NSForegroundColorAttributeName)
    //navigationTitleAttribute as [AnyHashable: Any] as? [String : AnyObject]
       
    }
    
    //push的时候判断到子控制器的数量。当大于零时隐藏BottomBar 也就是UITabBarController 的tababar
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

    @objc fileprivate func close() {
        self.view.endEditing(true)
         self.popViewController(animated: true)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.viewControllers.count > 1
    }
    
    
}

