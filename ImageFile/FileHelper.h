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

/// 이미지 파일 저장
-(BOOL)saveImage:(UIImage*)image name:(NSString*)name;

/// 저장된 이미지 파일 가져오기
-(UIImage*)getSavedImage:(NSString*)name;

/// 저장된 모든 이미지 파일 가져오기
-(NSArray<FileImage*> *)getSavedImages:(BOOL)isHideExtension;

/// 이미지 파일 삭제
-(BOOL)removeImage:(NSString*)name;

@end

NS_ASSUME_NONNULL_END
