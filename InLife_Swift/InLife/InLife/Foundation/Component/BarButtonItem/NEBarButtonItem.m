//
//  ELBarButtonItem.m
//  vstore_iphone
//
//  Created by shinn on 14-8-24.
//  Copyright (c) 2014年 Netease. All rights reserved.
//

#import "NEBarButtonItem.h"
//#import "NECoreUI.h"

@interface NEBarButtonItem() {
    UILabel *_textLabel;
}

@end

@implementation NEBarButtonItem

+ (instancetype)itemWithTitle:(NSString *)aTitle
                            target:(id)aTarget
                            action:(SEL)anAction
{
    return [NEBarButtonItem itemWithTitle:aTitle normalImage:nil highligtedImage:nil target:aTarget action:anAction];
}

+ (instancetype)itemWithTitle:(NSString *)aTitle
                       normalImage:(UIImage *)aNormalImage
                   highligtedImage:(UIImage *)aHighlightedImage
                            target:(id)aTarget
                            action:(SEL)anAction
{
    return [NEBarButtonItem itemWithTitle:aTitle
                               titleColor:[UIColor darkGrayColor]
                          titleEdgeInsets:UIEdgeInsetsZero
                              normalImage:aNormalImage
                          highligtedImage:aHighlightedImage
                                   target:aTarget
                                   action:anAction];
}

+ (instancetype)itemWithTitle:(NSString *)aTitle
                        titleColor:(UIColor*)aTitleColor
                   titleEdgeInsets:(UIEdgeInsets)aInsets
                       normalImage:(UIImage *)aNormalImage
                   highligtedImage:(UIImage *)aHighlightedImage
                            target:(id)aTarget
                            action:(SEL)anAction
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // Since the buttons can be any width we use a thin image with a stretchable center point
//    UIImage *buttonImage = [aNormalImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
//    UIImage *buttonPressedImage = [aHighlightedImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    UIImage *buttonImage = aNormalImage;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat scale = screenWidth/320.f;
    
    [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:scale*15]];
    [button setTitleColor:aTitleColor forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    CGRect buttonFrame = [button frame];
    
    
    CGSize fitSize;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0) {
        fitSize = [aTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:scale*20.0]}];
    }else{
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
        fitSize =[aTitle  sizeWithFont:[UIFont boldSystemFontOfSize:scale*12.0]];
        fitSize.width = MAX(buttonImage.size.width, fitSize.width + 24.0);
#endif
    }
    //这里是自适应
//    buttonFrame.size.width = MAX(buttonImage.size.width, fitSize.width + 0);
//    buttonFrame.size.height = buttonImage.size.height;
    buttonFrame.size.width = 80;
    buttonFrame.size.height = 40;
    if (buttonImage.size.height == 0) {
        buttonFrame.size.height = fitSize.height;
    }
    [button setFrame:buttonFrame];
    
    [button setTitleEdgeInsets:aInsets];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:buttonImage forState:UIControlStateHighlighted];
    button.contentHorizontalAlignment = 1;
    [button.titleLabel setShadowColor:[UIColor colorWithRed:0x00 green:0x00 blue:0x00 alpha:0.75f]];
    [button.titleLabel setShadowOffset:CGSizeMake(0.f, -1.f)];
    
    [button setTitle:aTitle forState:UIControlStateNormal];
    [button addTarget:aTarget action:anAction forControlEvents:UIControlEventTouchUpInside];
    //        [button setBackgroundColor:[UIColor redColor]];
    button.clipsToBounds = YES;
    NEBarButtonItem *buttonItem = [[NEBarButtonItem alloc] initWithCustomView:button];
    buttonItem->_textLabel = button.titleLabel;
    return buttonItem;
}



+ (instancetype)itemWithCustomView:(UIView *)view
                                leftGap:(CGFloat)gapleft
                               rightGap:(CGFloat)gapright
                                 target:(id)aTarget action:(SEL)anAction
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:aTarget action:anAction forControlEvents:UIControlEventTouchUpInside];
    
    CGRect r = {0};
    r.size = CGSizeMake(view.frame.size.width + gapleft + gapright, view.frame.size.height+20);
    button.frame = r;
    
    view.center = CGPointMake(r.size.width/2, r.size.height/2);
    CGRect frame = view.frame;
    frame.origin.x = gapleft;
    view.frame = frame;
    
    UIView *v = [[UIView alloc] initWithFrame:r];
    [v addSubview:view];
    [v addSubview:button];
    //    v.backgroundColor = ColorRed;
    NEBarButtonItem *buttonItem = [[NEBarButtonItem alloc] initWithCustomView:v];
    return buttonItem;
}
@end
