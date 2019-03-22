//
//  YXCameraSheet.h
//  StoreSpace
//
//  Created by apple on 15/9/28.
//  Copyright (c) 2015年 lyx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileCoreServices/MobileCoreServices.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "ZYQAssetPickerController.h"

typedef void (^DismissBlock)(UIImage *cameraImage);
typedef void (^ArrayBlock)(NSMutableArray *cameraArr);
typedef void (^ErrorBlock)(NSString *str);
typedef enum
{
    //是否可编辑
    Editing,
    NOEditing,
}YXCameraEditingType;

typedef enum
{
    //是否可以选择多张图片
    isSigle,
    isMore,
}YXCameraSlectedType;
@interface YXCameraSheet : NSObject<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,ZYQAssetPickerControllerDelegate>
{
    UIViewController *_toController;
    YXCameraEditingType _type;
    YXCameraSlectedType _selectType;
    DismissBlock _dismissBlock;
    ArrayBlock _arrayBlock;
    ErrorBlock _errorBlock;
    BOOL _isOriginal;  //是否原图
}

-(YXCameraSheet *)CameraSheet;
-(void)CameraWithController:(UIViewController *)toController editing:(YXCameraEditingType)Type  selectType:(YXCameraSlectedType)selectType  isOriginal:(BOOL)original onDismiss:(DismissBlock)dismissed onError:(ErrorBlock)errorBlock;

-(void)OpenMorePhotoController:(UIViewController *)toController editing:(YXCameraEditingType)Type  selectType:(YXCameraSlectedType)selectType onDismiss:(ArrayBlock)arrBlock onError:(ErrorBlock)errorBlock;
@end
