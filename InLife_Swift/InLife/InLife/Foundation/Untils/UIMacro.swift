//
//  UIMacro.swift
//  BaiduMapDemo
//
//  Created by Sheng's iMac on 16/6/14.
//  Copyright © 2016年 Odom Sheng. All rights reserved.
//
import UIKit
// MARK:image
public func ImageNamed(_ x:String) -> UIImage {
//    return UIImage(imageLiteral:x)
    return UIImage(named: x)!
}

public func ImageStretch(_ name:String,inset:UIEdgeInsets) -> UIImage {
    return ImageNamed(name).resizableImage(withCapInsets: inset,resizingMode:.stretch)
}



public let kMainScreenWidth = UIScreen.main.bounds.size.width
public let kMainScreenHeight = UIScreen.main.bounds.size.height

private func adjustValue(_ value: CGFloat) -> CGFloat{
    var result = floor(value)
    let interval: CGFloat = 0.5
    var gap = value - result
    while gap > 0{
        result += interval
        gap -= interval
    }
    return result
}

// ratio（以320的屏宽为基准）
public let Ratio_Scale: CGFloat = kMainScreenWidth / CGFloat(320)

public func UIValue(_ x: CGFloat) -> CGFloat {
    return adjustValue(x * Ratio_Scale)
}

// ratio (以375的屏宽为基准)
public let Ratio2_Scale: CGFloat = kMainScreenWidth / CGFloat(375)

public func UIScale(_ x: CGFloat) -> CGFloat {
    return adjustValue(x * Ratio2_Scale)
}

public func UIScaleHeight(_ x: CGFloat) -> CGFloat {
    return adjustValue(x * kMainScreenHeight / CGFloat(667))
}

public let ScreenScale: CGFloat = UIScreen.main.scale

// 这里是屏幕上最终的像素值，比如分割线总是1，不管@2x @3x 屏幕
public func ScreenPixel(_ x: CGFloat) -> CGFloat {
    return x / ScreenScale
}

public let HeightSeperatorLine: CGFloat = ScreenPixel(1)


// MARK: - Font
public func Font_Sys_Bold(_ fontSize: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: fontSize)
}

public func Font_Sys(_ fontSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: fontSize)
}

public func Font_Default(_ fontSize: CGFloat) -> UIFont {
    return Font_Sys(fontSize)
}

public func Font_Default_Bold(_ fontSize: CGFloat) -> UIFont {
    return Font_Sys_Bold(fontSize)
}

// 320
public let ratio_fontScale: CGFloat = CGFloat((Float(Ratio_Scale) * 10) / 10)

public func FontBoldR(_ fontSize: CGFloat) -> UIFont {
    return Font_Default_Bold(ratio_fontScale * fontSize)
}

public func Font(_ fontSize: CGFloat) -> UIFont {
    return Font_Default(fontSize)
}

public func FontRDeprecated(_ fontSize: CGFloat) -> UIFont {
    return Font_Default(ratio_fontScale * fontSize)
}

// 375
public let ratio2_fontScale: CGFloat = CGFloat((Float(Ratio2_Scale) * 10) / 10)

public func FontBoldR2(_ fontSize: CGFloat) -> UIFont {
    return Font_Default_Bold(ratio2_fontScale * fontSize)
}

public func FontR(_ fontSize: CGFloat) -> UIFont {
    return Font_Default(ratio2_fontScale * fontSize)
}


public func CGAffineTransformGetScale(t: CGAffineTransform) -> CGSize {
    return CGSize(width:sqrt(t.a * t.a + t.c * t.c), height:sqrt(t.b * t.b + t.d * t.d))
}

public func CGAffineTransformGetAngle(t: CGAffineTransform) -> CGFloat {
    return atan2(t.b, t.a)
}

public func CGPointGetDistance(point1: CGPoint,point2: CGPoint) -> CGFloat {
    
    let fx = point2.x - point1.x
    let fy = point2.y - point1.y
    return sqrt((fx*fx + fy*fy))
}

public func CGRectScale(rect: CGRect,wScale: CGFloat,hScale:CGFloat) -> CGRect {
    return CGRect(x: rect.origin.x * wScale, y:  rect.origin.y * hScale, width: rect.size.width * wScale, height: rect.size.height * hScale)
}

public func CGRectGetCenter(rect: CGRect) -> CGPoint {
    return CGPoint(x: rect.minX, y: rect.midY)
}


// MARK: - Button
extension UIButton {
    
    @objc func set(image anImage: UIImage?, title: String, titlePosition: UIViewContentMode, additionalSpacing: CGFloat, state: UIControlState){
        self.imageView?.contentMode = .center
        self.setImage(anImage, for: state)
        
        positionLabelRespectToImage(title, position: titlePosition, spacing: additionalSpacing)
        
        self.titleLabel?.contentMode = .center
        self.setTitle(title, for: state)
    }
    
    fileprivate func positionLabelRespectToImage(_ title: String, position: UIViewContentMode, spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = title.size(attributes: [NSFontAttributeName: titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: -(imageSize.width / 2), left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                       right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
        
    }
}



