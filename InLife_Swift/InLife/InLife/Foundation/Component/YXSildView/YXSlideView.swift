//
//  YXSlideView.swift
//  imitateNewsDemo
//
//  Created by apple on 16/11/23.
//  Copyright © 2016年 lyx. All rights reserved.
//

import UIKit

fileprivate let kPanSwitchOffsetThreshold : CGFloat = 50.0
class YXSlideView: UIView {
    var selectedIndex:NSInteger?{
        didSet{
            if selectedIndex != oldIndex_ && selectedIndex != nil {
                switchTo(index: selectedIndex!)
            }
        }
    }
    var baseViewController:UIViewController?
    weak var delegate:YXSildeViewDelegate?
    weak var dataSource:YXSlideViewDataSource?
    
    
    var oldIndex_:NSInteger = -1
    var panToIndex_:NSInteger?
    var pan_:UIPanGestureRecognizer?
    var panStartPoint_:CGPoint?
    var oldCtrl_:UIViewController?
    var willCtrl_:UIViewController?
    
    var isSwitching_:Bool = false
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit(){
        pan_ = UIPanGestureRecognizer(target: self, action:#selector(panHandler(pan:)))
        self.addGestureRecognizer(pan_!)
    }
    
    
    func panHandler(pan:UIPanGestureRecognizer){
        if oldIndex_ < 0 {
            return
        }
        let point = pan.translation(in: self)
        if pan.state == UIGestureRecognizerState.began
        {
            panStartPoint_ = point
            oldCtrl_?.beginAppearanceTransition(false, animated: true)
        }else if pan.state == UIGestureRecognizerState.changed
        {
            var panToIndex = -1
            let offsex = point.x - panStartPoint_!.x
            if offsex > 0 {
                panToIndex = oldIndex_ - 1
            }else if offsex < 0 {
                panToIndex = oldIndex_ + 1
            }
            
            if panToIndex != panToIndex_ {
                if willCtrl_ != nil {
                    removeWill()
                }
            }
            
            if panToIndex < 0 || panToIndex >= dataSource!.numberOfControllersInYXSlideView(sender: self) {
                panToIndex_ = panToIndex
                repositionForOffsetX(offsetX: offsex/2.0)
            }else{
                if panToIndex != panToIndex_ {
                    willCtrl_ = self.dataSource?.yxSlideView(sender: self, index: panToIndex)
                    baseViewController?.addChildViewController(willCtrl_!)
                    willCtrl_?.willMove(toParentViewController: baseViewController)
                    willCtrl_?.beginAppearanceTransition(true, animated: true)
                    self.addSubview(willCtrl_!.view)
                    panToIndex_ = panToIndex
                }
                repositionForOffsetX(offsetX: offsex)
            }
        }else if pan.state == UIGestureRecognizerState.ended{
            let offsetx = point.x - panStartPoint_!.x
            if panToIndex_! >= 0 && panToIndex_! < dataSource!.numberOfControllersInYXSlideView(sender: self) && panToIndex_ != oldIndex_ {
                if fabs(offsetx) > kPanSwitchOffsetThreshold
                    || fabs(pan_!.velocity(in: self).x) > 160 {   //增加快速、短距离滑动识别
                    let animatedTime = fabs(self.frame.size.width - fabs(offsetx))/self.frame.size.width * 0.4
                    UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
                    UIView.animate(withDuration: TimeInterval(animatedTime), animations: {
                        self.repositionForOffsetX(offsetX: offsetx > 0 ?self.bounds.size.width:-self.bounds.size.width)
                        }, completion: { (flag) in
                            self.removeOld()
                            if self.panToIndex_! >= 0 && self.panToIndex_! < self.dataSource!.numberOfControllersInYXSlideView(sender: self){
                                self.willCtrl_?.endAppearanceTransition()
                                self.willCtrl_?.didMove(toParentViewController: self.baseViewController)
                                self.oldIndex_ = self.panToIndex_!
                                self.oldCtrl_ = self.willCtrl_
                                self.willCtrl_ = nil
                                self.panToIndex_ = -1
                            }
                            if self.delegate != nil {
                                self.delegate?.yxSildeView(slide: self, toIndex: self.oldIndex_)
                            }
                    })
                }else{
                    backToOldWithOffset(offsetx: offsetx)
                }
            }else{
                backToOldWithOffset(offsetx: offsetx)
            }
        }
    }
    
    
    func  removeOld(){
        removeCtrl(ctrl: oldCtrl_)
        oldCtrl_?.endAppearanceTransition()
        oldCtrl_ = nil
        oldIndex_ = -1
    }
    
    
    func removeWill(){
        willCtrl_?.beginAppearanceTransition(false, animated: false)
        removeCtrl(ctrl: willCtrl_!)
        willCtrl_?.endAppearanceTransition()
        willCtrl_ = nil
        panToIndex_ = -1
    }
    
    func removeCtrl(ctrl:UIViewController?) -> Void {
        guard let vc = ctrl else {
            return
        }
        vc.willMove(toParentViewController: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }
    
    func repositionForOffsetX(offsetX:CGFloat) {
        var x:CGFloat = 0.0
        if panToIndex_! < oldIndex_ {
            x = self.bounds.origin.x - self.bounds.size.width + offsetX
        }else if panToIndex_! > oldIndex_ {
            x = self.bounds.origin.x + self.bounds.size.width + offsetX
        }
        let oldvc = oldCtrl_
    
        oldvc?.view.frame = CGRect(x: self.bounds.origin.x + offsetX, y: self.bounds.origin.y, width: self.bounds.width, height:  self.bounds.height)
        if panToIndex_! >= 0 && panToIndex_! < dataSource!.numberOfControllersInYXSlideView(sender: self) {
            let vc = willCtrl_
            vc?.view.frame = CGRect(x: x, y: self.bounds.origin.y, width: self.bounds.width, height:  self.bounds.height)
        }
        
        if delegate != nil {
            delegate?.yxSildeView?(slide: self, oldIndex: oldIndex_, toIndex: panToIndex_!, percent: fabs(offsetX)/self.bounds.size.width)
        }
        
    }
    
    func backToOldWithOffset(offsetx:CGFloat) -> Void {
        let animatedTime:TimeInterval = 0.3
        UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
        UIView.animate(withDuration: animatedTime, animations: {
            self.repositionForOffsetX(offsetX: 0)
            }) { (finish) in
                if self.panToIndex_! >= 0 && self.panToIndex_! < self.dataSource!.numberOfControllersInYXSlideView(sender: self) && self.panToIndex_ != self.oldIndex_{
                    self.oldCtrl_?.beginAppearanceTransition(true, animated: false)
                    self.removeWill()
                    self.oldCtrl_?.endAppearanceTransition()
                }
                if self.delegate != nil {
                    self.delegate?.yxSildeView(slide: self, oldIndex: self.oldIndex_)
                }
        }
    }
    
    
    func  switchTo(index:NSInteger){
        if index == oldIndex_ {
            return
        }
        if isSwitching_ {
            return
        }
        
        if oldCtrl_ != nil && oldCtrl_?.parent == self.baseViewController {
            isSwitching_ = true
            let oldvc = oldCtrl_!
            guard let newvc = self.dataSource?.yxSlideView(sender: self, index: index) else {
                return
            }
            oldvc.willMove(toParentViewController: nil)
            baseViewController?.addChildViewController(newvc)
            
            let nowRect = oldvc.view.frame
            let leftRect = CGRect(x: nowRect.origin.x-nowRect.size.width, y: nowRect.origin.y, width: nowRect.size.width, height: nowRect.size.height)
            let rightRect = CGRect(x: nowRect.origin.x+nowRect.size.width, y: nowRect.origin.y, width: nowRect.size.width, height: nowRect.size.height)
            var newStartRect:CGRect = CGRect.zero
            var oldEndRect:CGRect  = CGRect.zero
            if index > oldIndex_{
                newStartRect = rightRect
                oldEndRect = leftRect
            }else{
                newStartRect = leftRect
                oldEndRect = rightRect
            }
            newvc.view.frame = newStartRect
            newvc.willMove(toParentViewController: baseViewController)
            self.baseViewController?.transition(from: oldvc, to: newvc, duration: 0.4, options: UIViewAnimationOptions(rawValue: UInt(0)), animations: {
                newvc.view.frame = nowRect
                oldvc.view.frame = oldEndRect
                }, completion: { (flag) in
                    oldvc.removeFromParentViewController()
                    newvc.didMove(toParentViewController: self.baseViewController)
                    if self.delegate != nil {
                        self.delegate?.yxSildeView(slide: self, toIndex: index)
                    }
                    self.isSwitching_ = false
            })
            oldIndex_ = index
            oldCtrl_ = newvc
        }else{
            showAt(index: index)
        }
        willCtrl_ = nil
        panToIndex_ = -1
    }
    
    
    func showAt(index:NSInteger){
        if oldIndex_ != index {
            removeOld()
            guard let vc = dataSource?.yxSlideView(sender: self, index: index) else {
                return
            }
            self.baseViewController?.addChildViewController(vc)
            vc.view.frame = self.bounds
            self.addSubview(vc.view)
            vc.didMove(toParentViewController: self.baseViewController)
            oldIndex_ = index
            oldCtrl_ = vc
            
            if self.delegate != nil {
                self.delegate?.yxSildeView(slide: self, toIndex: index)
            }
        }
    }
   
}


@objc protocol YXSlideViewDataSource:NSObjectProtocol{
    
    func numberOfControllersInYXSlideView(sender:YXSlideView) -> NSInteger
    func yxSlideView(sender:YXSlideView,index:NSInteger) -> UIViewController?
}

@objc protocol YXSildeViewDelegate:NSObjectProtocol{
    @objc optional
    func yxSildeView(slide:YXSlideView,oldIndex:NSInteger,toIndex:NSInteger,percent:CGFloat)
    func yxSildeView(slide:YXSlideView,toIndex:NSInteger)
    func yxSildeView(slide:YXSlideView,oldIndex:NSInteger)
}
