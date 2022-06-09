//
//  ImagePickerHelper.m
//
//  Created by EunSu on 2022/06/09.
//

#import "ImagePickerHelper.h"

static ImagePickerHelper *_helper;

@interface ImagePickerHelper() {
    UIImagePickerController *picker;
    void (^pickImageHandler)(UIImage*); // 이미지 콜백
    void (^cancelHandler)(void);        // 취소 콜백
}

@end

@implementation ImagePickerHelper

+(ImagePickerHelper *)shared {
    if (!_helper){
        _helper = [[ImagePickerHelper alloc] init];
    }
    return _helper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
    }
    return self;
}

//앨범에서 가저오기
-(void)getGallery:(UIViewController*)viewcontroller pickImageHandler:(void (^)(UIImage*))pickImageHandler cancelHandler:(void (^)(void))cancelHandler {
    self->pickImageHandler = pickImageHandler;
    self->cancelHandler = cancelHandler;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [viewcontroller presentViewController:picker animated:true completion:nil];
}

//카메라에서 가저오기
-(void)getCamera:(UIViewController*)viewcontroller pickImageHandler:(void (^)(UIImage*))pickImageHandler cancelHandler:(void (^)(void))cancelHandler {
    self->pickImageHandler = pickImageHandler;
    self->cancelHandler = cancelHandler;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [viewcontroller presentViewController:picker animated:true completion:nil];
}


#pragma mark - imagePicker extenstion

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if (cancelHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->cancelHandler();
        });
    }

    [picker dismissViewControllerAnimated:true completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage *image =(UIImage*)info[UIImagePickerControllerOriginalImage];
    
    if (pickImageHandler){
        dispatch_async(dispatch_get_main_queue(), ^{
            self->pickImageHandler(image);
        });
    }
    
    [picker dismissViewControllerAnimated:true completion:nil];
}


#pragma mark - 사용 방법

/// OS 카메라 촬영 요청
-(void)openCamera {
    [ImagePickerHelper.shared getCamera:self pickImageHandler:^(UIImage * image) {
        // 촬영 성공
    } cancelHandler:^{
        // 촬영 취소
    }];
}

/// OS 갤러리 요청
-(void)openGallary {
    [ImagePickerHelper.shared getGallery:self pickImageHandler:^(UIImage * image) {
        // 갤러리 사진 선택 성공
    } cancelHandler:^{
        // 갤러리 사진 선택 실해
    }];
}

@end
