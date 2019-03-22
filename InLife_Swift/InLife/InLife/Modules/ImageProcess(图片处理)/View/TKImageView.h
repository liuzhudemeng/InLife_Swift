//
//  TKImageView.h
//  TKImageDemo
//
//  Created by yinyu on 16/7/10.
//  Copyright © 2016年 yinyu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TKCropAreaCornerStyle) {
    TKCropAreaCornerStyleRightAngle,
    TKCropAreaCornerStyleCircle
};
@interface TKImageView : UIView
@property (strong, nonatomic) UIImage *toCropImage;
@property (assign, nonatomic) BOOL needScaleCrop;
@property (assign, nonatomic) BOOL showMidLines;
@property (assign, nonatomic) BOOL showCrossLines;
@property (assign, nonatomic) CGFloat cropAspectRatio;
@property (strong, nonatomic) UIColor *cropAreaBorderLineColor;
@property (assign, nonatomic) CGFloat cropAreaBorderLineWidth;   //中间线的宽度
@property (strong, nonatomic) UIColor *cropAreaCornerLineColor;  //边角颜色
@property (assign, nonatomic) CGFloat cropAreaCornerLineWidth;    //边角宽度
@property (assign, nonatomic) CGFloat cropAreaCornerWidth;
@property (assign, nonatomic) CGFloat cropAreaCornerHeight;
@property (assign, nonatomic) CGFloat minSpace;
@property (assign, nonatomic) CGFloat cropAreaCrossLineWidth;
@property (strong, nonatomic) UIColor *cropAreaCrossLineColor;   //中间虚线的颜色
@property (assign, nonatomic) CGFloat cropAreaMidLineWidth;
@property (assign, nonatomic) CGFloat cropAreaMidLineHeight;
@property (strong, nonatomic) UIColor *cropAreaMidLineColor;     //中间线(中间可以调节比例的短线)的颜色
@property (strong, nonatomic) UIColor *maskColor;
@property (assign, nonatomic) BOOL cornerBorderInImage;
@property (assign, nonatomic) CGFloat initialScaleFactor;
- (UIImage *)currentCroppedImage;
@end
