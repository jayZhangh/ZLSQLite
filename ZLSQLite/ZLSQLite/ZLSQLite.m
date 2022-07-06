//
//  ZLSQLite.m
//  ZLSQLite
//
//  Created by ZhangLiang on 2022/7/6.
//  Copyright © 2022 jayZhang. All rights reserved.
//

#import "ZLSQLite.h"

#define SQLiteDBName @"2022_07_06_sqlite.db"
#define SQLiteDBFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:SQLiteDBName]

static sqlite3 *_sqlite_db;

@interface ZLSQLite ()

@end

@implementation ZLSQLite

+ (ZLSQLite *)shared {
    static ZLSQLite *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
        
        NSString *fileName = SQLiteDBFile;
        int result = sqlite3_open([fileName UTF8String], &_sqlite_db);
        if (result == SQLITE_OK) {
            NSLog(@"ZLSQLite数据库创建成功");
            
        } else {
            NSLog(@"ZLSQLite数据库创建失败");
        }
    });
    
    return _manager;
}

//- (BOOL)removeDBFile {
//    BOOL flag = NO;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:SQLiteDBFile]) {
//        sqlite3_close(_sqlite_db);
//        flag = [fileManager removeItemAtPath:SQLiteDBFile error:nil];
//        NSLog(@"%@",(flag ? @"ZLSQLite删除文件成功" : @"ZLSQLite删除文件失败"));
//    }
//
//    return flag;
//}

- (BOOL)execute:(NSString *)sql {
    char *error = NULL;
    // 执行创建表的语句
    int result = sqlite3_exec(_sqlite_db, [sql UTF8String], nil, nil, &error);
    if (result == SQLITE_OK) {
        NSLog(@"ZLSQLite执行SQL语句成功!");
        return YES;
    } else {
        NSLog(@"ZLSQLite执行SQL语句失败!");
        return NO;
    }
}

- (sqlite3_stmt *)select:(NSString *)sql {
    sqlite3_stmt *stmt = NULL;
    int result = sqlite3_prepare_v2(_sqlite_db, [sql UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"ZLSQLite查询成功!");
        return stmt;
    } else {
        NSLog(@"ZLSQLite查询失败!");
        return nil;
    }
}

@end
