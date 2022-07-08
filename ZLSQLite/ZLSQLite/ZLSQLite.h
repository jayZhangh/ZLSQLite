//
//  ZLSQLite.h
//  ZLSQLite
//
//  Created by ZhangLiang on 2022/7/6.
//  Copyright © 2022 jayZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLSQLite : NSObject

/**
 单例对象
 */
+ (ZLSQLite *)sharedInstance;

/**
 删除数据库文件
 */
- (void)removeDBFile;

/**
 执行SQL语句
 @param sql 可执行的sql语句
 */
- (BOOL)execute:(NSString *)sql;

/**
 执行SQL查询语句
 @param sql 可执行的sql语句
 */
- (NSArray *)select:(NSString *)sql;

/**
 执行SQL语句
 @param sql 可执行的sql语句
 @param args 参数值数组
 */
- (void)execute:(NSString *)sql args:(NSArray * __nullable)args;

@end

NS_ASSUME_NONNULL_END
