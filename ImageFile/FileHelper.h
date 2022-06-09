//
//  FileHelper.h
//
//  Created by EunSu on 2022/06/09.
//

#import <Foundation/Foundation.h>
#import "FaceImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface FileImage : NSObject

@property (nonatomic) UIImage *image;   // 이미지
@property (nonatomic) NSString *name;   // 이미지 파일명

@end

@interface FileHelper : NSObject

+(FileHelper*)shared;

-(BOOL)saveImageFile:(UIImage*)image name:(NSString*)name;
-(UIImage*)getSavedImage:(NSString*)name;
-(NSArray<FileImage*> *)getSavedImages:(BOOL)isHideExtension;

@end

NS_ASSUME_NONNULL_END
