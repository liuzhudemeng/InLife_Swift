//
//  ToolBarView.swift
//  InLife
//
//  Created by apple on 2018/1/8.
//  Copyright © 2018年 lyx. All rights reserved.
//

import UIKit

class ToolBarView: UIView {
    var  isFont:Bool = true {
        didSet{
            if isFont {
                imageArray = ["font_select","color_select","copy_layer","position_adjust","span_adjust"]
            }
        }
    }    //是否是字体还是图形
    weak var delegate:ToolBarViewDelegate?
    var colorPickView:HRColorPickerView?
    var imageArray = [String]()
    let btnWith:CGFloat = 40
    let btnHeight:CGFloat = 30
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
    }
    
    
    func buildUI(){
        self.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(btnHeight+Begin_X)
        }
        for i in 0..<imageArray.count {
            let btn = UIButton()
            btn.setImage(UIImage(named:imageArray[i]), for: .normal)
            btn.imageView?.contentMode = .center
            btn.backgroundColor = UIColor.clear
            btn.layer.borderWidth = 0.5
            btn.layer.borderColor = bordColor.cgColor
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 5.0
            btn.tag = i
            btn.addTarget(self, action: #selector(btnClickFunction(sender:)), for: .touchUpInside)
            topView.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.left.equalTo(Begin_X + (btnWith+Begin_X/2)*CGFloat(i))
                make.top.equalTo(Begin_X/2)
                make.height.equalTo(btnHeight)
                make.width.equalTo(btnWith)
            })
        }
        
        let sureBtn = UIButton()
        sureBtn.setImage(UIImage(named:"sure_just"), for: .normal)
        sureBtn.backgroundColor = UIColor.clear
        sureBtn.addTarget(self, action: #selector(suretoClose(sender:)), for: .touchUpInside)
        topView.addSubview(sureBtn)
        sureBtn.snp.makeConstraints { (make) in
            make.width.equalTo(btnWith)
            make.top.bottom.equalTo(topView)
            make.right.equalTo(topView).offset(-Begin_X)
        }
        
    }
    
    //功能按钮点击
    func btnClickFunction(sender:UIButton){
        switch sender.tag {
        case 0:
            break
        case 1:
            initColorView()
            break
        default:
            break
        }
    }
    
    func initColorView(){
        if colorPickView == nil {
            let colorpickView = HRColorPickerView()
            colorpickView.color = UIColor.yellow
            let colorMapView = HRColorMapView()
            colorMapView.saturationUpperLimit = 1
            colorMapView.tileSize = 1
            colorpickView.addSubview(colorMapView)
            colorpickView.colorMapView = colorMapView
            colorpickView.mblock = {[weak self] (color) in
                self?.delegate?.selectedColor(color: color!)
            }
            self.colorPickView = colorpickView
            self.addSubview(colorPickView!)
        }
        colorPickView?.frame = CGRect(x: 0, y: btnHeight+Begin_X, width: self.frame.size.width, height: self.frame.size.height - btnHeight - Begin_X )
       
    }
    
    
    func initFontView(){
//        let fontView = YXTextView(frame: CGRect.zero)
        
    }
    
    //点击确认按钮
    func suretoClose(sender:UIButton){
        
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
    
    lazy var topView:UIView = {
       let object = UIView()
        object.backgroundColor = BgViewColor
        return object
    }()

}

@objc protocol ToolBarViewDelegate:NSObjectProtocol{
    func selectedColor(color:UIColor)
}
