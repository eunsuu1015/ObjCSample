//
//  UserInfoSQLMgr.m
//  SQLiteSample
//
//  Created by EunSu on 2022/06/15.
//

#import "UserInfoSQLMgr.h"
#import "SQLiteMgr.h"

const NSString *DB_NAME = @"UserDB.db";
const NSString *TABLE_NAME = @"user";
const NSString *INDEX = @"_INDEX";
const NSString *USER_NAME = @"USER_NAME";
const NSString *USER_AGE = @"USER_AGE";

@interface UserInfoSQLMgr() {
    SQLiteMgr *sqliteMgr;
}

@end

@implementation UserInfoSQLMgr

-(instancetype)initWithCipherKey:(NSString*)cipherKey {
    if (self = [super init]) {
        sqliteMgr = [[SQLiteMgr alloc] init:DB_NAME];
        [sqliteMgr useCipher:YES cipherKey:cipherKey];
        [self createTable];
    }
    return self;
}

#pragma mark - Table

/// DB 파일 생성
-(BOOL)createTable {
    NSString *strCreate = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY AUTOINCREMENT, %@ VARCHAR(64),%@ INTEGER)", TABLE_NAME, INDEX, USER_NAME, USER_AGE];
    return [sqliteMgr createTable:strCreate];
}

-(BOOL)dropTable {
    NSString *querySQL = [NSString stringWithFormat:@"DROP TABLE %@", TABLE_NAME];
    return [sqliteMgr dropTable:querySQL];
}

#pragma mark - Insert

/// 사용자 이름 insert
-(BOOL)insertUserName:(NSString*)userName {
    NSString *querySQL = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES ('%@')", TABLE_NAME, USER_NAME, userName];
    return [sqliteMgr insert:querySQL];
}

/// 사용자 나이 insert
-(BOOL)insertUserAge:(int)userAge {
    NSString *querySQL = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%d)", TABLE_NAME, USER_AGE, userAge];
    return [sqliteMgr insert:querySQL];
}

/// 사용자 이름, 나이 insert
-(BOOL)insertUserName:(NSString*)userName userAge:(int)userAge {
    NSString *querySQL = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@) VALUES ('%@', %d)", TABLE_NAME, USER_NAME, USER_AGE, userName, userAge];
    return [sqliteMgr insert:querySQL];
}

#pragma mark - Update

// index에 있는 사용자 이름 update
-(BOOL)updateUserName:(NSString*)userName index:(int)index {
    NSString *querySQL = [NSString stringWithFormat:@"UPDATE %@ SET %@='%@' WHERE %@=%d", TABLE_NAME, USER_NAME, userName, INDEX, index];
    return [sqliteMgr update:querySQL];
}

/// index에 있는 사용자 나이 update
-(BOOL)updateUserAge:(int)userAge index:(int)index {
    NSString *querySQL = [NSString stringWithFormat:@"UPDATE %@ SET %@=%d WHERE %@=%d", TABLE_NAME, USER_AGE, userAge, INDEX, index];
    return [sqliteMgr update:querySQL];
}

// index에 있는 사용자 이름, 나이 update
-(BOOL)updateUserName:(NSString*)userName userAge:(int)userAge index:(int)index {
    NSString *querySQL = [NSString stringWithFormat:@"UPDATE %@ SET %@='%@', %@=%d WHERE %@=%d", TABLE_NAME, USER_NAME, userName, USER_AGE, userAge, INDEX, index];
    return [sqliteMgr update:querySQL];
}

#pragma mark - Select

- (User *)select:(int)index {
    NSString *querySQL = [NSString stringWithFormat:@"SELECT %@, %@, %@ FROM %@ WHERE %@=%d", INDEX, USER_NAME, USER_AGE, TABLE_NAME, INDEX, index];
    return [sqliteMgr select:querySQL index:index];
}

- (NSMutableArray<User *> *)selectAll {
    NSString *querySQL = [NSString stringWithFormat:@"SELECT %@, %@, %@ FROM %@", INDEX, USER_NAME, USER_AGE, TABLE_NAME];
    return [sqliteMgr selectAll:querySQL];
}

- (void)printAllDbData {
    NSString *querySQL = [NSString stringWithFormat:@"SELECT %@, %@, %@ FROM %@ ORDER BY %@ ASC", INDEX, USER_NAME, USER_AGE, TABLE_NAME, INDEX];
    [sqliteMgr printAll:querySQL];
}

#pragma mark - Delete

-(void)deleteAt:(int)index {
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=%d", TABLE_NAME, INDEX, index];
    [sqliteMgr deleteSQL:query];
}

-(void)deleteAll {
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@", TABLE_NAME];
    [sqliteMgr deleteSQL:query];
}

@end
