//
//  UILabel+Extension.swift
//  imitateNewsDemo
//
//  Created by apple on 16/11/22.
//  Copyright © 2016年 lyx. All rights reserved.
//

import Foundation
import UIKit
let CATEGORY_DYNAMIC_FONT_SIZE_MAXIMUM_VALUE = 101
let CATEGORY_DYNAMIC_FONT_SIZE_MINIMUM_VALUE = 6
extension UILabel{
    
    /***设置不同的字体不同颜色（ps：字体和颜色参数必须是非空的，如果是可选的会造成崩溃错误）***/
    func setKeyWordTextArray(text:String,keyWordArray:[String],font:UIFont,color:UIColor){
        var rangeArray = [NSValue]()
        for i in 0..<keyWordArray.count
        {
            let keyString = keyWordArray[i]
            let indexString = text.range(of: keyString)
            let range = text.nsRangeFromRange(range: indexString!)
            let value = NSValue.init(range: range)
            if range.length > 0
            {
                rangeArray.append(value)
            }
        }
        let result = NSMutableAttributedString(string: text)
        for value in rangeArray {
            let keyRange = value.rangeValue
            result.addAttribute(NSForegroundColorAttributeName, value: color, range: keyRange)
            result.addAttribute(NSFontAttributeName, value:font, range: keyRange)
        }
        self.attributedText = result
    }
    
    func adjustsFontSizeToFillItsContents(){
        let text = self.text
        var i = CATEGORY_DYNAMIC_FONT_SIZE_MAXIMUM_VALUE
        while i > CATEGORY_DYNAMIC_FONT_SIZE_MINIMUM_VALUE {
            let font: UIFont? = UIFont(name: self.font.fontName, size: CGFloat(i))
            let attributedText = NSAttributedString(string: text!, attributes: [NSFontAttributeName: font!])
            let rectSize: CGRect = attributedText.boundingRect(with: CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
            if rectSize.height <= frame.height {
                (superview as? YXTextOperaView)?.fontSize = CGFloat(i - 1)
                break
            }
            i -= 1
        }
    }
    
    func adjustsFontSizeToFillRect(newBounds:CGRect){
        let text = self.text
        var i = CATEGORY_DYNAMIC_FONT_SIZE_MAXIMUM_VALUE
        while i > CATEGORY_DYNAMIC_FONT_SIZE_MINIMUM_VALUE {
            let font: UIFont? = UIFont(name:self.font.fontName, size: CGFloat(i))
            let attributedText = NSAttributedString(string: text!, attributes: [NSFontAttributeName: font!])
            let rectSize: CGRect = attributedText.boundingRect(with: CGSize(width: newBounds.width - 24 , height:  CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
            if rectSize.height <= newBounds.height{
                (superview as? YXTextOperaView)?.fontSize = CGFloat(i)
                break
            }
            i -= 1
        }

    }
    
    
    func adjustsWidthToFillItsContents(){
        let text = self.text
        if text == nil {
            return
        }
        let font = UIFont(name: self.font.fontName, size: self.font.pointSize)
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center //设置居中
        let attributedText = NSAttributedString(string: text!, attributes: [NSFontAttributeName : font!,NSParagraphStyleAttributeName: style])
        
        let rectSize = attributedText.boundingRect(with:CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.frame.height-24), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let w1 = ceilf(Float(rectSize.size.width))+24 < 80 ? Float(self.frame.size.width) : ceilf(Float(rectSize.size.width))+24
        
        let h1 = ceilf(Float(rectSize.size.height)) + 24 < 60 ? 60 : ceilf(Float(rectSize.size.height)) + 24
        var viewFrame = self.superview?.bounds
        viewFrame?.size.width = CGFloat(w1 + 24)
        viewFrame?.size.height = CGFloat(h1)
        self.superview?.bounds = viewFrame!
        
    }
}
