//
//  UIImage+Sale.swift
//  InLife
//
//  Created by apple on 2017/11/1.
//  Copyright © 2017年 lyx. All rights reserved.
//

import UIKit
private let  kPhotoCompressPixelMaxWith:CGFloat = 5000       //图片最大像素宽
extension UIImage {
    //压缩图片到固定大小
    func compressImage(maxLength: Int) -> UIImage? {
        guard var dataOrg = UIImageJPEGRepresentation(self, 1),
            dataOrg.count > maxLength else {
                return self
        }
        let newSize = self.scaleImage(image: self, imageLength: kPhotoCompressPixelMaxWith)
        let newImage = self.resizeImage(image: self, newSize: newSize)
        
        var compress: CGFloat = 0.9
        var data = UIImageJPEGRepresentation(newImage, compress)
        while data!.count > maxLength && compress > 0.01 {
            compress -= 0.02
            data = UIImageJPEGRepresentation(newImage, compress)
        }
        HHLog("压缩后图片的大小===\(data!.count)")
        return UIImage(data: data!)!
    }
    
    //裁剪图片到固定尺寸
    func  scaleImage(image: UIImage, imageLength: CGFloat) -> CGSize {
        
        var newWidth:CGFloat = 0.0
        var newHeight:CGFloat = 0.0
        let width = image.size.width
        let height = image.size.height
        
        if (width > imageLength || height > imageLength){
            
            if (width > height) {
                
                newWidth = imageLength;
                newHeight = newWidth * height / width;
                
            }else if(height > width){
                
                newHeight = imageLength;
                newWidth = newHeight * width / height;
                
            }else{
                
                newWidth = imageLength;
                newHeight = imageLength;
            }
            
        }
        return CGSize(width: newWidth, height: newHeight)
    }
    
    
    func resizeImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
}
