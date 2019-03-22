//
//  YXObjectViewController.swift
//  LoveOfLearning
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 lyx. All rights reserved.
//

import UIKit

class YXObjectViewController: BaseViewController ,UITextViewDelegate,UITextFieldDelegate{

    var  rect : CGRect?
    var animationDuration :Double?
    var textView :UIView?
    
  
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard(_:)))
        tap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    func hideKeyBoard (_ tap:UITapGestureRecognizer) {
        YXTools.autohideKeyBoard(view: scrollView)
    }
    
    func keyboardWillShow(_ notification:Notification) {
        let userInfo : NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let aValue:NSValue = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey)as! NSValue
        rect = aValue.cgRectValue
        
        //获取键盘上拉动画持续时间
        let keyboardDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        animationDuration = keyboardDuration
       
        let contentInsets:UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, rect!.size.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
    }
    
    func keyboardWillHide(_ notification:Notification) {
        
        textView = nil
        let userInfo:NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        //获取键盘上拉动画持续时间
        let keyboardDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
         animationDuration = keyboardDuration
        YXTools.uiViewAnimationTransition(toView: nil, typeIndex: 0, duration: animationDuration!) {
            self.scrollView.contentInset = UIEdgeInsets.zero
            self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        }

        
    }
    
    
     func scrollContentOffsetAnimation(_ point:CGPoint)
    {
        YXTools.uiViewAnimationTransition(toView: nil, typeIndex: 0, duration:animationDuration!) {
           self.scrollView.contentOffset = point
        }
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
       self.textView = textView
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.textView = nil
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.textView = textField
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.textView = nil
        return  true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    lazy var scrollView:UIScrollView = {
        let object = UIScrollView()
        object.showsVerticalScrollIndicator = false
        object.showsHorizontalScrollIndicator = false
        return object
    }()

}
