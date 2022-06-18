//
//  ViewController.m
//  SQLiteSample
//
//  Created by EunSu on 2022/06/15.
//

#import "ViewController.h"
#import "UserInfoSQLMgr.h"

@interface ViewController () {
    UserInfoSQLMgr *sqlMgr;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sqlMgr = [[UserInfoSQLMgr alloc] initWithCipherKey:@"password"];
    [sqlMgr printAllDbData];
}

- (IBAction)insert:(id)sender {
    [sqlMgr insertUserName:_tfName.text userAge:[_tfAge.text intValue]];
}

- (IBAction)update:(id)sender {
    [sqlMgr updateUserName:[_tfName text] userAge:[_tfAge.text intValue] index:[_tfIndex.text intValue]];
}

- (IBAction)selectByIndex:(id)sender {
    User *user = [sqlMgr select:[_tfIndex.text intValue]];
    if (user != nil) {
        _tv.text = [NSString stringWithFormat:@"index : %d / name : %@ / age : %d", user.index, user.name, user.age];
    } else {
        _tv.text = @"데이터 없음";
    }
}

- (IBAction)selectAll:(id)sender {
    [sqlMgr printAllDbData];
    NSMutableArray<User *> *userArr = [sqlMgr selectAll];
    _tv.text = @"";
    if (userArr.count == 0) {
        _tv.text = @"데이터 없음";
        return;
    }
    for (int i = 0; i < userArr.count; i++) {
        User *user = userArr[i];
        _tv.text = [_tv.text stringByAppendingFormat:@"index : %d / name : %@ / age : %d\n", user.index, user.name, user.age];
    }
}

- (IBAction)deleteByIndex:(id)sender {
    [sqlMgr deleteAt:[_tfIndex.text intValue]];
}

- (IBAction)deleteAll:(id)sender {
    [sqlMgr deleteAll];
}

@end
