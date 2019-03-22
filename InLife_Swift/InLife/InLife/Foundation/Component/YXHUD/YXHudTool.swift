//
//  YXHudTool.swift
//  imitateNewsDemo
//
//  Created by apple on 16/11/25.
//  Copyright © 2016年 lyx. All rights reserved.
//

import UIKit

public let DEFAULT_HIDE_DELAY = 1.5
public let LOAD_DEFAULT_TITLE:String = "请稍后..."
public let NET_LOAD_FAIL:String = "亲，请检查您的网络是否连接"
public let TEMP_NO_DATA:String  = "暂无数据"
public let NO_MONITOREQUIPMENT:String = "无监控设备"
public let WEB_ERROR:String = "网络异常"

class YXHudTool: NSObject {
    var hud:MBProgressHUD? = nil
    var isAddHud:Bool?
    var _keyBoardShow:Bool?
      static let hudTool = YXHudTool()
    
    class var share:YXHudTool{
        return hudTool
    }
    
     func sharedManger() ->MBProgressHUD{
        if  self.hud  == nil{
            hud = MBProgressHUD(window: UIApplication.shared.keyWindow)
            hud?.isUserInteractionEnabled = true
            isAddHud = false
        }
        return hud!
    }
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(){
        _keyBoardShow = true
    }
    
    func  keyboardWillHide(){
        _keyBoardShow = false
    }
    
    //添加到window上
    func showTextHud(text:String){
        let hudMsg = sharedManger()
        self.addHudWindow(hudMsg: hudMsg)
        if hudMsg.customView != nil {
            hudMsg.customView.removeFromSuperview()
            hudMsg.customView = nil
        }
        hudMsg.mode = MBProgressHUDMode.indeterminate
        hudMsg.labelText = text
        hudMsg.labelFont = UIFont.systemFont(ofSize: 13)
        hudMsg.show(true)
    }
    
    func showTextHud(text:String,inView:UIView){
        //这样初始化会添加到当前view上，不能对view上的视图进行操作，但可以返回，中断请求
        let hudMsg = sharedManger()
        addHudInView(hudMsg: hudMsg, inView: inView)
        
        if hudMsg.customView != nil {
            hudMsg.customView.removeFromSuperview()
            hudMsg.customView = nil
        }
        hudMsg.mode = MBProgressHUDMode.indeterminate
        hudMsg.labelText = text
        hudMsg.detailsLabelText = ""
        hudMsg.labelFont = UIFont.systemFont(ofSize: 13)
        hudMsg.show(true)
    }
    
    //将弹出框显示在view上
    func showOKHud(text:String,delay:TimeInterval,inView:UIView){
        let hudMsg = sharedManger()
        addHudInView(hudMsg: hudMsg, inView: inView)
        
        hudMsg.customView = UIImageView(image: nil)  //这里可以添加要显示的图片
        hudMsg.labelText = ""
        hudMsg.detailsLabelText = text
        hudMsg.mode = MBProgressHUDMode.customView
        hudMsg.labelFont =  UIFont.systemFont(ofSize: 13)
        hudMsg.show(true)
        hudMsg.hide(true, afterDelay: delay == 0 ?DEFAULT_HIDE_DELAY:delay)
        
        self.perform(#selector(removeHudWindow), with: nil, afterDelay: delay == 0 ?DEFAULT_HIDE_DELAY:delay)
    }
    
    //将弹出框显示在window上
    func showNOHudInWindow(text:String, delay:TimeInterval){
         let hudMsg = sharedManger()
         addHudWindow(hudMsg: hudMsg)
        hudMsg.customView = UIImageView(image: nil)  //这里可以添加要显示的图片
        hudMsg.labelText = ""
        hudMsg.detailsLabelText = text
        hudMsg.mode = MBProgressHUDMode.customView
        hudMsg.labelFont =  UIFont.systemFont(ofSize: 13)
        hudMsg.show(true)
        hudMsg.hide(true, afterDelay: delay == 0 ?DEFAULT_HIDE_DELAY:delay)
        
        self.perform(#selector(removeHudWindow), with: nil, afterDelay: delay == 0 ?DEFAULT_HIDE_DELAY:delay)
    }
    
    
    //添加到view上
    func addHudInView(hudMsg:MBProgressHUD,inView:UIView){
        if isAddHud == false {
            inView.addSubview(hudMsg)
            inView.bringSubview(toFront: hudMsg)
            isAddHud = true
        }
    }
    
    func addHudWindow(hudMsg:MBProgressHUD){
        if isAddHud == false{
            let window = (UIApplication.shared.delegate as? AppDelegate)!.window
            window?.addSubview(hudMsg)
            window?.bringSubview(toFront: hudMsg)
            isAddHud = true
        }
    }
    
    //删除hud 弹框
    func removeHudWindow(){
        sharedManger().removeFromSuperview()
        isAddHud = false
    }
    
    
    //在外部调用删除hud弹框
    func hideHud(){
        sharedManger().hide(true)
        removeHudWindow()
    }
}
