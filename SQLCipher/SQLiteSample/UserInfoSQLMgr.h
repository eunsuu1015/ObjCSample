//
//  UserInfoSQLMgr.h
//  SQLiteSample
//
//  Created by EunSu on 2022/06/15.
//

#import <Foundation/Foundation.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoSQLMgr : NSObject

-(instancetype)initWithCipherKey:(NSString*)cipherKey;

#pragma mark - Table

-(BOOL)dropTable;

#pragma mark - Insert

/// 사용자 이름 insert
-(BOOL)insertUserName:(NSString*)userName;
/// 사용자 나이 insert
-(BOOL)insertUserAge:(int)userAge;
/// 사용자 이름, 나이 insert
-(BOOL)insertUserName:(NSString*)userName userAge:(int)userAge;

#pragma mark - Update

// index에 있는 사용자 이름 update
-(BOOL)updateUserName:(NSString*)userName index:(int)index;
/// index에 있는 사용자 나이 update
-(BOOL)updateUserAge:(int)userAge index:(int)index;
// index에 있는 사용자 이름, 나이 update
-(BOOL)updateUserName:(NSString*)userName userAge:(int)userAge index:(int)index;

#pragma mark - Select

- (NSMutableArray *)select:(int)index;
- (NSMutableArray<User *> *)selectAll;
- (void)printAllDbData;

#pragma mark - Delete

-(void)deleteAt:(int)index;
-(void)deleteAll;

@end

NS_ASSUME_NONNULL_END
