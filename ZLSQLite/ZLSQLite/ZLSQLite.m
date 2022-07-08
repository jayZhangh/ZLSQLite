//
//  ZLSQLite.m
//  ZLSQLite
//
//  Created by ZhangLiang on 2022/7/6.
//  Copyright © 2022 jayZhang. All rights reserved.
//

#import "ZLSQLite.h"

#define SQLiteDBName @"ZLSQLite_2022_01_01.db"
#define SQLiteDBFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:SQLiteDBName]

@interface ZLSQLite ()
{
    sqlite3 *_sqlite_db;
}

@end

@implementation ZLSQLite

+ (ZLSQLite *)sharedInstance {
    static ZLSQLite *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
        
    });
    
    return _manager;
}

- (void)removeDBFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:SQLiteDBFile]) {
        [fileManager removeItemAtPath:SQLiteDBFile error:nil];
    }
}

- (BOOL)execute:(NSString *)sql {
    sqlite3_open([SQLiteDBFile UTF8String], &_sqlite_db);
    char *error = NULL;
    // 执行创建表的语句
    int result = sqlite3_exec(_sqlite_db, [sql UTF8String], nil, nil, &error);
    if (result == SQLITE_OK) {
        sqlite3_close(_sqlite_db);
        return YES;
    }
    
    sqlite3_close(_sqlite_db);
    return NO;
}

- (NSArray *)select:(NSString *)sql {
    sqlite3_open([SQLiteDBFile UTF8String], &_sqlite_db);
    sqlite3_stmt *stmt = nil;
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    int result = sqlite3_prepare_v2(_sqlite_db, [sql UTF8String], -1, &stmt, nil);
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            // 动态获得字段的总数
            int sumCol = sqlite3_column_count(stmt);
            NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
            // 遍历所有字段取出对应的字段值存入可变字典
            for (int i = 0; i < sumCol; i++) {
                // 确定字段类型
                int type = sqlite3_column_type(stmt, i);
                // 得到字段名称
                const char *colName = sqlite3_column_name(stmt, i);
                // 取出字段的名称
                NSString *key = [NSString stringWithCString:colName encoding:NSUTF8StringEncoding];
                switch (type) {
                    case SQLITE_INTEGER: {
                        // 得到值
                        int value = sqlite3_column_int(stmt, i);
                        // 加入字典
                        [mDic setObject:@(value) forKey:key];
                    }
                        break;
                    case SQLITE_FLOAT: {
                        double value = sqlite3_column_double(stmt, i);
                        [mDic setObject:@(value) forKey:key];
                    }
                        break;
                    case SQLITE_TEXT: {
                        const unsigned char *str = sqlite3_column_text(stmt, i);
                        NSString *strValue = [NSString stringWithCString:(const char *)str encoding:NSUTF8StringEncoding];
                        [mDic setObject:strValue forKey:key];
                    }
                        break;
                    case SQLITE_BLOB: {
                        const void *bytes = sqlite3_column_blob(stmt, i);
                        int length = sqlite3_column_bytes(stmt, i);
                        NSData *dataValue = [NSData dataWithBytes:bytes length:length];
                        [mDic setObject:dataValue forKey:key];
                    }
                        break;
                    default:
                        break;
                }
            }
            // 添加到数组
            [mArr addObject:mDic];
        }
    }
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(_sqlite_db);
    
    return mArr;
}

- (void)execute:(NSString *)sql args:(NSArray * __nullable)args {
    sqlite3_open([SQLiteDBFile UTF8String], &_sqlite_db);
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(_sqlite_db, [sql UTF8String], -1, &stmt, nil);
    if (result == SQLITE_OK) {
        for (int i = 0; i < [args count]; i++) {
            NSObject *objc = args[i];
            if ([objc isKindOfClass:[NSNumber class]]) {
                NSNumber *number = (NSNumber *)objc;
                if (strcmp([number objCType], @encode(int)) == 0) {
                    sqlite3_bind_int(stmt, i + 1, number.intValue);
                } else if (strcmp([number objCType], @encode(float)) == 0) {
                    sqlite3_bind_double(stmt, i + 1, number.doubleValue);
                } else if (strcmp([number objCType], @encode(double)) == 0) {
                    sqlite3_bind_double(stmt, i + 1, number.doubleValue);
                }
            } else if ([objc isKindOfClass:[NSString class]]) {
                NSString *str = (NSString *)objc;
                sqlite3_bind_text(stmt, i + 1, [str UTF8String], -1, SQLITE_TRANSIENT);
            } else if ([objc isKindOfClass:[NSData class]]) {
                NSData *data = (NSData *)objc;
                sqlite3_bind_blob(stmt, i + 1, data.bytes, (int)[data length], SQLITE_TRANSIENT);
            }
        }
    }
    
    sqlite3_step(stmt);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(_sqlite_db);
}

@end
