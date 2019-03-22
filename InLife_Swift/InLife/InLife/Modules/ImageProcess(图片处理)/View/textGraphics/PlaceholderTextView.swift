//
//  PlaceholderTextView.swift
//  Chemistry
//
//  Created by coco on 16/8/30.
//  Copyright © 2016年 lhw. All rights reserved.
//

import UIKit

class PlaceholderTextView: UITextView {
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    convenience init (placeholder: String?) {
        self.init(frame: CGRect.zero, textContainer: nil)
        self.addSubview(plactholderL)
        self.font = UIFont.systemFont(ofSize: 15)
        self.placeholder = placeholder
        plactholderL.text = self.placeholder
        plactholderL.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(self.snp.left).offset(15)
            make.right.equalTo(self.snp.right).offset(-15)
        }
        
        self.textContainerInset = UIEdgeInsetsMake(10, 12, 0, 15)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        NotificationCenter.default.addObserver(self, selector: #selector(PlaceholderTextView.textViewDidChanged(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: self)
            }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func textViewDidChanged(_ sender: Notification) {
        if self.text.characters.count == 0{
            self.plactholderL.isHidden = false
        } else {
            self.plactholderL.isHidden = true
        }
    }
    
    override var text: String! {
        didSet {
            if text.characters.count == 0 {
                self.plactholderL.isHidden = false
            } else {
                self.plactholderL.isHidden = true
            }
        }
    }
    
    /**占位符*/
    fileprivate var placeholder: String?
    
    /**占位文字*/
    fileprivate lazy var plactholderL: UILabel = {
        let object = UILabel()
        object.numberOfLines = 0
        object.font = UIFont.systemFont(ofSize: 15)
        object.textColor = UIColor.gray
        return object
    }()
}
