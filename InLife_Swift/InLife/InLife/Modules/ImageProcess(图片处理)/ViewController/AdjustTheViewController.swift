//
//  AdjustTheViewController.swift
//  InLife
//
//  Created by apple on 17/8/16.
//  Copyright © 2017年 lyx. All rights reserved.
//

import UIKit
import Photos

class AdjustTheViewController: BaseViewController {
    var originImage:UIImage?
    var pressImage:UIImage?
    let adjustTitleArr:[String] =  ["亮度","对比度","饱和度","曝光","色调","褪色","噪点","锐化","模糊"]
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
        self.view.addSubview(scrollView)
        self.view.addSubview(tabbarView)
        
        let longGes = UILongPressGestureRecognizer(target: self, action: #selector(toSaveImage(ges:)))
        imageV.addGestureRecognizer(longGes)
        scrollView.addSubview(toolBar)
        scrollView.addSubview(filterView)
        imageV.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(40)
        }
        tabbarView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self.view)
            make.top.equalTo(scrollView.snp.bottom)
            make.height.equalTo(60)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(120)
            make.top.equalTo(imageV.snp.bottom)
        }
        
        toolBar.snp.makeConstraints { (make) in
            make.left.height.top.equalTo(scrollView)
            make.width.equalTo(kMainScreenWidth)
        }
       
        filterView.snp.makeConstraints { (make) in
            make.left.width.equalTo(kMainScreenWidth)
            make.top.height.equalTo(scrollView)
        }
       
    }

    
    func toSaveImage(ges:UILongPressGestureRecognizer){
        if ges.state == .ended {
            let alertView = UIAlertView(title:nil, message: "确定保存图片到相册吗？", delegate: self, cancelButtonTitle: "取消")
            alertView.addButton(withTitle: "确定")
            alertView.show()
        }
       
    }
    
    /*****调整图片******/
    
    func updateSliderValue(value:CGFloat,tagView:NSInteger){
        switch tagView {
        case 0:
            //亮度
            let image = ImageTools.changeValueForBrightnessFilter(image: self.originImage!, value: value)
            self.imageV.image = image
             self.pressImage = image
            break
        case 1:
            //对比度
            let image = ImageTools.changeValueForContrastFilter(image: self.originImage!, value: value)
            self.imageV.image = image
             self.pressImage = image
            break
        case 2:
            //饱和度
            let image = ImageTools.changeValueForSaturationFilter(image: self.originImage!, value: value)
            self.imageV.image = image
             self.pressImage = image
            break
        case 3:
            //曝光度
            let image = ImageTools.changeValueForExposureFilter(image: self.originImage!, value: value)
            self.imageV.image = image
             self.pressImage = image
            break
        case 4:
            //色调
            let image = ImageTools.changeValueForWhiteBalanceFilter(image: self.originImage!, value: value)
            self.imageV.image = image
             self.pressImage = image
            break
        case 5:
            //褪色
            break
        case 6:
            //噪点
            let image = ImageTools.changeValueForPosterizeFilter(image: self.originImage!, value: value)
            self.imageV.image = image
             self.pressImage = image
            break
        case 7:
            //锐化
            let image = ImageTools.changeValueForSharpenFilter(image: self.originImage!, value: value)
            self.imageV.image = image
             self.pressImage = image
            break
        case 8:
            ////模糊
            let image = ImageTools.changeValueForGaussianBlurFilter(image: self.originImage!, value: value)
            self.imageV.image = image
            self.pressImage = image
            break
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    lazy var imageV:UIImageView = {
        let object = UIImageView()
        object.contentMode = .scaleAspectFit
        object.image = self.originImage
        object.isUserInteractionEnabled = true
        return object
    }()
    
    fileprivate lazy var tabbarView:TabBarView = {
        let object = TabBarView(frame: CGRect.zero,titleArr:["调整","滤镜"])
        object.delegate = self
        return object
    }()
    
    
    
    //调整
    fileprivate lazy var toolBar:CuttingView = {
        let object = CuttingView(frame: CGRect.zero, normalArr: ["brightness","contrast","saturation","exposure","tonal","fade","noise","sharpen"," fuzzy"], titleArr: self.adjustTitleArr)
        object.tag = 1
        object.delegate = self
        return object
    }()
    
    //滤镜
    fileprivate lazy var filterView:CuttingView = {
        let object = CuttingView(frame: CGRect.zero, normalArr: ["brightness","contrast","saturation","exposure","tonal","fade","noise","sharpen"," fuzzy"], titleArr: ["原图","怀旧","素描","卡通","浮雕","黑色描边","边缘阴影","流年","HDR"])
        object.tag = 2
        object.delegate = self
        return object
    }()
    
    fileprivate lazy var scrollView:UIScrollView = {
        let object = UIScrollView()
        object.showsVerticalScrollIndicator = false
        object.showsHorizontalScrollIndicator = false
        object.isScrollEnabled = false
        object.isPagingEnabled = true
        object.backgroundColor = UIColor.red
        object.contentSize = CGSize(width: kMainScreenWidth*2, height: 0)
        return object
    }()


}

extension AdjustTheViewController:TabBarViewDelegate{
    func switchFunctionModule(index: NSInteger) {
        if index == 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            })
        }else{
            UIView.animate(withDuration: 0.25, animations: {
                self.scrollView.contentOffset = CGPoint(x: kMainScreenWidth, y: 0)
            })
        }
    }
    
    func backOrNext(index: NSInteger) {
        if index == 1 {
            _ = self.navigationController?.popViewController(animated: true)
            return
        }else{
//            getImageExifInfo()
            let vc = TextGraphicsViewController()
            vc.originImage = self.imageV.image
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func  getImageExifInfo(){
//        let imageData = UIImageJPEGRepresentation(self.originImage!, 1)
//        let source = CGImageSourceCreateWithData(imageData! as CFData, nil)
//        let imageInfo = CGImageSourceCopyPropertiesAtIndex(source!, 0, nil)
//        let metaDataDic = imageInfo
        
        let imageData = UIImageJPEGRepresentation(self.originImage!, 1)
        let source: CGImageSource = CGImageSourceCreateWithData(imageData! as CFData, nil)!
        let imageInfo = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [AnyHashable: Any]
//        let metaDataDic = imageInfo
//        let exifDic = (metaDataDic?[(kCGImagePropertyExifDictionary as String)])
//        let GPSDic = (metaDataDic?[(kCGImagePropertyGPSDictionary as String)])
        HHLog("-----------_图片的exit 信息是 --------\(imageInfo)")
    }
}

extension AdjustTheViewController:CuttingViewDelegate{
    func ClickToolBtn(index: NSInteger, proportation: CGFloat,tagView:CuttingView) {
        if tagView.tag == 1 {
            let popView = PercentageView(frame:CGRect(x: 0, y: kMainScreenHeight, width: kMainScreenWidth, height: 240))
            popView.titleType = adjustTitleArr[index]
            
            switch index {
            case 0:
                popView.configuationSlider(max: 0.5, min: -0.5, current: 0) //亮度
                break
            case 1:
                popView.configuationSlider(max: 4.0, min: 0.0, current:2.0) //对比度
                break
            case 2:
                popView.configuationSlider(max: 2.0, min: 0.0, current: 1.0) //饱和度
                break
            case 3:
                popView.configuationSlider(max: 10.0, min: -10.0, current: 0) //曝光度
                break
            case 4:
                popView.configuationSlider(max: 10000, min: 1000, current: 5000)  //色调
                break
            case 5:
                popView.configuationSlider(max: 0.5, min: -0.5, current: 0) //褪色
                break
            case 6:
                popView.configuationSlider(max: 1.0, min: 0, current: 0) //噪点
                break
            case 7:
                popView.configuationSlider(max: 4.0, min: -4.0, current: 0) //锐化
                break
            case 8:
                popView.configuationSlider(max:5.0, min: 0.0, current: 0.0) //模糊
                break
            default:
                break
            }
            popView.didSelectBlock = {(value) in
                self.updateSliderValue(value: value, tagView: index)
            }
            popView.showInContainer(contentView: self.view)
        }else{
            var image = UIImage()
            switch index{
            case 1:
                //反色滤镜
                 image =  ImageTools.invertForFilter(image: self.originImage!, value: 1.0)
                break
            case 2:
                //素描滤镜
                 image = ImageTools.passthroughFilter(image: self.originImage!, value: 1.0)
                break
            case 3:
                //卡通滤镜
                 image = ImageTools.katongFilter(image: self.originImage!, value: 1.0)
                break
            case 4:
                //浮雕滤镜
                 image = ImageTools.thouthOldFilter(image: self.originImage!, value: 1.0)
                break
            case 5:
                //黑色描边滤镜
                 image = ImageTools.toonFilter(image: self.originImage!, value: 1.0)
                break
            case 6:
                //滤镜处理边缘阴影
                 image = ImageTools.darkSideFilter(image: self.originImage!, value: 1.0)
                break
            case 7:
                //流年
                image = ImageTools.applySoftEleganceFilter(image: self.originImage!, value: 1.0)
                break
            case 8:
                //HDR
                image = ImageTools.applyMissetikateFilter(image: self.originImage!, value: 1.0)
                break
            default:
                break
            }
            self.pressImage = image
            self.imageV.image = image
        }
    }
    
    
  
}

extension AdjustTheViewController:UIAlertViewDelegate{
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            savePriture(image: pressImage!)
        }
    }
    
    
    func savePriture(image:UIImage){
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        if error != nil
        {
            
            print("error!")
            return
            
        }else{
            YXHudTool.share.showOKHud(text: "保存成功", delay: 0.25, inView: self.view)
        }
        
    }
    
    
//    func saveTheHiFIPicture(image:UIImage) {
//        PHPhotoLibrary.shared().performChanges({
//            let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
//            let assetPlaceholder = result.placeholderForCreatedAsset
//            HHLog(assetPlaceholder?.localIdentifier ?? "")
//        }) { (isSuccess, error) in
//            if isSuccess{
//                HHLog("__________报错成功")
//            }
//        }
//    }
//    func saveTheHiFIPicture(image:UIImage) {
//        let activityView = UIActivityViewController(activityItems: [image], applicationActivities: nil)
//        activityView.excludedActivityTypes =  [UIActivityType.copyToPasteboard,UIActivityType.message]
//        activityView.completionHandler = {(_ activityType, _ completed) -> Void in
//            if completed && (activityType == .saveToCameraRoll)
//            {
//                let alert = UIAlertView(title: "Saved successfully", message: "", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "")
//                alert.show()
//            }
//        }
//        present(activityView, animated: true) { _ in }
//    }
}
