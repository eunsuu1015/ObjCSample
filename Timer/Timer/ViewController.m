//
//  ViewController.m
//  Timer
//
//  Created by EunSu on 2022/03/03.
//

#import "ViewController.h"

@interface ViewController () {
    NSTimer *timerRepeat;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startTimer];
    [self startRepeatTimer];
}

#pragma mark - 시작

// 1회성 타이머 시작
-(void)startTimer {
    NSString *userInfo = @"Timer 1";
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerFire:) userInfo:userInfo repeats:NO];
}

// 반복 타이머 시작
-(void)startRepeatTimer {
    NSString *userInfo = @"Timer 2";
    timerRepeat = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireRepeat:) userInfo:userInfo repeats:YES];
}

#pragma mark - 실행

// 1회성 타이머 실행
-(void)timerFire:(NSTimer*)timer {
    NSLog(@"timerFire!");
    if ([timer userInfo] != nil) {
        NSLog(@"userInfo : %@", [timer userInfo]);  // Timer 1
    }
}

// 반복 타이머 실행
-(void)timerFireRepeat:(NSTimer*)timer {
    NSLog(@"timerFireRepeat!");
    if ([timer userInfo] != nil) {
        NSLog(@"userInfo : %@", [timer userInfo]);  // Timer 2
    }
}

#pragma mark - 종료

// 반복 타이머 종료
-(IBAction)stopRepeatTimer {
    // 타이머 종료
    if ([timerRepeat isValid]) {
        [timerRepeat invalidate];
    }
    timerRepeat = nil;
}

@end
