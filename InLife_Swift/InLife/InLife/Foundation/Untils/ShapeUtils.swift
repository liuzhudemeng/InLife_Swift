//
//  ShapeUtils.swift
//  InLife
//
//  Created by apple on 2017/11/15.
//  Copyright © 2017年 lyx. All rights reserved.
//

import UIKit

let PI = 3.14159265358979323846
let LineW : CGFloat = 2.0
let clearRect:CGRect = CGRect(x: 0, y: 0, width: kMainScreenWidth, height: kMainScreenHeight)
enum TriangleDirection : Int {
    case up = 0         //向上
    case down           //向下
    case left           //向左
    case right          //向右
}
class ShapeUtils: NSObject {
    /*
     *画圆
     *context   当前上下文
     *fillColor 填充色
     *radius    半径
     *point     圆心点坐标
     *isSolid   是否实心      true---- 实心； false ---- 空心
     *isSemi    是否半圆      true----半圆  ； false --- 圆
     */
    
    class func drawCircle(_ context: CGContext, fillcolor fillColor: UIColor, radius: CGFloat, point: CGPoint,isSolid:Bool,isSemi:Bool)  ->UIImage{
        context.clear(clearRect)
        let endWhere = isSemi ?CGFloat(PI): CGFloat(PI*2)
        
        context.addArc(center: point, radius: radius, startAngle: 0, endAngle: endWhere, clockwise: false) //true 为顺时针；false 为逆时针
        if isSolid {
            context.setFillColor(fillColor.cgColor)
             context.fillPath()
        }else{
             context.setLineWidth(LineW)
             context.setStrokeColor(fillColor.cgColor)
             context.strokePath()
        }
       
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image!
    }
    
    /*
     ＊画矩形
     *context   当前上下文
     *color     填充色
     *rect      矩形位置的大小
     *isSolid   是否实心      true---- 实心； false ---- 空心
     */
    class func drawRect(_ context: CGContext?, color: UIColor, rect: CGRect,isSolid:Bool)  ->UIImage{
        context?.clear(clearRect) //必须要先清空画布，要不然在相同的位置画会有之前画的痕迹，然后就会造成图像重叠
        context?.setShouldAntialias(true)
        context?.addRect(rect)
        if isSolid {
             context?.setFillColor(color.cgColor)
             context?.drawPath(using: .fill)
        }else{
            context?.setLineWidth(LineW)
            context?.setStrokeColor(color.cgColor)
            context?.drawPath(using: .stroke)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image!
    }

    /*
     绘制圆角矩形
     *context       当前上下文
     *lineColor     边框颜色
     *fillColor     填充颜色 (如果想要空心的话，设置填充颜色为clear 即可)
     *lineWidth     边框宽度
     *cornerRadius  圆角半径
     *rect          矩形位置和大小
     */
    class func drawRoundedRect(_ context: CGContext?, lineColor: UIColor, fill fillColor: UIColor, lineWidth: CGFloat, cornerRadius: CGFloat, rect: CGRect)  ->UIImage{
        let x: CGFloat = rect.origin.x
        let y: CGFloat = rect.origin.y
        let width: CGFloat = rect.size.width
        let height: CGFloat = rect.size.height
        context?.clear(clearRect)
        context?.setShouldAntialias(true)
        context?.setLineWidth(lineWidth)
        context?.setStrokeColor(lineColor.cgColor)
        context?.setFillColor(fillColor.cgColor)
        context?.move(to: CGPoint(x: x + width, y: y + height - cornerRadius))
        //从右下角开始画起
        context?.addArc(tangent1End: CGPoint(x: x + width, y: y + height), tangent2End: CGPoint(x: x + width - cornerRadius, y: y + height), radius: cornerRadius)
        //右下角的圆角
        context?.addArc(tangent1End: CGPoint(x: x, y: y + height), tangent2End: CGPoint(x: x, y: y + height - cornerRadius), radius: cornerRadius)
        //左下角的圆角
        context?.addArc(tangent1End: CGPoint(x: x, y: y), tangent2End: CGPoint(x: x + cornerRadius, y: y), radius: cornerRadius)
        //左上角的圆角
        context?.addArc(tangent1End: CGPoint(x: x + width, y: y), tangent2End: CGPoint(x: x + width, y: y + height - cornerRadius), radius: cornerRadius)
        //右上角的圆角
        context?.closePath()
        context?.drawPath(using: .fillStroke)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image!
    }
    
    /*
     *画正三角形
     *context       当前上下文
     *lineColor     边框颜色
     *fillColor     填充颜色 (如果想要空心的话，设置填充颜色为clear 即可)
     *centerPoint   正三角形中心
     *length        边长
     *lineWidth     边框宽度
     *TriangleDirection 三角形方向
     */
    class func drawTriangle(_ context: CGContext?, lineColor: UIColor, fill fillColor: UIColor, center centerPoint: CGPoint, length: CGFloat, lineWidth: CGFloat, direction: TriangleDirection) ->UIImage{
        context?.clear(clearRect)
        context?.setShouldAntialias(true)
        context?.setLineWidth(lineWidth)
        context?.setStrokeColor(lineColor.cgColor)
        context?.setFillColor(fillColor.cgColor)
        let radius: CGFloat = length * sqrt(3) / 3.0          //正三角形的外接圆半径
        let distance: CGFloat = length * sqrt(3) / 6.0          //正三角形的圆心距离底边的距离
        let halfLength: CGFloat = length / 2.0
        var points = [CGPoint](repeating: CGPoint.zero, count: 3)
        switch direction {
        case .up:
            points[0] = CGPoint(x: centerPoint.x, y: centerPoint.y - radius)
            points[1] = CGPoint(x: centerPoint.x - halfLength, y: centerPoint.y + distance)
            points[2] = CGPoint(x: centerPoint.x + halfLength, y: centerPoint.y + distance)
            break
        case .down:
            points[0] = CGPoint(x: centerPoint.x, y: centerPoint.y + radius)
            points[1] = CGPoint(x: centerPoint.x - halfLength, y: centerPoint.y - distance)
            points[2] = CGPoint(x: centerPoint.x + halfLength, y: centerPoint.y - distance)
            break
        case .left:
            points[0] = CGPoint(x: centerPoint.x - radius, y: centerPoint.y)
            points[1] = CGPoint(x: centerPoint.x + distance, y: centerPoint.y - halfLength)
            points[2] = CGPoint(x: centerPoint.x + distance, y: centerPoint.y + halfLength)
            break
        case .right:
            points[0] = CGPoint(x: centerPoint.x + radius, y: centerPoint.y)
            points[1] = CGPoint(x: centerPoint.x - distance, y: centerPoint.y - halfLength)
            points[2] = CGPoint(x: centerPoint.x - distance, y: centerPoint.y + halfLength)
            break
        }
        context?.addLines(between: points)
        context?.closePath()
        context?.drawPath(using: .fillStroke)
        context?.drawPath(using: .stroke)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image!
    }
    
    
    /*
     *画椭圆
     *context   当前上下文
     *fillColor 填充色
     *radius    半径
     *point     圆心点坐标
     *isSolid   是否实心      true---- 实心； false ---- 空心
     */
    class func drawEllipse(_ context: CGContext, fillcolor fillColor: UIColor, rect: CGRect,isSolid:Bool)  ->UIImage{
        context.clear(clearRect)
       context.addEllipse(in: rect)
        if isSolid {
            context.setFillColor(fillColor.cgColor)
            context.fillPath()
        }else{
            context.setLineWidth(LineW)
            context.setStrokeColor(fillColor.cgColor)
            context.strokePath()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image!
    }
    
    /*
     *画菱形
     *context   当前上下文
     *fillColor 填充色
     *radius    半径
     *point     圆心点坐标
     *isSolid   是否实心      true---- 实心； false ---- 空心
     */
    class func drawDiamond(_ context: CGContext, fillcolor fillColor: UIColor, rect: CGRect,isSolid:Bool)  ->UIImage{
        context.clear(clearRect)
        context.move(to: CGPoint(x: rect.origin.x + rect.width/2, y: rect.origin.y-rect.height/2))
        context.addLine(to: CGPoint(x:rect.origin.x + rect.width , y: rect.origin.y))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.width/2, y: rect.origin.y+rect.height/2))
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.width/2, y: rect.origin.y-rect.height/2))
        if isSolid {
            context.setFillColor(fillColor.cgColor)
            context.fillPath()
        }else{
            context.setLineWidth(LineW)
            context.setStrokeColor(fillColor.cgColor)
            context.strokePath()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image!
    }

}
