//
//  ViewController.m
//  Canvas
//
//  Created by EunSu on 2022/06/14.
//

#import "ViewController.h"
#import "Canvas.h"

@interface ViewController () {
    Canvas *canvas;
}

@property (weak, nonatomic) IBOutlet UIView *viewDraw;
@property (weak, nonatomic) IBOutlet UISlider *widthSlider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [self initCanvas];
}

/// canvas 초기화
- (void)initCanvas {
    // 기본 설정으로 초기화
    canvas = [[Canvas alloc] initWithFrame:self.viewDraw.frame];
    // 펜(라인) 굵기, 색상 설정하며 초기화
//    canvas = [[Canvas alloc] initWithFrame:self.viewDraw.frame strokeWidth:1 strokeColor:[UIColor redColor]];
    canvas.backgroundColor = self.viewDraw.backgroundColor;
    [self.view addSubview:canvas];
}

#pragma mark - Button Event

/// 되돌리기
- (IBAction)undo:(id)sender {
    [canvas undo];
}

/// 전체삭제
- (IBAction)clear:(id)sender {
    [canvas clear];
}

// 펜(라인) 굵기 변경
- (IBAction)widthChanged:(UISlider *)sender {
    canvas.strokeWidth = sender.value;
}

/// 펜(라인) 색상 변경
- (IBAction)colorChaged:(UIButton *)sender {
    NSLog(@"backgroundColor change");
    canvas.strokeColor = sender.backgroundColor;
}

@end
