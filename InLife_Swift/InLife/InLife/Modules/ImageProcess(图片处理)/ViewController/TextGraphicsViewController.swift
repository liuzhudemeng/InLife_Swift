//
//  TextGraphicsViewController.swift
//  InLife
//
//  Created by apple on 2017/11/15.
//  Copyright © 2017年 lyx. All rights reserved.
//

import UIKit

class TextGraphicsViewController: BaseViewController {
   var originImage:UIImage?
    var currentEditLabel:YXTextOperaView?
    var labels = [YXTextOperaView]()
    var toolBar:ToolBarView?
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        super.viewWillDisappear(animated)
        
    }
    func buildUI(){
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(imageV)
        self.view.addSubview(fontView)
        self.view.addSubview(shapeView)
        self.view.addSubview(tabbarView)
        shapeView.isHidden = true
        imageV.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(40)
        }
        fontView.snp.makeConstraints { (make) in
            make.top.equalTo(imageV.snp.bottom)
            make.height.equalTo(200)
            make.left.right.equalTo(self.view)
        }
        shapeView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(imageV.snp.bottom)
            make.height.equalTo(200)
        }
        tabbarView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self.view)
            make.top.equalTo(fontView.snp.bottom)
            make.height.equalTo(60)
        }
        
    }
    
    
    func addLabl(fontName:String,text:String){
        currentEditLabel?.hideHandles()
        let labelView = YXTextOperaView(frame: CGRect(x: 100, y: 150, width: 160, height: 70))
        labelView.delegate = self
        labelView.fontName = fontName
        labelView.fontSize = 20
        labelView.string = text
        self.view.addSubview(labelView)
        currentEditLabel = labelView
        labels.append(labelView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var imageV:UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFit
        object.image = self.originImage
        object.isUserInteractionEnabled = true
        return object
    }()
    
    fileprivate lazy var tabbarView:TabBarView = {
        let object = TabBarView(frame: CGRect.zero,titleArr:["文字","图形","图层"])
        object.delegate = self
        return object
    }()
    
    fileprivate lazy var fontView:YXTextView = {
        let object = YXTextView(frame: CGRect.zero)
        object.delegate = self
        return object
    }()
    
    fileprivate lazy var shapeView:YXGraphicsView = {
        let object = YXGraphicsView(frame: CGRect.zero)
        return object
    }()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TextGraphicsViewController:TabBarViewDelegate{
    func switchFunctionModule(index: NSInteger) {
        switch index {
        case 0:
            UIView.animate(withDuration: 0.25, animations: {
                self.fontView.isHidden = false
                self.shapeView.alpha = 0
            }, completion: { (isFinish) in
                 self.shapeView.alpha = 1
                self.shapeView.isHidden = true
            })
            break
        case 1:
            UIView.animate(withDuration: 0.25, animations: {
                self.shapeView.isHidden = false
                self.fontView.alpha = 0
            }, completion: { (isFinish) in
                self.fontView.alpha = 1
                self.fontView.isHidden = true
            })
            break
        default:
            break
        }
    }
    
    func backOrNext(index: NSInteger) {
        if index == 1 {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentEditLabel?.hideHandles()
    }
    
    
    func initToolsBar(){
        if toolBar == nil {
            let view = ToolBarView(frame: CGRect(x: 0, y: imageV.frame.origin.y+imageV.frame.size.height, width: kMainScreenWidth, height: 200))
            view.isFont = true
            view.buildUI()
            view.delegate = self
            toolBar = view
            self.view.addSubview(toolBar!)
        }
      
    }
    
}

extension TextGraphicsViewController:YXTextViewDelegate{
    func viewIsSelectedFont(fontName: String) {
        if currentEditLabel == nil ||  currentEditLabel?.isOnFirst == false{
            let view = InPutTextView(frame: self.view.bounds)
            view.didAddOrChangeAddressClosure = {[weak self](text) in
                self?.addLabl(fontName: fontName, text: text)
            }
            self.view.addSubview(view)
        }else {
            currentEditLabel?.fontName = fontName
        }
        
        
    }
}

extension TextGraphicsViewController:YXTextOperaViewDelegate{
    func lableViewDidBeginEditing(view:YXTextOperaView){
        initToolsBar()
    }
    func lableViewDidChangeEditing(view:YXTextOperaView){
        
    }
    func labelViewDidEndEditing(view:YXTextOperaView){
        
    }
    
    func labelViewDidClose(view:YXTextOperaView){
        
    }
    
    func labelViewDidShowEditingHandles(view:YXTextOperaView){
         currentEditLabel = view
    }
    func labelViewDidHideEditingHandles(view:YXTextOperaView){
        
    }
    func labelViewDidStartEditing(view:YXTextOperaView){
        
    }
}


extension TextGraphicsViewController:ToolBarViewDelegate{
    func selectedColor(color: UIColor) {
        currentEditLabel?.fontColor = color
    }
}
