//
//  Canvas.m
//  Canvas
//
//  Created by EunSu on 2022/06/14.
//  참고 https://www.youtube.com/watch?v=E2NTCmEsdSE&t=1s

#import "Canvas.h"
#import "Line.h"

@interface Canvas() {
    NSMutableArray<Line *> *lines;  // 2차원 배열 - 그려진 모든 라인
    Line *line; // 현재 그리고 있는 라인
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

/// 설정 값 없을 때 기본 설정 세팅
-(void)initSetting {
    // 배경 색상 흰색 설정
    self.backgroundColor = [UIColor whiteColor];
    // 펜(라인) 굵기 1 설정
    self.strokeWidth = 1;
    // 펜(라인) 색상 검정 설정
    self.strokeColor = [UIColor blackColor];
}

#pragma mark - Draw

/// 화면에 그리기
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 라인 수 만큼 그리기
    for (int i = 0; i < lines.count; i++) {
        Line *getLine = lines[i];
        NSMutableArray * getLinePoints = getLine.points;
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineCap(context, kCGLineCapButt);   // 라인 모양
        CGContextSetStrokeColorWithColor(context, getLine.color.CGColor);  // 라인 색상
        CGContextSetLineWidth(context, getLine.width); // 라인 굵기
                
        // 한 라인 포인트 그리기
        for (int j = 0; j < getLinePoints.count; j++) {
            NSValue *value = getLinePoints[j];
            CGPoint point = [value CGPointValue];
            if (j == 0) {
                CGContextMoveToPoint(context, point.x, point.y);
            } else {
                CGContextAddLineToPoint(context, point.x, point.y);
            }
        }
        CGContextStrokePath(context);
    }
}

#pragma mark - Touches

/// 그리기 시작
/// 그리기 시작 시 설정된 width와 color 추가
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    line = [[Line alloc] init];
    line.points = [NSMutableArray new];
    line.width = _strokeWidth;
    line.color = _strokeColor;
    [lines addObject:line];
}

/// 그리는 중
/// 그리는 중일 때 point 좌표 추가 및 화면 그리기
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:nil];
    [line.points addObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
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
