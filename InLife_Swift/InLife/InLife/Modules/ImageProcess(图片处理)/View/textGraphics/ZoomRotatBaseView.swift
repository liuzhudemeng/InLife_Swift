//
//  ZoomRotatBaseView.swift
//  InLife
//
//  Created by apple on 2017/11/20.
//  Copyright © 2017年 lyx. All rights reserved.
//

import UIKit

/*****注意区别self.frame 和self.bounds 的区别********/
@objc protocol ZoomRotatBaseDelegate:NSObjectProtocol{
    func makePasterBecomeFirstRespond(pasterId:Int)  //点击变成第一响应者
    func removePaster(pasterId:Int)    //删除某一个
}
class ZoomRotatBaseView: UIView {
    var deltaAngle:CGFloat?
    var touchStart:CGPoint?
    var minWith:CGFloat?
    var minHeight:CGFloat?
    var viewID:Int = 0
    var prevPoint:CGPoint?
    let btnW_H:CGFloat = 24
    let paster_slide:CGFloat = 120   //总高度
    weak var delegate:ZoomRotatBaseDelegate?
    var isOnFirst:Bool = true {
        didSet{
            setInOnFirst(isOn: isOnFirst)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpGesture()
        buildUI()
        buildImageOrTextUI()
    }
    
    func buildUI(){
        minWith = self.bounds.size.width/2
        minHeight = self.bounds.size.height/2
        deltaAngle = atan2(self.y+self.height1-self.hj_centerY, self.x+self.width1-self.hj_centerX)
        
        self.addSubview(deleteImageView)
        deleteImageView.frame = CGRect(x: 0, y: 0, width:btnW_H, height:btnW_H)
        salceImageView.frame = CGRect(x: self.width1 - btnW_H/2, y: self.height1 - btnW_H/2, width:btnW_H, height:btnW_H)
    }
    
    func buildImageOrTextUI(){
        
    }
    
    func setUpGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapSelf(ges:)))
        self.addGestureRecognizer(tap)
        
        let logTap = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGes(tap:)))
        self.addGestureRecognizer(logTap)
    }
    
    func tapSelf(ges:UITapGestureRecognizer){
        if (self.delegate != nil) {
            self.delegate?.makePasterBecomeFirstRespond(pasterId: viewID)
        }
    }
    
    func handleLongGes(tap:UILongPressGestureRecognizer){
        if tap.state == .ended {
//            let names = ["复制","翻转","到顶层","到底层"]
//            let images = ["popover_reply","popover_share","popover_copy","popover_report"]
//            var items = [PopoverItem]()
//            for i in 0..<names.count {
//                let item = PopoverItem.custoumMap(name: names[i], image: UIImage(named:images[i])!, selectedHandler: { (popoverItem) in
//                    HHLog("点击\(popoverItem.name)")
//                })
//                items.append(item as! PopoverItem)
//            }
//            let popover = YXPopoverView(frame: CGRect.zero)
//            popover.showAtPoint(point: tap.location(in: self.superview), inView:  self.superview!, items: items)
//
        }
    }

    
    func setInOnFirst(isOn:Bool){
        self.deleteImageView.isHidden = !isOn
        self.salceImageView.isHidden = !isOn
    }
    
    
    
    //删除
    func btnDeletePressed(ges:UITapGestureRecognizer){
        if (self.delegate != nil) {
            self.delegate?.removePaster(pasterId: viewID)
        }
    }
    
    //缩放
    func  btnTranslate(ges:UIPanGestureRecognizer){
        if ges.state == .began {
            prevPoint = ges.location(in: self)
            self.setNeedsDisplay()
        }else if ges.state == .changed{
            if self.bounds.size.width < minWith! || self.bounds.size.height < minHeight! {
                self.bounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: minWith!+1, height: minHeight!+1)
                prevPoint = ges.location(in: self)
            }else{
                let point = ges.location(in: self)
                let wChang = point.x - prevPoint!.x
                let wRatioChange =  wChang/self.bounds.size.width
                let hChange = wRatioChange * self.bounds.size.height
                
                if  abs(wChang) > 50 || abs(hChange) > 50{
                    prevPoint = ges.location(ofTouch: 0, in: self)
                    return
                }
                
                var finalWidth = self.bounds.size.width + wChang
                var finalHeight = self.bounds.size.height + wChang
                if finalWidth > paster_slide * (1+0.5)
                {
                    finalWidth = paster_slide*(1+0.5)
                }
                if finalWidth < paster_slide * (1-0.5)
                {
                    finalWidth = paster_slide*(1-0.5)
                }
                if finalHeight > paster_slide * (1+0.5)
                {
                    finalHeight = paster_slide*(1+0.5)
                }
                if finalHeight < paster_slide * (1-0.5)
                {
                    finalHeight = paster_slide*(1-0.5)
                }
                self.bounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: finalWidth, height: finalHeight)
                
                self.salceImageView.frame = CGRect(x: self.bounds.size.width-btnW_H, y: self.bounds.size.height-btnW_H, width: btnW_H, height: btnW_H)
                prevPoint = ges.location(ofTouch: 0, in: self)
            }
            
            //Rotaion
            let ang = atan2(ges.location(in: self.superview).y - self.hj_centerY, ges.location(in: self.superview).x - self.hj_centerX)
            let angleDiff = deltaAngle! - ang
            self.transform = CGAffineTransform.init(rotationAngle: -angleDiff)
            self.setNeedsDisplay()
            
        }else if ges.state == .ended {
            prevPoint = ges.location(in: self)
            self.setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        touchStart = touch?.location(in: self.superview)
    }
    
    
    //移动
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchLocation = touches.first?.location(in: self)
        if salceImageView.frame.contains(touchLocation!) {
            return
        }
        let touch = touches.first?.location(in: self.superview)
        translateUsingTouchLocation(touchPoint: touch)
        touchStart = touch
    }
    
    //确保移动时不超出屏幕
    func translateUsingTouchLocation(touchPoint:CGPoint?){
        var newCenter = CGPoint(x: self.center.x + touchPoint!.x - touchStart!.x, y: self.center.y + touchPoint!.y - touchStart!.y)
        let midPointX = self.bounds.midX
        if newCenter.x > self.superview!.width1 - midPointX + paster_slide/2 {
            newCenter.x = self.superview!.width1 - midPointX + paster_slide/2
        }
        
        if newCenter.x < midPointX - paster_slide/2 {
            newCenter.x = midPointX - paster_slide/2
        }
        let midPointY = self.bounds.midY
        if newCenter.y > self.superview!.height1 - midPointY + paster_slide/2 {
            newCenter.y = self.superview!.height1 - midPointY + paster_slide/2
        }
        
        if newCenter.y < midPointY - paster_slide/2 {
            newCenter.y = midPointY - paster_slide/2
        }
        
        self.center = newCenter
    }
    
    
    fileprivate lazy var deleteImageView:UIImageView = {
        let object = UIImageView()
        object.backgroundColor = UIColor.clear
        object.image = UIImage(named: "删除")
        object.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(btnDeletePressed(ges:)))
        tap.delegate = self
        object.addGestureRecognizer(tap)
        
        return object
    }()
    
    fileprivate lazy var salceImageView:UIImageView = {
        let object = UIImageView()
        object.backgroundColor = UIColor.clear
        object.image = UIImage(named: "大小")
        object.isUserInteractionEnabled = true
        let tap = UIPanGestureRecognizer(target: self, action: #selector(btnTranslate(ges:)))
        tap.delegate = self
        object.addGestureRecognizer(tap)
        return object
    }()
    
}

extension ZoomRotatBaseView:UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
