//
//  YXTextOperaView.swift
//  InLife
//
//  Created by apple on 2017/11/21.
//  Copyright © 2017年 lyx. All rights reserved.
//

import UIKit
var lastTouchedView:YXTextOperaView?
class YXTextOperaView: UIView {
    let inset:CGFloat = 12
    var initialBounds:CGRect!
    var initialDistance:CGFloat!
    var beginningPoint:CGPoint!
    var beginningCenter:CGPoint!
    var prevPoint:CGPoint!
    var touchLocation:CGPoint!
    var deltaAngle:CGFloat = 0
    
    var isOnFirst:Bool = true
    var startTransform:CGAffineTransform?
    var beginBounds:CGRect!
    weak var delegate:YXTextOperaViewDelegate?
 
    
    var border:CAShapeLayer!
    var fontName:String!{
        didSet{
            label.font = UIFont(name: fontName, size: fontSize)
            if label.text != nil {
                label.adjustsWidthToFillItsContents()
            }
        }
    }
    var fontColor:UIColor!{
        didSet{
            label.textColor = fontColor
        }
    }
    var fontSize:CGFloat = 14{
        didSet{
            label.font = UIFont(name: fontName, size: fontSize)
            label.adjustsWidthToFillItsContents()
        }
    }
    
    var string:String?{
        didSet{
            label.text = string
            label.adjustsWidthToFillItsContents()
        }
    }
    
    var deleteViewIsShow:Bool = true{
        didSet{
            deleteImageView.isHidden = deleteViewIsShow
            deleteImageView.isUserInteractionEnabled = deleteViewIsShow
        }
    }
    
    var rotateViewIsShow:Bool = true{
        didSet{
            salceImageView.isHidden = rotateViewIsShow
            salceImageView.isUserInteractionEnabled = rotateViewIsShow
        }
    }
    
    var showTextShow:Bool = false{
        didSet{
            if showTextShow {
                self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowOffset = CGSize(width: 0, height: 5)
                self.layer.shadowOpacity = 1.0
                self.layer.shadowRadius = 4.0
            }else{
                self.layer.shadowColor = UIColor.clear.cgColor
                self.layer.shadowOffset = CGSize.zero
                self.layer.shadowOpacity = 0.0
                self.layer.shadowRadius = 0.0
            }
        }
    }
    


    override init(frame: CGRect) {
        let minWith = 1+inset*2
        var minFrame = frame
        minFrame.size.width = frame.size.width < minWith ? minWith:frame.size.width
        minFrame.size.height = frame.size.height < minWith ? minWith:frame.size.height
        super.init(frame: minFrame)
        buildUI()
        setUpGesture()
    }
    
    
    override func layoutSubviews() {
        if (label.text != nil) {
            border.path = UIBezierPath(rect: label.bounds).cgPath
            border.frame = label.bounds
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        refresh()
    }
    
    func buildUI(){
        self.backgroundColor = UIColor.clear
        self.addSubview(label)
        self.addSubview(deleteImageView)
        self.addSubview(salceImageView)
        
        
        deleteImageView.frame = CGRect(x: 0, y: 0, width:inset*2, height:inset*2)
        salceImageView.frame = CGRect(x: self.bounds.size.width - inset*2, y: self.bounds.size.height - inset*2, width:inset*2, height:inset*2)
        label.frame = self.bounds.insetBy(dx: 10, dy: 10)
        border = CAShapeLayer()
        border.strokeColor = UIColor.red.cgColor
        border.fillColor = nil
        border.lineDashPattern = [4,3]
    }
    
    
    func setUpGesture(){
        let moveGesture = UIPanGestureRecognizer(target: self, action: #selector(moveViewGesture(recognizer:)))
        self.addGestureRecognizer(moveGesture)
        let doubleGesture  = UITapGestureRecognizer(target: self, action: #selector(doubleClickEdit(recognizer:)))
        doubleGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleGesture)
        
        let singleGestrue = UITapGestureRecognizer(target: self, action: #selector(singleTapShowHide(recognizer:)))
        self.addGestureRecognizer(singleGestrue)
        
    }
    
    func refresh(){
        if (self.superview != nil) {
            let scale = CGAffineTransformGetScale(t: self.superview!.transform)
            let t = CGAffineTransform(scaleX: scale.width, y: scale.height)
            deleteImageView.transform = t.inverted()
            salceImageView.transform = t.inverted()
            if isOnFirst{
                label.layer.addSublayer(border)
            }else{
                border.removeFromSuperlayer()
            }
        }
    }
    
    
    func hideHandles(){
        lastTouchedView = nil
        isOnFirst = false
        if deleteViewIsShow {
            deleteImageView.isHidden = true
        }
        if rotateViewIsShow {
            salceImageView.isHidden = true
        }
        refresh()
        if (delegate != nil) {
            delegate?.labelViewDidHideEditingHandles(view: self)
        }
    }
    
    func showIsOnFirstHandels(){
         lastTouchedView?.hideHandles()
        isOnFirst = true
        lastTouchedView = self
        if deleteViewIsShow {
             deleteImageView.isHidden = false
        }
        if rotateViewIsShow {
            salceImageView.isHidden = false
        }
        refresh()
        if delegate != nil {
            delegate?.labelViewDidShowEditingHandles(view: self)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
 
    /***
    //MARK:手势方法
    ****/
    
    //移动方法
    func moveViewGesture(recognizer:UITapGestureRecognizer){
        if !isOnFirst {
            showIsOnFirstHandels()
        }
        touchLocation = recognizer.location(in: self.superview)
        if recognizer.state == .began {
            beginningPoint = touchLocation
            beginningCenter = self.center
            self.center = CGPoint(x: beginningCenter.x + (touchLocation.x - beginningPoint.x), y: beginningCenter.y + (touchLocation.y - beginningPoint.y))
            beginBounds = self.bounds
            if  delegate != nil  {
                delegate?.lableViewDidBeginEditing(view: self)
            }
        }else if recognizer.state == .changed{
         self.center = CGPoint(x: beginningCenter.x + touchLocation.x - beginningPoint.x, y: beginningCenter.y + touchLocation.y - beginningPoint.y)
            if delegate != nil {
                delegate?.lableViewDidChangeEditing(view: self)
            }
        }else if recognizer.state == .ended {
            self.center = CGPoint(x: beginningCenter.x + touchLocation.x - beginningPoint.x, y: beginningCenter.y + touchLocation.y - beginningPoint.y)
            if delegate != nil {
                delegate?.labelViewDidEndEditing(view: self)
            }
        }
        prevPoint = touchLocation
    }
    
    //双击编辑
    func doubleClickEdit(recognizer:UITapGestureRecognizer){
        
    }
    
    
    //单击显示隐藏
    func singleTapShowHide(recognizer:UITapGestureRecognizer){
        if isOnFirst{
            hideHandles()
            self.superview?.bringSubview(toFront: self)
        }else{
            showIsOnFirstHandels()
        }
    }

    
    /// 删除方法
    func removeViewPanGesture(recognizer:UITapGestureRecognizer){
        self.removeFromSuperview()
        if delegate != nil {
            delegate?.labelViewDidClose(view: self)
        }
    }
    /// 缩放旋转方法
    func rotateViewPanGesture(recognizer:UIPanGestureRecognizer){
        touchLocation = recognizer.location(in: self.superview)
        let center = CGRectGetCenter(rect: self.frame)
        if recognizer.state == .began {
            deltaAngle = atan2(touchLocation.y - center.y, touchLocation.x - center.x) - CGAffineTransformGetAngle(t: self.transform)
            initialBounds = self.bounds
            initialDistance = CGPointGetDistance(point1: center, point2: touchLocation)
            if delegate != nil{
                delegate?.labelViewDidStartEditing(view: self)
            }
        }else if recognizer.state == .changed{
            let ang = atan2(touchLocation.y - center.y, touchLocation.x - center.x)
            let angleDiff = deltaAngle - ang
            self.transform = CGAffineTransform(rotationAngle: -angleDiff)
            self.setNeedsDisplay()
            let scale = sqrt(CGPointGetDistance(point1: center, point2: touchLocation)/initialDistance)
            let scaleRect = CGRectScale(rect: initialBounds, wScale: scale, hScale: scale)
            if scaleRect.size.width >= 1+inset*2+20 && scaleRect.size.height >= 1+inset*2+20{
                if fontSize < 100 || scaleRect.width < self.bounds.width {
                    label.adjustsFontSizeToFillRect(newBounds: scaleRect)
//                    self.bounds = scaleRect
                }
            }
            if delegate != nil {
                delegate?.lableViewDidChangeEditing(view: self)
            }
        }else if recognizer.state == .ended {
            if delegate != nil {
                delegate?.labelViewDidEndEditing(view: self)
            }
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    lazy var label:UILabel = {
        let object = UILabel()
        object.backgroundColor = UIColor.clear
        object.textColor = UIColor.white
        object.font = systemFont(14)
        object.textAlignment = .center
        object.sizeToFit()
        object.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return object
    }()
    
    
    fileprivate lazy var deleteImageView:UIImageView = {
        let object = UIImageView()
        object.backgroundColor = UIColor.clear
        object.image = UIImage(named: "删除")
        object.isUserInteractionEnabled = true
        object.autoresizingMask = [.flexibleRightMargin,.flexibleBottomMargin]
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeViewPanGesture(recognizer:)))
        tap.delegate = self
        object.addGestureRecognizer(tap)
        
        return object
    }()
    
    fileprivate lazy var salceImageView:UIImageView = {
        let object = UIImageView()
        object.backgroundColor = UIColor.clear
        object.image = UIImage(named: "大小")
        object.isUserInteractionEnabled = true
        let tap = UIPanGestureRecognizer(target: self, action: #selector(rotateViewPanGesture(recognizer:)))
        tap.delegate = self
        object.addGestureRecognizer(tap)
        object.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        return object
    }()
}

extension YXTextOperaView:UIGestureRecognizerDelegate{
    
}


@objc protocol YXTextOperaViewDelegate:NSObjectProtocol{
    func lableViewDidBeginEditing(view:YXTextOperaView)  //开始编辑的时候
    func lableViewDidChangeEditing(view:YXTextOperaView)
    func labelViewDidEndEditing(view:YXTextOperaView)
    
    func labelViewDidClose(view:YXTextOperaView)  //删除当前视图的时候
    
    func labelViewDidShowEditingHandles(view:YXTextOperaView)
    func labelViewDidHideEditingHandles(view:YXTextOperaView)
    func labelViewDidStartEditing(view:YXTextOperaView)
}
