//
//  InPutTextView.swift
//  InLife
//
//  Created by apple on 2017/11/28.
//  Copyright © 2017年 lyx. All rights reserved.
//

import UIKit

class InPutTextView: UIView {
    var didAddOrChangeAddressClosure: ((String) -> Void)?
    let ViewHight:CGFloat = 120
    let space:CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurationUI()
    }
    
    func configurationUI(){
        var c = ColorBlack
        c = c.withAlphaComponent(0.5)
        self.backgroundColor = c
        
        self.addSubview(contentView)
        contentView.addSubview(textView)
        contentView.addSubview(sureButton)
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(ViewHight)
        }
        
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(Begin_X)
            make.top.equalTo(space)
            make.bottom.equalTo(contentView).offset(-space)
        }
        
        sureButton.snp.makeConstraints { (make) in
            make.left.equalTo(textView.snp.right).offset(Begin_X)
            make.right.equalTo(contentView).offset(-Begin_X)
            make.width.equalTo(60)
            make.top.equalTo(ViewHight*0.3)
            make.bottom.equalTo(contentView).offset(-ViewHight*0.3)
        }
        
        let tapGestureRecongnizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognized(_:)))
        tapGestureRecongnizer.delegate = self
        self.addGestureRecognizer(tapGestureRecongnizer)
    }
    
    func tapRecognized(_ gr:UITapGestureRecognizer) -> Void {
        let p = gr.location(in: self.contentView)
        if p.x < 0 || p.y < 0 ||  p.x > self.contentView.frame.size.width || p.y > self.contentView.frame.size.height  {
           dismissSelf()
        }
        
    }
    
    func dismissSelf(){
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor.colorWithRGB(0x0, alpha: 0.0)
            self.contentView.frame.origin.y = kMainScreenHeight
        },completion: {
            Bool in
            self.removeFromSuperview()
        })
    }
    func sureClickButton(){
        if let closure = self.didAddOrChangeAddressClosure {
            closure(self.textView.text)
        }
        dismissSelf()
    }
    
    func  doneBarButton(){
        textView.resignFirstResponder()
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
    
    lazy var contentView:UIView = {
       let object = UIView()
        object.backgroundColor = UIColor.white
        return object
    }()

    lazy var textView:PlaceholderTextView = {
        let object = PlaceholderTextView(placeholder: "添加文字内容，双击修改")
        object.delegate = self
        object.textColor = UIColor.black
        object.layer.borderColor = bordColor.cgColor
        object.layer.borderWidth = 1.0
        
        //工具条
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: kMainScreenWidth, height: 40))
        toolBar.barStyle = .default
        
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("完成", for: UIControlState())
        button.setTitleColor(UIColor.blue, for: UIControlState())
        button.frame.size = CGSize(width: 60, height: 40)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(InPutTextView.doneBarButton), for: UIControlEvents.touchUpInside)
        
        let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneB = UIBarButtonItem(customView: button)
        toolBar.items = [barButton, doneB]
        object.inputAccessoryView = toolBar
        return object
    }()
    
    lazy var sureButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("确定", for: .normal)
        btn.titleLabel?.textColor = UIColor.white
        btn.titleLabel?.font = systemBoldFont(14)
        btn.clipsToBounds = true   //有了设个属性，设置圆角才管用
        btn.layer.cornerRadius = 5.0
        let image = UIImage()
        let colorImage = image.color(withImage: UIColor.colorWithHexString("#31a5fc"))
        btn.setBackgroundImage(colorImage, for: .normal)
        btn.addTarget(self, action: #selector(sureClickButton), for: .touchUpInside)
        return btn
    }()
}

extension InPutTextView:UITextViewDelegate{
    
}


extension InPutTextView:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let pt = touch.location(in: self)
        if (self.contentView.frame).contains(pt) {
            return false
        }
        return true
    }}
