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

/**
 create table if not exists tb_student(stu_id integer primary key autoincrement,stu_name text);
 select * from tb_student;
 insert into tb_student(stu_name) values('zhangsan');
 update tb_student set stu_name='lisi' where stu_id=1;
 delete from tb_student where stu_id=1;
 */
@interface ZLSQLite : NSObject

/**
 单例对象
 @return ZLSQLite对象
 */
+ (ZLSQLite *)shared;

/**
 删除数据库文件
 @return 返回是否执行成功 YES/NO
 */
//- (BOOL)removeDBFile;

/**
 执行SQL语句
 @param sql 可执行的sql语句
 @return 返回是否执行成功 YES/NO
 */
- (BOOL)execute:(NSString *)sql;

/**
 执行SQL查询语句
 @param sql 可执行的sql语句
 @return 返回查询结果对象
 */
- (sqlite3_stmt *)select:(NSString *)sql;

@end

NS_ASSUME_NONNULL_END
