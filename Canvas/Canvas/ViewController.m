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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCanvas];
}

- (void)initCanvas {
//    canvas = [[Canvas alloc] init];
//    canvas.frame = self.viewDraw.frame;
//    canvas = [[Canvas alloc] initWithFrame:self.viewDraw.frame];
    canvas = [[Canvas alloc] initWithFrame:self.viewDraw.frame strokeWidth:5 strokeColor:[UIColor redColor]];
    [self.view addSubview:canvas];
}

- (IBAction)undo:(id)sender {
    [canvas undo];
}

- (IBAction)clear:(id)sender {
    [canvas clear];
}

@end
