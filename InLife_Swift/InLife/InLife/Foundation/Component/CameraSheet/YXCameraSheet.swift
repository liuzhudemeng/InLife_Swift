//
//  YXCameraSheet.swift
//  InLife
//
//  Created by apple on 2017/11/1.
//  Copyright © 2017年 lyx. All rights reserved.
//

import UIKit
import AssetsLibrary


class YXCameraSheet: NSObject {
   fileprivate static let sheetTools = YXCameraSheet()
    
    var toViewController = UIViewController()
    var _dismissBlock:((UIImage) -> Void)?
    var _errorBlock:((String) -> Void)?
    
    class var shared: YXCameraSheet {
        return sheetTools
    }
    
    func OpenMorePhotoController(toController:UIViewController,dismissed:((UIImage) -> Void)?,errorBlock:((String) -> Void)?){
        toViewController = toController
        _dismissBlock = dismissed
        _errorBlock = errorBlock
        sheet()
    }
    
    func sheet(){
        let  actionsheet = UIActionSheet(title: "选择照片来源", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "拍照", otherButtonTitles: "从相册选择")
        actionsheet.show(in: toViewController.view)
    }
    
    
    func openPhotoToViewController(viewController:UIViewController,sourceType:UIImagePickerControllerSourceType){
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: sourceType)
        if UIImagePickerController.isSourceTypeAvailable(sourceType) && mediaTypes!.count > 0 {
            let imagePick = UIImagePickerController()
            imagePick.mediaTypes = mediaTypes ?? [String]()
            imagePick.isNavigationBarHidden = true
            imagePick.allowsEditing = false
            imagePick.delegate = self
            imagePick.sourceType = sourceType
            viewController.present(imagePick, animated: true) { _ in }
        }
        else {
            let alert = UIAlertView(title: "警告", message: "该设备不支持!", delegate: nil, cancelButtonTitle: "知道了", otherButtonTitles: "")
            alert.show()
        }
    }
    
}

extension YXCameraSheet:UIActionSheetDelegate{
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            openPhotoToViewController(viewController: toViewController, sourceType: UIImagePickerControllerSourceType.camera)
            break
        default:
             openPhotoToViewController(viewController: toViewController, sourceType: UIImagePickerControllerSourceType.photoLibrary)
            break
        }
    }
}

extension YXCameraSheet:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            YXHudTool.share.showTextHud(text:  "")
            let  editedImage: UIImage =  info[UIImagePickerControllerOriginalImage] as! UIImage  //获取原始的图像
        
             HHLog("处理前图片大小====\(ImageTools.getImageKB(image: editedImage))")
            //判断是调用照相机还是图片库，如果是照相机的话，将图像保存到媒体库中
            if picker.sourceType == .camera {
                //将该图像保存到媒体库中
                UIImageWriteToSavedPhotosAlbum(editedImage, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        let compressImage =  editedImage.compressImage(maxLength: 20*1024*1024)
        self._dismissBlock!(compressImage!)
        picker.dismiss(animated: true, completion: nil)
         YXHudTool.share.hideHud()
    }
    
    func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        if error != nil
        {
           YXHudTool.share.showOKHud(text: "保存失败", delay: 0.25, inView:toViewController.view)
            return
        }
        
    }
    
    
//    func  getImageExifInfo(info: [String : Any]){
//        let imageURL = info[UIImagePickerControllerReferenceURL] as? URL
//        let exitDic = ImageUtil.exifDictionary(imageURL)
//        HHLog("图片的信息是------\(String(describing: exitDic))")
//    }
}
