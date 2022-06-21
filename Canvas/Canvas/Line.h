//
//  Line.h
//  Canvas
//
//  Created by EunSu on 2022/06/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Line : NSObject

@property (nonatomic) float width;              // 라인 굵기
@property (nonatomic, strong) UIColor *color;   // 라인 색상
@property (nonatomic) NSMutableArray *points;   // 라인 좌표들

@end

NS_ASSUME_NONNULL_END
