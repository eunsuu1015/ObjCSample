//
//  Canvas.m
//  Canvas
//
//  Created by EunSu on 2022/06/14.
//  https://www.youtube.com/watch?v=E2NTCmEsdSE&t=1s

#import "Canvas.h"

// TODO: 라인 별로 색상 설정 가능하도록 수정
@interface Canvas() {
    NSMutableArray *lines;  // 2차원 배열 - 라인 전체
    NSMutableArray *line;
}

@end

@implementation Canvas

#pragma mark - Init

- (id)init {
    self = [self initWithFrame:CGRectZero];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        lines = [NSMutableArray new];
        [self initSetting];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame strokeWidth:(float)width strokeColor:(UIColor*)color {
    self = [self initWithFrame:frame];
    if (self) {
        self.strokeWidth = width;
        self.strokeColor = color;
    }
    return self;
}

-(void)initSetting {
    // 배경 색상 흰색 설정
    self.backgroundColor = [UIColor whiteColor];
    // 펜 두께 1 설정
    self.strokeWidth = 1;
    // 펜 색상 검정 설정
    self.strokeColor = [UIColor blackColor];
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // draw line
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, _strokeColor.CGColor);
    CGContextSetLineWidth(context, _strokeWidth);
    CGContextSetLineCap(context, kCGLineCapButt);
    
    for (int j = 0; j < lines.count; j++) {
        NSMutableArray *oneLine =  lines[j];
        
        for (int i = 0; i < oneLine.count; i++) {
            NSValue *value = oneLine[i];
            CGPoint point = [value CGPointValue];
            if (i == 0) {
                CGContextMoveToPoint(context, point.x, point.y);
            } else {
                CGContextAddLineToPoint(context, point.x, point.y);
            }
        }
    }
    
    CGContextStrokePath(context);
}

#pragma mark - Touches

/// 그리기 시작
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    line = [NSMutableArray new];
    [lines addObject:line];
}

/// 그리는중
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:nil];
    NSLog(@"point x, y : %f, %f", point.x, point.y);
    [line addObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
    [self setNeedsDisplay];
}

/// 그리기 종료
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [lines removeLastObject];
    [lines addObject:line];
    [self setNeedsDisplay];
}

#pragma mark - Remove

/// 마지막 라인 삭제
- (void)undo {
    [lines removeLastObject];
    [self setNeedsDisplay];
}

/// 전체 라인 삭제
- (void)clear {
    [lines removeAllObjects];
    [self setNeedsDisplay];
}

@end
