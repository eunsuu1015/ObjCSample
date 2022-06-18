//
//  SQLiteMgr.h
//  SQLiteSample
//
//  Created by EunSu on 2022/06/15.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface SQLiteMgr : NSObject


/// 초기화
- (instancetype)init:(NSString *)dbName;

#pragma mark - DB

- (void)createDB;
- (BOOL)existDB;

#pragma mark - Table

- (BOOL)createTable:(NSString *)querySQL;
- (BOOL)dropTable:(NSString *)querySQL;

#pragma mark - CRUD

- (BOOL)insert:(NSString *)querySQL;
- (BOOL)update:(NSString *)querySQL;
- (User *)select:(NSString *)querySQL index:(int)index;
- (NSMutableArray<User *> *)selectAll:(NSString *)querySQL;
- (BOOL)deleteSQL:(NSString *)querySQL;
- (BOOL)isExist:(NSString *)querySQL;

#pragma mark - Cipher

- (void)useCipher:(BOOL)useCipher cipherKey:(NSString *)key;

#pragma mark - Etc

- (NSString *)getPrintErrMsg;
- (void)printAll:(NSString *)querySQL;

@end

NS_ASSUME_NONNULL_END
