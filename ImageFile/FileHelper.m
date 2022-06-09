//
//  FileHelper.m
//
//  Created by EunSu on 2022/06/09.
//

#import "FileHelper.h"

static FileHelper *_helper;

@interface FileHelper() {
}

@end

@implementation FileHelper

+(FileHelper *)shared {
    if (!_helper){
        _helper = [[FileHelper alloc] init];
    }
    return _helper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

/// 이미지 파일 저장
/// @param image 이미지
/// @param name  파일명
-(BOOL)saveImageFile:(UIImage*)image name:(NSString*)name {
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData == nil) {
        NSLog(@"imageData == nil");
        return false;
    }
    
    NSError *error;
    NSURL *directory = [NSFileManager.defaultManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:false error:&error];
    
    if (error) {
        NSLog(@"error : %@", error);
        return false;
    } else if (directory == nil) {
        NSLog(@"directory == nil");
        return false;
    }
    
    name = [self addExtension:name];
    
    BOOL result = [imageData writeToURL:[directory URLByAppendingPathComponent:name] options:nil error:&error];
    if (result) {
        NSLog(@"이미지 저장 성공");
    } else {
        NSLog(@"이미지 저장 실패");
        return false;
    }
    
    return true;
}

/// 저장된 이미지 파일 가져오기
/// @param name 이미지 파일명
-(UIImage*)getSavedImage:(NSString*)name {
    NSError *error;
    NSURL *directory = [NSFileManager.defaultManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:false error:&error];
    if (error) {
        NSLog(@"error : %@", error);
        return nil;
    }
    
    name = [self addExtension:name];
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSURL fileURLWithPath:directory.absoluteString] URLByAppendingPathComponent:name].path];
    if (image == nil) {
        NSLog(@"image == nil");
        return false;
    }
    
    return image;
}

/// 저장된 모든 이미지 파일 가져오기
-(NSArray<FileImage*> *)getSavedImages:(BOOL)isHideExtension {
    NSError *error;
    NSURL *directory = [NSFileManager.defaultManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:false error:&error];
    if (error) {
        NSLog(@"error : %@", error);
        return nil;
    }
    
    NSMutableArray<FileImage *> * fileImages = [NSMutableArray new];
    
    NSArray<NSString *> * directoryContents = [NSFileManager.defaultManager contentsOfDirectoryAtPath:directory error:&error];
    for (int i = 0; i < directoryContents.count; i++) {
        NSLog(@"directorycontent : %@", directoryContents[i]);
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSURL fileURLWithPath:directory.absoluteString] URLByAppendingPathComponent:directoryContents[i]].path];
        
        FileImage *fileImage = [[FileImage alloc] init];
        if (isHideExtension) {
            NSString *name = [self removeExtension:directoryContents[i]];
            fileImage.name = name;
        } else {
            fileImage.name = directoryContents[i];
        }
        fileImage.image = image;
        [fileImages addObject:fileImage];
    }

    return fileImages;
}

#pragma mark - Extension (확장자)

/// 확장자 추가
-(NSString*)addExtension:(NSString*)name {
    if (![self isExistExtension:name]) {
        name = [NSString stringWithFormat:@"%@.jpg", name];
    }
    return name;
}

/// 확장자 삭제
-(NSString*)removeExtension:(NSString*)name {
    if ([self isExistExtension:name]) {
        NSArray *arr = [name componentsSeparatedByString:@"."];
        name = arr[0];
    }
    return name;
}

/// 확장자 있는지 유무
-(BOOL)isExistExtension:(NSString*)name {
    return [name containsString:@"."];
}

@end
