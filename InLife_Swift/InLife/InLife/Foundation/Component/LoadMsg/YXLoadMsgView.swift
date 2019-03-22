//
//  YXLoadMsgView.swift
//  imitateNewsDemo
//
//  Created by apple on 16/11/24.
//  Copyright © 2016年 lyx. All rights reserved.
//

import UIKit

class YXLoadMsgView: UIView {

    var showType = YXShowSubViewType.Default
    
    var btnClickedBlock: (()->())?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //有空数据的页面显示文案都在这里配置，显示的空间类型根据showTpye 来配置
    func createEmptyViewWithType(type:YXEmptyViewType){
        var imageName = String()
        var title = String()
        var subTitle:String?
        var btnTitle = String()
        
        switch type {
        case .NoGoods:
            imageName = "good_NoData"
            title = "您还没有使用中的仓库，使用后\n即可查看仓库监控视频"
            btnTitle = "新增收货地址"
            showType = .ButtonNone
            break
        case .NoMointor:
             title = "暂无监控视频"
             showType = .Title
            break
            
        case .NoApply:
            imageName = "noApply"
            title = "您还没有任何申请记录!"
            showType = .ButtonNone
            break
        case .NoApplyBill:
            imageName = "monitor_noBill"
            title = "您还未创建监控查看申请，\n点击申请按钮创建申请"
            showType = .ButtonNone
            break
        case .LocationFail:
            //待添加
            subTitle = ""
            break
            
        case .Order:
            imageName = "empty_image_order"
            title = "您还没有订单～"
            btnTitle = "去逛逛吧"
            showType = .Image
            break
        case .NetworkError:
            imageName = "error_icon_network"
            btnTitle = "点我重试"
            title = "咦 咋没有网了呢"
            break
        }
        self.addSubview(emptyView)
        emptyView.updateEmptyView(imageName: imageName, title: title, subTitle: subTitle, btnTitle: btnTitle, type: showType)
        emptyView.center = self.center
       if showType != .ButtonNone {
            emptyView.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        }
    }
    
    
    

    func buttonClicked() -> Void {
        if self.btnClickedBlock != nil {
            self.btnClickedBlock!()
        }
    }
    
    fileprivate lazy var emptyView:YXErrorView = {
        let object = YXErrorView(frame:self.bounds)
        return object
    }()
}


class YXLoadingMsg: UIView {
    var activityView:UIActivityIndicatorView!
    var title:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initView(){
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        self.addSubview(activityView)
        
        title = UILabel(frame:CGRect.zero)
        title.textAlignment = .center
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 14)
        title.backgroundColor = UIColor.clear
        self.addSubview(title)
    }
    
    func showActivityLoading(view:UIView,title:String?){
        self.frame = view.bounds
        activityView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.title.frame =  CGRect(x: 10, y: activityView.frame.size.height+activityView.frame.origin.y+5, width: self.frame.size.width - 20, height: 20)
        activityView.startAnimating()
        view.addSubview(self)
        view.bringSubview(toFront: self)
        guard let text = title else{
            return
        }
        self.title.text = text
    }
    
    
    func hideActivityLoading(){
        activityView.stopAnimating()
        self.removeFromSuperview()
    }
    
}


class YXErrorView: UIView {
    let spaceX:CGFloat = UIScale(30)
    let labelHei:CGFloat = UIScale(30)
    let btnWith:CGFloat = UIScale(100)
    let btnHei:CGFloat = UIScale(30)
    let imageWith:CGFloat = UIScale(181.5)
    let imageHei:CGFloat = UIScale(171.5)
    let spaceY = UIScale(15)
     //这这里设置图片显示的大小
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func updateEmptyView(imageName:String, title:String,subTitle:String?, btnTitle:String?,type:YXShowSubViewType){
        let titleHei = title.height(font: 15, width: self.frame.size.width - spaceX*2)
        switch type {
        case .Default:
                self.addSubview(imageView)
                imageView.image = UIImage(named: imageName)
                imageView.frame = CGRect(x:(self.frame.size.width - imageWith)/2, y: 0, width: imageWith, height: imageHei)
                
                addSubview(titleLabel)
                titleLabel.text = title
                titleLabel.frame = CGRect(x: spaceX, y: imageView.frame.size.height+imageView.frame.origin.y+spaceX/2, width: self.frame.size.width - spaceX*2, height: titleHei)
                
                addSubview(button)
                button.setTitle(btnTitle, for: .normal)
                
                if subTitle != nil {
                    addSubLabel(title: subTitle!)
                    button.frame = CGRect(x: (self.frame.size.width - btnWith)/2, y: subTitleLabel.frame.size.height+subTitleLabel.frame.origin.y+spaceX/2, width: btnWith, height: btnHei)
                }else{
                    button.frame = CGRect(x: (self.frame.size.width - btnWith)/2, y: titleLabel.frame.size.height+titleLabel.frame.origin.y+spaceX/2, width: btnWith, height: btnHei)
                }
                self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: button.frame.size.height+button.frame.origin.y+spaceY)
            break
        case .ButtonNone:
            self.addSubview(imageView)
            imageView.image = UIImage(named: imageName)
            imageView.frame = CGRect(x:(self.frame.size.width - imageWith)/2, y: 0, width: imageWith, height: imageHei)
            
            addSubview(titleLabel)
            titleLabel.text = title
            titleLabel.frame = CGRect(x: spaceX, y: imageView.frame.size.height+imageView.frame.origin.y+spaceX/2, width: self.frame.size.width - spaceX*2, height: titleHei)
            if subTitle != nil {
                addSubLabel(title: subTitle!)
                self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: subTitleLabel.frame.size.height+subTitleLabel.frame.origin.y+spaceY)
            }else{
                self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: titleLabel.frame.size.height+titleLabel.frame.origin.y+spaceY)
            }
            break
        case .ImageNone:
            addSubview(titleLabel)
            titleLabel.text = title
            titleLabel.frame = CGRect(x: spaceX, y: 0, width: self.frame.size.width - spaceX*2, height: titleHei)
            
            addSubview(button)
            button.setTitle(btnTitle, for: .normal)
            if subTitle != nil {
                addSubLabel(title: subTitle!)
                button.frame = CGRect(x: (self.frame.size.width - btnWith)/2, y: subTitleLabel.frame.size.height+subTitleLabel.frame.origin.y+spaceX/2, width: btnWith, height: btnHei)
            }else{
                button.frame = CGRect(x: (self.frame.size.width - btnWith)/2, y: titleLabel.frame.size.height+titleLabel.frame.origin.y+spaceX/2, width: btnWith, height: btnHei)
            }
            self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: button.frame.size.height+button.frame.origin.y+spaceY)
            break
        case .Image:
            self.addSubview(imageView)
            imageView.image = UIImage(named: imageName)
            imageView.frame = CGRect(x:(self.frame.size.width - imageWith)/2, y: 0, width: imageWith, height: imageHei)
            self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: imageView.frame.size.height+imageView.frame.origin.y+spaceY)
            break
        case .Title:
            addSubview(titleLabel)
            titleLabel.text = title
            titleLabel.frame = CGRect(x: spaceX, y: 0, width: self.frame.size.width - spaceX*2, height: titleHei)
            self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: titleLabel.frame.size.height+titleLabel.frame.origin.y+spaceY)
            break
        case .TitleNone:
            self.addSubview(imageView)
            imageView.image = UIImage(named: imageName)
            imageView.frame = CGRect(x:(self.frame.size.width - imageWith)/2, y: 0, width: imageWith, height: imageHei)
            addSubview(button)
            button.setTitle(btnTitle, for: .normal)
            button.frame = CGRect(x: (self.frame.size.width - btnWith)/2, y: imageView.frame.size.height+imageView.frame.origin.y+spaceX/2, width: btnWith, height: btnHei)
             self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: button.frame.size.height+button.frame.origin.y+spaceY)
            break
        }
    }
    
    //添加副标题
    func addSubLabel(title:String){
        let subTiHei = title.height(font: 15, width: titleLabel.frame.size.width)
        self.addSubview(subTitleLabel)
        subTitleLabel.text = title
        subTitleLabel.frame = CGRect(x:titleLabel.frame.origin.x, y: titleLabel.frame.size.height+titleLabel.frame.origin.y+spaceX/2, width: titleLabel.frame.size.width, height: subTiHei)
    }

    fileprivate lazy var imageView:UIImageView = {
         let object = UIImageView()
        object.contentMode = .center
        return object
    }()
    
    fileprivate lazy var titleLabel:UILabel = {
        let object = UILabel()
        object.font = UIFont.systemFont(ofSize: 14)
        object.textColor = Title_Black
        object.numberOfLines = 0
        object.lineBreakMode = .byWordWrapping
        object.textAlignment = .center
        return object
    }()
    
    fileprivate lazy var subTitleLabel:UILabel = {
        let object = UILabel()
        object.font = UIFont.systemFont(ofSize: 14)
        object.textColor = UIColor.lightGray
        object.numberOfLines = 0
        object.textAlignment = .center
        return object
    }()
    
    fileprivate lazy var button:UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(Title_Black, for: .normal)
        button.layer.cornerRadius = 2.5
        button.layer.borderColor = UIColor.colorWithHexString("#ec7180").cgColor
        button.layer.borderWidth = 0.5
        return button
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


