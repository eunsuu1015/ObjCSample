//
//  ImagePickerHelper.h
//
//  Created by EunSu on 2022/06/09.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImagePickerHelper : NSObject<UIImagePickerControllerDelegate>

+(ImagePickerHelper*)shared;
-(void)getGallery:(UIViewController*)viewcontroller
                    pickImageHandler:(void (^)(UIImage*))pickImageHandler
                    cancelHandler:(void (^)(void))cancelHandler;
-(void)getCamera:(UIViewController*)viewcontroller
                    pickImageHandler:(void (^)(UIImage*))pickImageHandler
                    cancelHandler:(void (^)(void))cancelHandler;

@end

NS_ASSUME_NONNULL_END
