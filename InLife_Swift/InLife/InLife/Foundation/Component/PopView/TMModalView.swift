//
//  TMModalView.swift
//  TravelMaster
//
//  Created by tchey on 16/6/21.
//  Copyright © 2016年 NeteaseYX. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


typealias actionBlock = (Int) -> (Void)
typealias actionViewAnimateBlock = () -> ()
typealias actionViewDisappearBlock = () -> ()


class TMModalView: UIView {
    
    weak var container:UINavigationController?
    var actionClosures:actionBlock?
    var alertWindow:UIWindow?
    
    var rootView:UIView?
//    unowned let container:UINavigationController
    var allowsRotation:Bool?
    var actionViewAnimateClosures:actionViewAnimateBlock?
    var actionViewDisappearClosures:actionViewDisappearBlock?
    var actionView:UIView?
    var contentView:UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(didOrientationChanged(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func didOrientationChanged(_ notify:Notification?) -> Void {
        if !self.allowsRotation! {
            return
        }
        let orientation:UIDeviceOrientation = UIDevice.current.orientation
        self.layoutByOrientation(orientation)
    }
    
    func layoutByOrientation(_ orientation:UIDeviceOrientation) -> Void {
        if !UIDeviceOrientationIsValidInterfaceOrientation(orientation) {
            return
        }
        UIView.animate(withDuration: 0.3, animations: { 
            if UIDeviceOrientationIsLandscape(orientation) {
                if orientation == .landscapeLeft {
                    self.contentView?.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI)/2)
                }else if orientation == .landscapeRight {
                    self.contentView?.transform = CGAffineTransform(rotationAngle: -CGFloat(M_PI)/2)
                }
            }else {
                if orientation == .portrait {
                    self.contentView?.transform = CGAffineTransform(rotationAngle: 0)
                }else if orientation == .portraitUpsideDown {
                    self.contentView?.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                }
            }
        }) 
        let rect = UIScreen.main.bounds
        self.contentView?.frame = rect
        self.frame = rect
    }
    
    init(view:UIView,actionClosures:actionBlock?) {
        super.init(frame:CGRect(x: 0, y: 0, width: kMainScreenWidth, height: kMainScreenHeight))
        self.reSetActionView(view)
        self.actionClosures = actionClosures
    }
    
    func reSetActionView(_ actionView:UIView) -> Void {
        self.actionView = actionView
        self.config()
    }
    
    func config() -> Void {
        self.contentView = UIView()
        self.addSubview(self.contentView!)
        let orientation = UIDevice.current.orientation
        if UIDeviceOrientationIsValidInterfaceOrientation(orientation) && allowsRotation! {
            self.layoutByOrientation(orientation)
        }else {
            self.layoutByOrientation(.portrait)
        }
        
        self.actionView?.yx_top(top: kMainScreenWidth)
        self.contentView?.addSubview(self.actionView!)
        var c = ColorBlack
        c = c.withAlphaComponent(0)
        self.backgroundColor = c
        
        let tapGestureRecongnizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognized(_:)))
        tapGestureRecongnizer.delegate = self
        self.contentView?.addGestureRecognizer(tapGestureRecongnizer)
        
    }
    
    func tapRecognized(_ gr:UITapGestureRecognizer) -> Void {
        let p = gr.location(in: self.actionView!)
        if p.x < 0 || p.y < 0 ||  p.x > self.actionView?.frame.size.width || p.y > self.actionView?.frame.size.height  {
            self.dismissSelf()
        }
        
    }
    
    func dismissSelf() {
        if self.actionViewDisappearClosures != nil {
            self.actionViewDisappearClosures!()
            self.removeFromSuperview()
        }else {
            UIView.animate(withDuration: 0.3, animations: { 
             self.backgroundColor = UIColor.colorWithRGB(0x0, alpha: 0.0)
                self.actionView?.yx_top(top: kMainScreenHeight)
                },completion: {
                    Bool in
                    self.removeFromSuperview()
                    self.alertWindow = nil
            })
        }
    }
    
    
    func transitionToActionView(_ newActionView:UIView) -> Void {
        if self.actionView == nil {
            self.reSetActionView(newActionView)
            return
        }
        self.didOrientationChanged(nil)
        newActionView.yx_top(top: self.height1) 
        newActionView.yx_Left(left: self.x)
        self.contentView?.addSubview(newActionView)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: { 
            self.actionView?.yx_top(top: self.height1) 
            newActionView.yx_bottom(bottom: self.height1)
            }) { (Bool) in
                self.actionView?.removeFromSuperview()
                self.actionView = newActionView
        }
        
    }
    
    func showInContainer(_ navC:UINavigationController) -> Void {
        self.showInContainer(navC, actionViewOrigin: CGPoint(x: 0, y: kMainScreenHeight - self.actionView!.frame.size.height))
    }
    
    func  showInContainer(_ navC:UINavigationController,actionViewOrigin:CGPoint) -> Void {
        if navC.tabBarController != nil {
            self.rootView = navC.tabBarController?.view!
        }else {
            self.rootView = navC.view
        }
        
        self.rootView?.addSubview(self)
        if self.actionViewAnimateClosures != nil {
            self.actionViewAnimateClosures!()
        }else {
            self.container = navC
            UIView.animate(withDuration: 0.3, animations: { 
                self.backgroundColor = UIColor.colorWithRGB(0x0, alpha: 0.4)
                self.actionView?.yx_top(top: actionViewOrigin.y)
                self.actionView?.yx_Left(left: actionViewOrigin.x)
            })
        }
    }
    
   

}

extension TMModalView:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let pt = touch.location(in: self)
        if (self.actionView?.frame)!.contains(pt) {
            return false
        }
        return true
    }}
