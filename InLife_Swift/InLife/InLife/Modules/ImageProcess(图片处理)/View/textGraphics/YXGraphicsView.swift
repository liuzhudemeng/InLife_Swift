//
//  YXGraphicsView.swift
//  InLife
//
//  Created by apple on 2017/11/15.
//  Copyright © 2017年 lyx. All rights reserved.
//

import UIKit
let space:CGFloat = 10
let imageH = (kMainScreenWidth)/4
class YXGraphicsView: UIView {
    var imageArray = [UIImage]()
    let imageW = imageH - 20
    let color = UIColor.black
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.colorWithHexString("#f7f8fa")
        setData()
        buildUI()
    }
    
    
    func buildUI(){
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        let line0 = YXTools.allocline(frame: CGRect(x:0, y:0, width:kMainScreenWidth,height: 0.5), bgColor: bordColor)
        scrollView.addSubview(line0)
        for i in 0..<imageArray.count {
            let row:Int = i/4
            let cloum:Int = i%4
            let imageView = UIImageView(image: imageArray[i])
            imageView.contentMode = .center
            imageView.backgroundColor = UIColor.clear
            scrollView.addSubview(imageView)
            imageView.snp.makeConstraints({ (make) in
                make.left.equalTo(imageH*CGFloat(cloum))
                make.top.equalTo(imageH*CGFloat(row))
                make.width.height.equalTo(imageH)
            })
            let line1 = YXTools.allocline(frame:CGRect(x:imageH*CGFloat(cloum+1), y: imageH*CGFloat(row),  width:0.5,height:imageH), bgColor:  bordColor)
            scrollView.addSubview(line1)
            
            let row1:Int = cloum == 0 ?row+1:row
            if cloum == 0 {
                let line = YXTools.allocline(frame: CGRect(x:0, y:imageH*CGFloat(row1), width:kMainScreenWidth,height: 0.5), bgColor: bordColor)
                scrollView.addSubview(line)
            }
          
            if i == imageArray.count-1{
               scrollView.snp.makeConstraints({ (make) in
                    make.top.left.right.equalTo(self)
                    make.bottom.equalTo(imageView.snp.bottom).offset(20)
                })
            }
        }
        
    }
    
    func setData(){
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageH, height: imageH), false, 0);
        let ctx = UIGraphicsGetCurrentContext()
        let image1 = ShapeUtils.drawRect(ctx!, color: color, rect:CGRect(x: 10, y: 10, width: imageW, height: imageW) , isSolid: true)
        imageArray.append(image1)
        let image2 = ShapeUtils.drawRect(ctx!, color: color, rect:CGRect(x: 10, y: 10, width: imageW, height: imageW) , isSolid: false)
        imageArray.append(image2)
        let image3 = ShapeUtils.drawCircle(ctx!, fillcolor: color, radius: imageW/2, point: CGPoint(x:imageW/2+10,y:imageW/2+10), isSolid: true, isSemi: false)
        imageArray.append(image3)
        let image4 = ShapeUtils.drawCircle(ctx!, fillcolor: color, radius: imageW/2, point: CGPoint(x:imageW/2+10,y:imageW/2+10), isSolid: false, isSemi: false)
        imageArray.append(image4)
        let image5 = ShapeUtils.drawRoundedRect(ctx!, lineColor: color, fill: color, lineWidth: 2.0, cornerRadius: 5.0, rect: CGRect(x: 10, y: 10, width: imageW, height: imageW))
        imageArray.append(image5)
        let image6 = ShapeUtils.drawRoundedRect(ctx!, lineColor: color, fill: UIColor.clear, lineWidth: 2.0, cornerRadius: 5.0, rect: CGRect(x: 10, y: 10, width: imageW, height: imageW))
        imageArray.append(image6)
        let image7 = ShapeUtils.drawEllipse(ctx!, fillcolor: color, rect:  CGRect(x: 10, y: 15, width: imageW, height: imageW-10), isSolid: true)
        imageArray.append(image7)
        let image8 = ShapeUtils.drawEllipse(ctx!, fillcolor: color, rect:  CGRect(x: 10, y: 15, width: imageW, height: imageW-10), isSolid: false)
        imageArray.append(image8)
        let image9 = ShapeUtils.drawTriangle(ctx!, lineColor: color, fill: color, center: CGPoint(x:imageW/2+10,y:imageW/2+20), length: imageW, lineWidth: 2.0, direction: .up)
        imageArray.append(image9)
        let image10 = ShapeUtils.drawTriangle(ctx!, lineColor: color, fill: UIColor.clear, center: CGPoint(x:imageW/2+10,y:imageW/2+20), length: imageW, lineWidth: 2.0, direction: .up)
        imageArray.append(image10)
        let image11 = ShapeUtils.drawDiamond(ctx!, fillcolor:  color, rect: CGRect(x: 10, y: 45, width: imageW, height: imageW+10), isSolid: true)
        imageArray.append(image11)
        let image12 = ShapeUtils.drawDiamond(ctx!, fillcolor:  color, rect: CGRect(x: 10, y: 45, width: imageW, height: imageW+10), isSolid: false)
        imageArray.append(image12)
        let image13 = ShapeUtils.drawCircle(ctx!, fillcolor: color, radius: imageW/2, point: CGPoint(x:imageW/2+10,y:imageW/2+10), isSolid: true, isSemi: true)
        imageArray.append(image13)
    }
    
    lazy var scrollView:UIScrollView = {
       let object = UIScrollView()
        object.backgroundColor = UIColor.clear
        object.showsVerticalScrollIndicator = false
        object.showsHorizontalScrollIndicator = false
        return object
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    

    
}
