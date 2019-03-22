//
//  ImageTools.swift
//  InLife
//
//  Created by apple on 17/8/25.
//  Copyright © 2017年 lyx. All rights reserved.
//

import UIKit
import GPUImage

class ImageTools: NSObject {

    
    /// 调整亮度
    ///
    /// - Parameter image: 原图片
    /// - Returns: 调整过亮度以后的图片
    class func changeValueForBrightnessFilter(image:UIImage,value:CGFloat) -> UIImage{
        let filter = GPUImageBrightnessFilter()
        filter.brightness = value    // -1.0~1.0
//        filter.forceProcessing(at: image.size) //设置要渲染的区域
        let pic = GPUImagePicture(image: image) //获取数据源
        pic?.addTarget(filter)   //添加上滤镜
        pic?.processImage() //开始渲染
        filter.useNextFrameForImageCapture()
        let result = filter.imageFromCurrentFramebuffer() //渲染后的图片
        return result!
    }
    
    
    /// 调整对比度
    ///
    /// - Parameters:
    ///   - image: 原图片
    ///   - value: 对比度值
    /// - Returns: 调整过后的图片
    class func changeValueForContrastFilter(image:UIImage,value:CGFloat) -> UIImage{
        let filter = GPUImageContrastFilter()
        filter.contrast = value        // 0.0~4.0
//        filter.forceProcessing(at: image.size)
        let pic = GPUImagePicture(image: image)
        pic?.addTarget(filter)
        pic?.processImage()
        filter.useNextFrameForImageCapture()
        return filter.imageFromCurrentFramebuffer()
    }
    
    /// 调整饱和度
    ///
    /// - Parameters:
    ///   - image: 原图片
    ///   - value: 饱和度值
    /// - Returns: 调整过后的图片
    class func changeValueForSaturationFilter(image:UIImage,value:CGFloat) -> UIImage{
        let filter = GPUImageSaturationFilter()
        filter.saturation = value        // 0.0~2.0
//        filter.forceProcessing(at: image.size)
        let pic = GPUImagePicture(image: image)
        pic?.addTarget(filter)
        pic?.processImage()
        filter.useNextFrameForImageCapture()
        return filter.imageFromCurrentFramebuffer()
    }
    
    
    /// 调整曝光度
    ///
    /// - Parameters:
    ///   - image: 原图片
    ///   - value: 曝光度值
    /// - Returns: 调整过后的图片
    class func changeValueForExposureFilter(image:UIImage,value:CGFloat) -> UIImage{
        let filter = GPUImageExposureFilter()
        filter.exposure = value        // -10.0~10.0
//        filter.forceProcessing(at: image.size)
        let pic = GPUImagePicture(image: image)
        pic?.addTarget(filter)
        pic?.processImage()
        filter.useNextFrameForImageCapture()
        return filter.imageFromCurrentFramebuffer()

    }
    
    
    /// 调整色温
    ///
    /// - Parameters:
    ///   - image:  原图片
    ///   - value: 色温值
    /// - Returns: 调整过后的图片
    class func changeValueForWhiteBalanceFilter(image:UIImage,value:CGFloat) -> UIImage{
        let filter = GPUImageWhiteBalanceFilter()
        filter.temperature = value        // -10.0~10.0
        filter.tint = 0.0
//        filter.forceProcessing(at: image.size)
        let pic = GPUImagePicture(image: image)
        pic?.addTarget(filter)
        pic?.processImage()
        filter.useNextFrameForImageCapture()
        return filter.imageFromCurrentFramebuffer()
    }
    
    
    
    /// 锐化
    ///
    /// - Parameters:
    ///   - image: 原图片
    ///   - value: 锐化值
    /// - Returns: 调整过后的图片
    class func changeValueForSharpenFilter(image:UIImage,value:CGFloat) -> UIImage{
        let filter = GPUImageSharpenFilter()
        filter.sharpness = value        // -4.0~4.0
//        filter.forceProcessing(at: image.size)
        let pic = GPUImagePicture(image: image)
        pic?.addTarget(filter)
        pic?.processImage()
        filter.useNextFrameForImageCapture()
        return filter.imageFromCurrentFramebuffer()
    }
    
    /// 模糊
    ///
    /// - Parameters:
    ///   - image: 原图片
    ///   - value: 清晰度
    /// - Returns: 调整过后的图片
    class func changeValueForGaussianBlurFilter(image:UIImage,value:CGFloat) -> UIImage{
        let filter = GPUImageGaussianBlurFilter()
        filter.texelSpacingMultiplier = value  //是模糊的强度，数值越大，模糊效果越明显
        filter.blurRadiusInPixels = 2.0  //是像素范围，用于计算平均值
        filter.forceProcessing(at: image.size)
        let pic = GPUImagePicture(image: image)
        pic?.addTarget(filter)
        pic?.processImage()
        filter.useNextFrameForImageCapture()
        return filter.imageFromCurrentFramebuffer()
    }
    
    
    /// 噪点
    ///
    /// - Parameters:
    ///   - image:  原图片
    ///   - value: 噪点度
    /// - Returns: 调整过后的图片
    class func changeValueForPosterizeFilter(image:UIImage,value:CGFloat) -> UIImage{
        let filter = GPUImagePerlinNoiseFilter()
        filter.colorStart = GPUVector4(one: 0, two: 1, three: 0, four: 0)
        filter.colorFinish =  GPUVector4(one: 0, two: GLfloat(value), three: 0, four: 0)
//        filter.forceProcessing(at: image.size)
        let pic = GPUImagePicture(image: image)
        pic?.addTarget(filter)
        pic?.processImage()
        filter.useNextFrameForImageCapture()
        return filter.imageFromCurrentFramebuffer()
    }
    
    
    /// 滤镜处理  怀旧
    ///
    /// - Parameters:
    ///   - image: 原图片
    ///   - value: 处理反色值
    /// - Returns: 处理后的图片
    class func invertForFilter(image:UIImage,value:CGFloat)  ->UIImage{
        let filter = GPUImageSepiaFilter()
        let resultImage = fileterProcess(image: image, filter: filter)
        return resultImage
    }
  
    
    //素描
    class func passthroughFilter(image:UIImage,value:CGFloat) -> UIImage{
        let passthroughFilter = GPUImageSketchFilter()
        passthroughFilter.useNextFrameForImageCapture()
        let resultImage = fileterProcess(image: image, filter: passthroughFilter)
        return resultImage
    }
    
    //卡通
    class func katongFilter(image:UIImage,value:CGFloat) -> UIImage{
        let passthroughFilter = GPUImageSmoothToonFilter()
        passthroughFilter.blurRadiusInPixels = 0.5
        let resultImage = fileterGroupProcess(image: image, filter: passthroughFilter)
        return resultImage
    }
    
    //浮雕滤镜EmbossFilter
    class func thouthOldFilter(image:UIImage,value:CGFloat) -> UIImage{
        let passthroughFilter = GPUImageEmbossFilter()
        passthroughFilter.intensity = 2.5
        let resultImage = fileterProcess(image: image, filter: passthroughFilter)
        return resultImage
    }
    
    
    //黑色描边描边滤镜
    class func toonFilter(image:UIImage,value:CGFloat) -> UIImage{
        let passthroughFilter = GPUImageToonFilter()
        passthroughFilter.threshold = 0.3
        let resultImage = fileterProcess(image: image, filter: passthroughFilter)
        return resultImage
    }
    
    
    //边缘阴影滤镜
    class func darkSideFilter(image:UIImage,value:CGFloat) -> UIImage{
        let disFilter = GPUImageVignetteFilter()
        let resultImage = fileterProcess(image: image, filter: disFilter)
        return resultImage
    }
    
    //流年
    class func applySoftEleganceFilter(image:UIImage,value:CGFloat) -> UIImage{
        let disFilter = GPUImageSoftEleganceFilter()
        let resultImage = fileterGroupProcess(image: image, filter: disFilter)
        return resultImage
    }
    //HDR
    class func applyMissetikateFilter(image:UIImage,value:CGFloat) -> UIImage{
        let disFilter = GPUImageMissEtikateFilter()
        let resultImage = fileterGroupProcess(image: image, filter: disFilter)
        return resultImage
    }
    

    
  class  func  fileterProcess(image:UIImage,filter:GPUImageFilter) -> UIImage{
        filter.useNextFrameForImageCapture()
        let stillImageSource = GPUImagePicture(image:image)    //获取数据源
        stillImageSource?.addTarget(filter)
        stillImageSource?.processImage()          //开始渲染
        let finallImage = filter.imageFromCurrentFramebuffer()
        return finallImage!
    }
    
    
    class  func  fileterGroupProcess(image:UIImage,filter:GPUImageFilterGroup) -> UIImage{
        filter.useNextFrameForImageCapture()
        let stillImageSource = GPUImagePicture(image:image)    //获取数据源
        stillImageSource?.addTarget(filter)
        stillImageSource?.processImage()          //开始渲染
        let finallImage = filter.imageFromCurrentFramebuffer()
        return finallImage!
    }
    
    
    /// 释放内存
    class func ReleseGPU(){
        GPUImageContext.sharedImageProcessing().framebufferCache.purgeAllUnassignedFramebuffers()
    }
    
    
    
   /// 获取图片大小
   ///
   /// - Parameter image:
   /// - Returns: 
   class func getImageKB(image:UIImage) ->Int{
    let imageData:NSData = UIImageJPEGRepresentation(image, 1)! as NSData
    let length = imageData.length  ///(1024*1024)
//    let byteStr:String = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
//    HHLog("data 的长度 ： \(byteStr.characters.count)")
    return length
    }
}
