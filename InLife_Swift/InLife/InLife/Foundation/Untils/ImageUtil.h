//
//  RootViewController.h
//  pictureProcess
//
//  Created by Ibokan on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <UIKit/UIKit.h>
@interface ImageUtil : NSObject

+ (NSDictionary*)exifDictionary:(NSURL*)imageUrl;  //获取图片的exif信息
+ (UIImage *)imageWithImage:(UIImage*)inImage withColorMatrix:(const float*)f;


@end
