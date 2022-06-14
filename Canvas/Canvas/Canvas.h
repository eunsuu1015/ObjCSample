//
//  Canvas.h
//  Canvas
//
//  Created by EunSu on 2022/06/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Canvas : UIView

@property (nonatomic) float strokeWidth;        // 펜 두께
@property (nonatomic) UIColor *strokeColor;     // 펜 색상

- (id)initWithFrame:(CGRect)frame strokeWidth:(float)width strokeColor:(UIColor*)color;

/// 마지막 라인 삭제
- (void)undo;
/// 전체 라인 삭제
- (void)clear;

@end

NS_ASSUME_NONNULL_END
