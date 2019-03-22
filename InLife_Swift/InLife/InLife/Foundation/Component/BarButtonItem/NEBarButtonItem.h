//
//  ELBarButtonItem.h
//  vstore_iphone
//
//  Created by shinn on 14-8-24.
//  Copyright (c) 2014年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NEBarButtonItem : UIBarButtonItem

@property (nonatomic, readonly) UILabel *textLabel; // readonly, 用于设置字体，及颜色

/**
 带文字按钮
 */
+ (instancetype)itemWithTitle:(NSString *)aTitle
                       target:(id)aTarget
                       action:(SEL)anAction;

/**
 带文字和图的按钮
 */
+ (instancetype)itemWithTitle:(NSString *)aTitle
                  normalImage:(UIImage *)aNormalImage
              highligtedImage:(UIImage *)aHighlightedImage
                       target:(id)aTarget
                       action:(SEL)anAction;

+ (instancetype)itemWithTitle:(NSString *)aTitle
                   titleColor:(UIColor*)aTitleColor
              titleEdgeInsets:(UIEdgeInsets)aInsets
                  normalImage:(UIImage *)aNormalImage
              highligtedImage:(UIImage *)aHighlightedImage
                       target:(id)aTarget
                       action:(SEL)anAction;

/**
 自定义的view的按钮
 */
+ (instancetype)itemWithCustomView:(UIView *)view
                           leftGap:(CGFloat)gapleft
                          rightGap:(CGFloat)gapright
                            target:(id)aTarget
                            action:(SEL)anAction;
@end
