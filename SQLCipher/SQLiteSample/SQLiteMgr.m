//
//  SQLiteMgr.m
//  SQLiteSample
//
//  Created by EunSu on 2022/06/15.
//

#import "SQLiteMgr.h"

#define USER_CIPHER 1

@interface SQLiteMgr()

@property (strong, nonatomic) NSString *dbPath;     // DB 경로
@property (strong, nonatomic) NSString *dbName;     // DB 이름
@property (nonatomic, strong) NSString *tableName;  // TABLE 이름
@property (nonatomic) sqlite3 *sql;
@property (nonatomic) BOOL useCipher;   // sqlite cipher 사용 여부
@property (nonatomic, strong) NSString *cipherKey;   // cipher 사용하는 경우 사용할 비밀번호

@end

@implementation SQLiteMgr


/// 초기화
- (instancetype)init:(NSString *)dbName {
    if (self = [super init]) {
        _dbName = dbName;
        [self createDB];
    }
    return self;
}

#pragma mark - DB

// DB 파일 생성 - 초기화 시 자동으로 진행
- (void)createDB {
    // 디비 파일 경로 설정
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPaths[0];
    
    _dbPath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:_dbName]];
}

/// DB 파일 존재 여부 확인
- (BOOL)existDB {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath: _dbPath]) {
        return YES;
    } else {
        return NO;
    }
}

/// DB 오픈
/// 파일이 있다면 파일을 연다.
/// 파일이 없다면 파일 생성 후 파일을 연다.
- (BOOL)openDB {
    const char *dbpath = [_dbPath UTF8String];
    if (sqlite3_open(dbpath, &_sql) == SQLITE_OK) {
        return YES;
    } else {
        [self getPrintErrMsg];
        return NO;
    }
}

/// DB 닫기
- (BOOL)closeDB {
    if (sqlite3_close(_sql) == SQLITE_OK) {
        return YES;
    } else {
        [self getPrintErrMsg];
        return NO;
    }
}

#pragma mark - Table

/// 테이블 생성
- (BOOL)createTable:(NSString *)querySQL {
    return [self execSQL:querySQL checkExistDB:NO checkOpenDB:YES];
}

/// 테이블 삭제
- (BOOL)dropTable:(NSString *)querySQL {
    return [self execSQLAllCheck:querySQL];
}

#pragma mark - CRUD

/// db insert
- (BOOL)insert:(NSString *)querySQL {
    return [self execSQLAllCheck:querySQL];
}

/// db update
- (BOOL)update:(NSString *)querySQL {
    return [self execSQLAllCheck:querySQL];
}

/// index로 조회
/// TODO: 용도에 맞게 리턴 타입 및 조회하는 부분 변경 필요
- (User *)select:(NSString *)querySQL index:(int)index {
    if (![self existDB] || ![self openDB]) {
        return nil;
    }
    
    User *user = nil;
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_stmt *stmt;
    
    [self setCipherKey];
    
    if (sqlite3_prepare_v2(_sql, query_stmt, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int index = sqlite3_column_int(stmt, 0);
            const char *strVal = sqlite3_column_text(stmt, 1);
            int intVal = sqlite3_column_int(stmt, 2);
            user = [[User alloc] init];
            user.index = index;
            user.name = [NSString stringWithUTF8String:strVal];
            user.age = intVal;
        }
        sqlite3_finalize(stmt);
    } else {
        [self getPrintErrMsg];
    }
    [self closeDB];
    return user;
}

/// 모든 데이터 조회
// TODO: 용도에 맞게 리턴 타입 및 조회하는 부분 변경 필요
- (NSMutableArray<User *> *)selectAll:(NSString *)querySQL {
    NSMutableArray *arr = [NSMutableArray new];
    if (![self existDB]) {
        return arr;
    }
    
    if (![self openDB]) {
        return arr;
    }
    
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_stmt *stmt;
    
    [self setCipherKey];
    
    if (sqlite3_prepare_v2(_sql, query_stmt, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int index = (int)sqlite3_column_int(stmt, 0);
            const char *strVal = (const char *)sqlite3_column_text(stmt, 1);
            int intVal = (int)sqlite3_column_int(stmt, 2);
            
            User *user = [[User alloc] init];
            user.index = index;
            user.name = [NSString stringWithUTF8String:strVal];
            user.age = intVal;
            [arr addObject:user];
        }
        sqlite3_finalize(stmt);
        
    } else {
        [self getPrintErrMsg];
    }
    [self closeDB];
    return arr;
}

/// 저장된 데이터 있는지 조회
- (BOOL)isExist:(NSString *)querySQL {
    if (![self openDB]) {
        return NO;
    }
    
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_stmt *stmt;
    
    [self setCipherKey];
    
    if (sqlite3_prepare_v2(_sql, query_stmt, -1, &stmt, NULL) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            // 가져온 값이 있음
            sqlite3_finalize(stmt);
            [self closeDB];
            return YES;
        } else {
            // 가져온 값이 없음
            [self getPrintErrMsg];
            sqlite3_finalize(stmt);
            [self closeDB];
        }
    } else {
        [self getPrintErrMsg];
    }
    return NO;
}

- (BOOL)deleteSQL:(NSString *)querySQL {
    return [self execSQLAllCheck:querySQL];
}

#pragma mark - Cipher

/// Cipher 사용 여부 설정 (사용 시 key 같이 설정)
/// @param useCipher Cipher 사용 여부
/// @param key useCipher 사용 시 사용할 키
- (void)useCipher:(BOOL)useCipher cipherKey:(NSString *)key {
    _useCipher = useCipher;
    _cipherKey = key;
}

/// sql에 Cipher Key 추가
- (void)setCipherKey {
    if (_useCipher) {
#if USER_CIPHER
        const char* key = [_cipherKey UTF8String];
        sqlite3_key(_sql, key, (int)strlen(key));
#endif
    }
}

#pragma mark - Etc

/// 가장 최근에 발생한 에러 메시지 출력
- (NSString *)getPrintErrMsg {
    NSLog(@"errMsg : %s", sqlite3_errmsg(_sql));
    return [NSString stringWithUTF8String:sqlite3_errmsg(_sql)];
}

/// 모든 데이터 출력
- (void)printAll:(NSString *)querySQL {
    if (![self existDB]) {
        return;
    }
    
    // 디비 파일 오픈 실패
    if (![self openDB]) {
        return;
    }
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_stmt *stmt;
    char *errMsg;
    
    [self setCipherKey];
    
    if (sqlite3_prepare_v2(_sql, query_stmt, -1, &stmt, &errMsg) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            // TODO: 실제 값에 맞춰 변경 필요
            int index = sqlite3_column_int(stmt, 0);
            const char *strVal = sqlite3_column_text(stmt, 1);
            int intVal = sqlite3_column_int(stmt, 2);
            NSLog(@"index : %d / strVal : %s / intVal : %d", index, strVal, intVal);
        }
        sqlite3_finalize(stmt);
    } else {
        NSLog(@"조회 실패 : %@",[NSString stringWithUTF8String:errMsg]);
        [self getPrintErrMsg];
    }
    [self closeDB];
}

#pragma mark - exec

- (BOOL)execSQLAllCheck:(NSString *)querySQL {
    return [self execSQL:querySQL checkExistDB:YES checkOpenDB:YES];
}

- (BOOL)execSQL:(NSString *)querySQL checkExistDB:(BOOL)checkExistDB checkOpenDB:(BOOL)checkOpenDB {
    if (checkExistDB && ![self existDB]) {
        NSLog(@"DB 파일 없음");
        return NO;
    }
    
    if (checkOpenDB && ![self openDB]) {
        NSLog(@"DB 오픈 실패");
        return NO;
    }
    
    [self setCipherKey];
    
    const char *query_stmt = [querySQL UTF8String];
    char *errMsg;
    
    if (sqlite3_exec(_sql, query_stmt, NULL, NULL, &errMsg) == SQLITE_OK) {
        [self closeDB];
    } else {
        [self getPrintErrMsg];
        NSLog(@"error : %s", errMsg);
        [self closeDB];
        return NO;
    }
    return YES;
}

@end
