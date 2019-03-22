//
//  CuttingView.swift
//  InLife
//
//  Created by apple on 17/8/2.
//  Copyright © 2017年 lyx. All rights reserved.
//

import UIKit

class CuttingView: UIView {
    var btnNormalaArray = [String]()
    var titleArray = [String]()
    var proportRotion:CGFloat = 0
    weak var delegate:CuttingViewDelegate?
    var proportionArr = [String]()
    var valuesArr = [CGFloat]()
    var i = 0    //记录当前的画布比
    
    
     init(frame: CGRect,normalArr:[String],titleArr:[String]) {
        super.init(frame: frame)
        btnNormalaArray = normalArr
        titleArray = titleArr
        buildUI()
    }
    
    func buildUI() -> Void {
         self.addSubview(scrollView)
        let count = titleArray.count > 5 ? 5:titleArray.count
         let btnWith:CGFloat = (kMainScreenWidth-Begin_X*(CGFloat(count)+1))/CGFloat(count)
        var tempB: UIButton?
        for index in 0..<titleArray.count {
            let button = YXButton()
            button.setTitleColor(UIColor.black, for: .normal)
            button.tag = index
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(toSelectedFunc(sender:)), for: .touchUpInside)
            let image =  UIImage(named:btnNormalaArray[index])
            button.setImage(image, for: .normal)
            button.setTitle(titleArray[index], for: .normal)
            scrollView.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.left.equalTo((btnWith+Begin_X)*CGFloat(index)+Begin_X)
                make.width.equalTo(btnWith)
                make.top.equalTo(20)
                make.centerY.equalTo(scrollView)
                make.bottom.equalTo(scrollView)
            }
            if index == titleArray.count - 1 {
                tempB = button
                scrollView.snp.makeConstraints({ (make) in
                    make.top.bottom.left.right.equalTo(self)
                    if let temp = tempB {
                        make.right.equalTo(temp.snp.right)
                    }
                })
            }
            

        }

    }
    
    
    
    func toSelectedFunc(sender:YXButton){
        if sender.tag == 0 && valuesArr.count > 0 {
            if i == valuesArr.count - 1{
                i = 0
            }else{
                i+=1
            }
           sender.setImage(UIImage(named:proportionArr[i]), for: .normal)
           proportRotion = valuesArr[i]
        }
        if delegate != nil {
            delegate?.ClickToolBtn(index: sender.tag,proportation:proportRotion,tagView:self)
        }
    }
        
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
    
    fileprivate lazy var scrollView:UIScrollView = {
        let object = UIScrollView()
        object.showsVerticalScrollIndicator = false
        object.showsHorizontalScrollIndicator = false
        object.isScrollEnabled = true
        object.backgroundColor = UIColor.white
        return object
    }()

}

@objc protocol CuttingViewDelegate:NSObjectProtocol{
    
    func ClickToolBtn(index:NSInteger,proportation:CGFloat,tagView:CuttingView)
}
