//
//  ImageProcessViewController.swift
//  InLife
//
//  Created by apple on 17/7/27.
//  Copyright © 2017年 lyx. All rights reserved.
//

import UIKit

class ImageProcessViewController: BaseViewController {
    var originImage:UIImage?
    let ImageWith:CGFloat = 44
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
        self.view.addSubview(imgV)
        self.view.addSubview(tabbarView)
        self.view.addSubview(toolBar)
        imgV.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(20)
        }
        
        tabbarView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self.view)
            make.top.equalTo(toolBar.snp.bottom)
            make.height.equalTo(60)
        }
        toolBar.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(imgV.snp.bottom)
            make.height.equalTo(120)
        }

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func getImageExif(){
        let imageData = UIImageJPEGRepresentation(self.originImage!, 1)
        let source = CGImageSourceCreateWithData(imageData as! CFData, nil)
        let imageInfo = CGImageSourceCopyPropertiesAtIndex(source!, 0, nil)
        HHLog("----------\(imageInfo)")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    fileprivate lazy var imgV:TKImageView = {
        let object = TKImageView()
        object.toCropImage = self.originImage
        object.showMidLines = true
        object.needScaleCrop = true
        object.showCrossLines = true
        object.cornerBorderInImage  = false
        object.cropAreaCornerWidth = self.ImageWith
        object.cropAreaCornerHeight = self.ImageWith
        object.minSpace = 30
        object.cropAreaCornerLineColor = Btn_blue
        object.cropAreaBorderLineColor = UIColor.white
        object.cropAreaCornerLineWidth = 1.5
        object.cropAreaBorderLineWidth = 0.5
        object.cropAreaMidLineWidth = 20
        object.cropAreaMidLineHeight = 1.5   //中间线高度
        object.cropAreaMidLineColor = Btn_blue
        object.cropAreaCrossLineColor = UIColor.white
        object.cropAreaCrossLineWidth = 0.5
        object.initialScaleFactor = 0.8
        return object
    }()
    
    
    fileprivate lazy var tabbarView:TabBarView = {
        let object = TabBarView(frame: CGRect.zero,titleArr:["裁剪"])
        object.delegate = self
        return object
    }()
    
    
    fileprivate lazy var toolBar:CuttingView = {
       let object = CuttingView(frame: CGRect.zero, normalArr: ["crop_free","btn_img_rotate_right_a","btn_flip_updown_a","btn_flip_leftright_a"], titleArr: ["画布比","旋转","上下翻转","左右翻转"])
        object.proportionArr = ["crop_free","crop_1_1","crop_3_4","crop_4_3","crop_9_16","crop_16_9"]
        object.valuesArr = [0,1,CGFloat(3.0/4.0),CGFloat(4.0/3.0),CGFloat(9.0/16.0),CGFloat(16.0/9.0)]
        object.tag = 1
        object.delegate = self
       return object
    }()
    
    //滤镜
    fileprivate lazy var filterView:CuttingView = {
        let object = CuttingView(frame: CGRect.zero, normalArr: ["crop_free","btn_img_rotate_right_a","btn_flip_updown_a","btn_flip_leftright_a"], titleArr: ["画布比","旋转","上下翻转","左右翻转"])
        object.proportionArr = ["crop_free","crop_1_1","crop_3_4","crop_4_3","crop_9_16","crop_16_9"]
        object.valuesArr = [0,1,CGFloat(3.0/4.0),CGFloat(4.0/3.0),CGFloat(9.0/16.0),CGFloat(16.0/9.0)]
        object.tag = 2
        object.delegate = self
        return object
    }()

   
}

extension ImageProcessViewController:TabBarViewDelegate{
    internal func switchFunctionModule(index: NSInteger) {
        
    }

    func backOrNext(index: NSInteger) {
        if index == 1 {
           _ = self.navigationController?.popViewController(animated: true)
            return
        }else{
            let adjustVC = AdjustTheViewController()
            adjustVC.originImage = imgV.currentCroppedImage()
            _ = self.navigationController?.pushViewController(adjustVC, animated: true)
        }
        
    }
}

extension ImageProcessViewController:CuttingViewDelegate{
    func ClickToolBtn(index: NSInteger,proportation:CGFloat,tagView:CuttingView) {
        switch index {
        case 0:
            imgV.cropAspectRatio = proportation
            break
        case 1:
            imgV.toCropImage = self.imgV.toCropImage.rotate(UIImageOrientation.right)
            break
        case 2:
            imgV.toCropImage = self.imgV.toCropImage.flipVertical()
            break
        case 3:
            imgV.toCropImage = self.imgV.toCropImage.flipHorizontal()
            break
        default:
            break
        }
    }
}
