//
//  TabBarView.swift
//  InLife
//
//  Created by apple on 17/8/1.
//  Copyright © 2017年 lyx. All rights reserved.
//

import UIKit

class TabBarView: UIView {
    weak var delegate:TabBarViewDelegate?
    var titleArray:[String]?
    let btnWith:CGFloat = 32
    var btnArray = [UIButton]()
    
    
     init(frame: CGRect,titleArr:[String]) {
        super.init(frame: frame)
        titleArray = titleArr
        buildUI()
    }
    
    
    func  buildUI(){
        self.backgroundColor = UIColor.colorWithHexString("#fcfcfc")
        self.layer.borderColor = bordColor.cgColor
        self.layer.borderWidth = 0.5
        self.addSubview(backBtn)
        self.addSubview(nextBtn)
        backBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.width.equalTo(btnWith)
            make.left.equalTo(self).offset(Begin_X)
        }
        nextBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.width.equalTo(btnWith)
            make.right.equalTo(self).offset(-Begin_X)
        }
        
        let buttonW = (kMainScreenWidth - btnWith*2-Begin_X*2)/CGFloat(titleArray!.count)
        for i in 0..<titleArray!.count {
            let btn = UIButton()
            btn.setTitle(titleArray?[i], for: .normal)
            btn.titleLabel?.font = systemFont(14)
            btn.tag = i
            btn.addTarget(self, action: #selector(self.clickTitleBtn(sender:)), for: .touchUpInside)
            self.addSubview(btn)
            btnArray.append(btn)
            if i == 0 {
                btn.setTitleColor(UIColor.black, for: .normal)
            }else{
                btn.setTitleColor(UIColor.gray, for: .normal)
            }
            btn.snp.makeConstraints({ (make) in
                make.left.equalTo(backBtn.snp.right).offset(buttonW*CGFloat(i))
                make.width.equalTo(buttonW)
                make.bottom.top.equalTo(self)
            })
        }

    }
    
    
    //下一步和上一步按钮点击方法
    func  toClickBtn(sender:UIButton){
        if delegate != nil {
            self.delegate?.backOrNext(index: sender.tag)
        }
    }
    
    //标题按钮点击
    func clickTitleBtn(sender:UIButton){
        for btn in btnArray {
            btn.setTitleColor(UIColor.gray, for: .normal)
            if btn == sender {
                btn.setTitleColor(UIColor.black, for: .normal)
            }
        }
        self.delegate?.switchFunctionModule(index: sender.tag)
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
    
    lazy var backBtn:UIButton = {
        let object = UIButton()
        object.setImage(UIImage(named:"tabBar_back"), for: .normal)
        object.tag = 1
        object.addTarget(self, action: #selector(self.toClickBtn(sender:)), for: .touchUpInside)
        return object
    }()
    
    lazy var nextBtn:UIButton = {
        let object = UIButton()
        object.setImage(UIImage(named:"tabBar_next"), for: .normal)
        object.tag = 2
        object.addTarget(self, action: #selector(self.toClickBtn(sender:)), for: .touchUpInside)
        return object
    }()


  
}

@objc protocol TabBarViewDelegate:NSObjectProtocol{
    func backOrNext(index:NSInteger)
    func switchFunctionModule(index:NSInteger)  //功能区切换
}
