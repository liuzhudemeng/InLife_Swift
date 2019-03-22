//
//  YXCameraSheet.m
//  StoreSpace
//
//  Created by apple on 15/9/28.
//  Copyright (c) 2015年 lyx. All rights reserved.
//

#import "YXCameraSheet.h"



@implementation YXCameraSheet

static  YXCameraSheet *yxCameraSheet;
-(YXCameraSheet *)CameraSheet
{
    @synchronized(yxCameraSheet)
    {
        if (yxCameraSheet == nil)
        {
            yxCameraSheet = [[YXCameraSheet alloc] init];
        }
    }
    return yxCameraSheet;
}

-(void)CameraWithController:(UIViewController *)toController editing:(YXCameraEditingType)Type  selectType:(YXCameraSlectedType)selectType   isOriginal:(BOOL)original onDismiss:(DismissBlock)dismissed onError:(ErrorBlock)errorBlock
{
    _toController=toController;
    _type=Type;
    _selectType = selectType;
    _dismissBlock=[dismissed copy];
    _errorBlock=[errorBlock copy];
    _isOriginal = original;
    [self sheet];
}

-(void)OpenMorePhotoController:(UIViewController *)toController editing:(YXCameraEditingType)Type  selectType:(YXCameraSlectedType)selectType onDismiss:(ArrayBlock)arrBlock onError:(ErrorBlock)errorBlock
{
    _toController=toController;
    _type=Type;
    _selectType = selectType;
    _arrayBlock = [arrBlock copy];
    _errorBlock=[errorBlock copy];
    [self sheet];

}
-(void)sheet
{
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择照片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [actionsheet showInView:_toController.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [self openPhotoToViewController:_toController sourceType:UIImagePickerControllerSourceTypeCamera];
    }
    if (buttonIndex==1)
    {
        if (_selectType == isMore) {
            //可以挑选多张图片
            ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
            picker.maximumNumberOfSelection = 10;
            picker.assetsFilter = [ALAssetsFilter allPhotos];
            picker.showEmptyGroups=NO;
            picker.delegate=self;
            picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                    NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                    return duration >= 5;
                } else {
                    return YES;
                }
            }];
            
            [_toController presentViewController:picker animated:YES completion:NULL];
        }else
        {
            //只能选择一张图片
            [self openPhotoToViewController:_toController sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }

}

#pragma mark  UIImagePickerControllerDelegate
-(UIImagePickerController *)openPhotoToViewController:(UIViewController *)viewController sourceType:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && mediaTypes.count>0) {
        UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
        imagePick.mediaTypes = mediaTypes;
        imagePick.navigationBarHidden = YES;
        //判断是否可编辑
        if (_type==Editing)
        {
            imagePick.allowsEditing = YES;
        }
        else
        {
            imagePick.allowsEditing = NO;
        }
        imagePick.delegate = self;
        imagePick.sourceType = sourceType;
        [viewController presentViewController:imagePick animated:YES completion:nil];
        return imagePick;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"该设备不支持!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    return nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //判断是静态图像还是视频
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage* editedImage =nil;
//        if ([info objectForKey:UIImagePickerControllerEditedImage]!=nil)
//        {
//            //获取用户编辑之后的图像
//            editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
//        }
//        else
//        {
//            //获取原始的图像
//            editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//        }
        //获取原始的图像
        editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        //判断是调用照相机还是图片库，如果是照相机的话，将图像保存到媒体库中
        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera)
        {
            //将该图像保存到媒体库中
            UIImageWriteToSavedPhotosAlbum(editedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            
        }
        
        UIImage *image = editedImage;
        if (!_isOriginal) {
              image =  [self imageWithImageSimple:editedImage scaledToSize:CGSizeMake(1000, 1000)];
        }else
      
        if (_selectType == isMore) {
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:image];
            _arrayBlock(arr);
        }else
        {
            _dismissBlock(image);
        }
      
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


//压缩图片
- (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    NSString *str=nil;
    if (!error)
        str=@"picture saved with no error.";
    else
        str=@"error occured while saving the picture%@";
    
    _errorBlock(str);
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [arr addObject:tempImg];
    }
    _arrayBlock(arr);
}
@end
