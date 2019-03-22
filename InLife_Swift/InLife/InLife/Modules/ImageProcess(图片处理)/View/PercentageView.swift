//
//  PercentageView.swift
//  InLife
//
//  Created by apple on 17/8/22.
//  Copyright © 2017年 lyx. All rights reserved.
//

import UIKit

class PercentageView: UIView {
    let space:CGFloat = 40
    var didSelectBlock: ((_ value:CGFloat) -> Void)?
    var titleType:String?{
        didSet{
            tabBar.titleLab.text = titleType
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    func buildUI(){
        self.backgroundColor = UIColor.colorWithHexString("#fcfcfc")
        self.addSubview(valueLab)
        self.addSubview(slider)
        self.addSubview(tabBar)
        valueLab.text = String(Int(slider.value))
        
        valueLab.snp.makeConstraints { (make) in
            make.top.equalTo(space)
            make.height.equalTo(30)
            make.left.right.equalTo(self)
        }
        slider.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(space)
            make.right.equalTo(self).offset(-space)
            make.height.equalTo(20)
            make.top.equalTo(valueLab.snp.bottom).offset(10)
        }
        
        tabBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(60)
        }
    }
    
    
    func configuationSlider(max:CGFloat,min:CGFloat,current:CGFloat){
        slider.minimumValue = Float(min)
        slider.maximumValue = Float(max)
        slider.value = Float(current) //置初始值
        valueLab.text = String(format:"%.1f",current)
        
    }
    
    func showInContainer(contentView:UIView){
        contentView.addSubview(self)
        UIView.animate(withDuration: 0.30, delay: 0, options: .curveEaseOut, animations: {
             self.yx_top(top: kMainScreenHeight-240)
        }) { (bool) in
           
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
    
    //slider的点击事件
    func sliderValueChanged(sender:UISlider){
        valueLab.text = String(format:"%.1f",sender.value)
        if let closure = self.didSelectBlock {
            closure(CGFloat(sender.value))
        }
    }
    
    //确定与取消按钮的点击事件
    func cancalAndSure(sender:UIButton) {
        UIView.animate(withDuration: 0.30, delay: 0, options: .curveEaseOut, animations: {
            self.yx_top(top: kMainScreenHeight)
        }) { (bool) in
            self.removeFromSuperview()
        }
        if sender.tag == 1 {
            return
        }
       
    }
    
    lazy var valueLab:UILabel = {
        let object = UILabel()
        object.font = systemFont(14)
        object.textColor = Title_gray
        object.textAlignment = .center
        return object
    }()
    
    lazy var slider:UISlider = {
        let object = UISlider()
        object.minimumValue = 0
        object.maximumValue = 100
        object.value = (object.minimumValue + object.maximumValue) / 2 //置初始值 
        object.isContinuous = true   //可连续变化
        object.minimumTrackTintColor = UIColor.yellow
        object.maximumTrackTintColor = Title_gray
        object.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        return object
    }()
    
    
    lazy var tabBar:BottomTarView = {
        let object = BottomTarView()
        object.cancalBtn.tag = 1
        object.sureBtn.tag = 2
        object.cancalBtn.addTarget(self, action: #selector(self.cancalAndSure(sender:)), for: .touchUpInside)
        object.sureBtn.addTarget(self, action: #selector(self.cancalAndSure(sender:)), for: .touchUpInside)
        return object
    }()

}


class BottomTarView: UIView {
    let btnWith:CGFloat = 32
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    func  buildUI(){
        self.backgroundColor = UIColor.colorWithHexString("#fcfcfc")
        self.layer.borderColor = bordColor.cgColor
        self.layer.borderWidth = 0.5
        self.addSubview(cancalBtn)
        self.addSubview(sureBtn)
        self.addSubview(titleLab)

        cancalBtn.snp.makeConstraints { (make) in
            make.bottom.top.equalTo(self)
            make.width.equalTo(btnWith)
            make.left.equalTo(self).offset(Begin_X)
        }
        sureBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.width.equalTo(btnWith)
            make.right.equalTo(self).offset(-Begin_X)
        }
        
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(cancalBtn.snp.right)
            make.right.equalTo(sureBtn.snp.left)
            make.top.bottom.equalTo(cancalBtn)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var cancalBtn:UIButton = {
        let object = UIButton()
        object.setImage(UIImage(named:"cancal"), for: .normal)
        return object
    }()
    
    lazy var sureBtn:UIButton = {
        let object = UIButton()
        object.setImage(UIImage(named:"sure"), for: .normal)
        return object
    }()
    
    lazy var titleLab:UILabel = {
        let object = UILabel()
        object.font = systemFont(14)
        object.textColor = UIColor.gray
        object.textAlignment = .center
        return object
    }()

    
}

