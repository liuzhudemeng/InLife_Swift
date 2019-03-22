//
//  YXButton.swift
//  LoveOfLearning
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 lyx. All rights reserved.
//

import UIKit

enum YXTabBarItemType : Int {
    case YXTabBarItemNormal = 0
    case YXTabBarItemRise
}
class YXButton: UIButton {
    var tabBarItemType:YXTabBarItemType = .YXTabBarItemNormal

    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(){
        self.adjustsImageWhenHighlighted = false
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel?.sizeToFit()
    
        let titleSize = self.titleLabel?.frame.size ?? CGSize(width: 0, height: 0)
        let imageSize = self.image(for: .normal)?.size ?? CGSize(width: 0, height: 0)
        
        if imageSize.width != 0 && imageSize.height != 0 {
            let imageViewCenterY = self.frame.height - 3 - titleSize.height - imageSize.height / 2 - 5
            self.imageView?.center = CGPoint(x: self.frame.width/2, y: imageViewCenterY)
        }else{
            var imageViewCenter = self.imageView?.center
            imageViewCenter?.x = frame.width / 2
            imageViewCenter?.y = (frame.height - titleSize.height)/2
            self.imageView!.center = imageViewCenter!
        }
        
        let labelCenter = CGPoint(x: frame.width/2, y: frame.height - 3 - titleSize.height/2)
        self.titleLabel?.center = labelCenter
        
    }
    
}
