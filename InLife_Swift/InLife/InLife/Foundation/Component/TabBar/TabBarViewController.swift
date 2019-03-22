//
//  TabBarViewController.swift
//  YXSwiftDemo
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 lyx. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    var tabBarView:UIImageView? = nil
    var passedRiseItem = false  //这个参数是为了在初始化过rise 类型的按钮后，后面的frame都需要加上rise 的宽度
    weak var delegateA: YXTabBarViewControllerDelegate?
    let vc1 = HomeViewController()
    let vc2 = ImageProcessViewController()
    let vc3 = MyViewController()

    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        NotificationCenter.default.addObserver(self, selector: #selector(changeSelected(_:)), name: NSNotification.Name(rawValue: tabBarSwtich), object: nil)
    }
    
    
    func changeSelected(_ notification:Notification){
        let index = notification.object as?Int
        seletedBtn(index!+10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        for obj in self.tabBar.subviews {
            if obj != tabBarView {
                obj.removeFromSuperview()
            }
        }
        
        tabBarView = UIImageView(frame: self.tabBar.bounds)
        tabBarView?.isUserInteractionEnabled = true
        tabBarView?.backgroundColor = UIColor.init(white: 1.0, alpha: 0.5)
        
        self.tabBar.bringSubview(toFront: tabBarView!)
        self.tabBar.addSubview(tabBarView!)
        initCustomBtn()
    }

       func initCustomBtn(){
        let nav1:BaseNavigation = BaseNavigation(rootViewController: vc1)
        let nav2:BaseNavigation = BaseNavigation(rootViewController: vc3)
        
        self.viewControllers = [nav1,nav2]
        
        creatButtonWithNormalName("home_normal", selected: "home_highlight", title: "首页", index: 0,tabBarItemType:.YXTabBarItemNormal)
         creatButtonWithNormalName("post_normal", selected: "post_normal", title: "图片处理", index: 1,tabBarItemType:.YXTabBarItemRise)   //如果是rise 类型的tabbar ,index 要和下一个一样，即index按顺序增加，但到rise 类型的时候不增加，到下一个的时候再接着增加
        creatButtonWithNormalName("mycity_normal", selected: "mycity_highlight", title: "我的", index:1,tabBarItemType:.YXTabBarItemNormal)

    }
    

     //创建一个按钮
    fileprivate func creatButtonWithNormalName(_ normal: String, selected: String,title:String, index: Int,tabBarItemType:YXTabBarItemType) {
        let buttonW : CGFloat = (kMainScreenWidth*3/4)/CGFloat(self.viewControllers!.count)
        let publishItemWith = kMainScreenWidth/4
        let buttonH : CGFloat = tabBarView!.frame.size.height
        
        let btnW = tabBarItemType == .YXTabBarItemRise ? publishItemWith:buttonW
        let space = passedRiseItem ? publishItemWith : 0
        let customButton = YXButton(frame: CGRect(x: buttonW * CGFloat(index)+space, y: 0, width: btnW, height: buttonH))
        customButton.tabBarItemType = tabBarItemType
        if tabBarItemType != .YXTabBarItemRise {
            customButton.tag = index+10
        }else{
            passedRiseItem = true
        }
        customButton.setTitle(title, for: UIControlState())
        customButton.setTitleColor(Title_gray, for: UIControlState())
        customButton.setTitleColor(Color_Nav, for: .selected)
        customButton.setTitleColor(Color_Nav, for: .highlighted)
        customButton.setImage(UIImage.init(named: normal), for: UIControlState())
        customButton.setImage(UIImage.init(named: selected), for: .highlighted)
        customButton.setImage(UIImage.init(named: selected), for: .selected)
//        customButton.imageView!.contentMode = .center
//        customButton.titleLabel?.textAlignment = .center
        customButton.addTarget(self, action: #selector(changeViewController(_:)), for: .touchUpInside)
        customButton.titleLabel!.font =  UIFont.systemFont(ofSize: 10)
        
        self.tabBar.addSubview(customButton)
        if index == 0 {
            lastBtu = customButton
            customButton.isSelected = true
        }
    }
    
    // 按钮被点击时调用
    func changeViewController(_ sender:YXButton)  {
        if sender.tabBarItemType == .YXTabBarItemRise {
            if self.delegateA != nil {
                delegateA?.tabBarDidSelectedRiseButton()
            }
            return
        }
        seletedBtn(sender.tag)
        
    }
    
    func seletedBtn(_ index:NSInteger) {
        let sender : YXButton = (self.tabBar.viewWithTag(index) as?(YXButton))!
        if self.selectedIndex != index {
            self.selectedIndex = index - 10
            lastBtu.isSelected = !lastBtu.isSelected
            lastBtu = sender
            lastBtu.isSelected = true
        }
    }
    
    //懒加载
    fileprivate lazy var lastBtu : YXButton = {
        let lastBtu = YXButton()
        return lastBtu
    }()
    

}


@objc protocol YXTabBarViewControllerDelegate:NSObjectProtocol{
    func tabBarDidSelectedRiseButton()
}
