//
//  ViewController.m
//  ZLSQLite
//
//  Created by ZhangLiang on 2022/7/6.
//  Copyright © 2022 jayZhang. All rights reserved.
//

#import "ViewController.h"
#import "ZLSQLite.h"

@interface ViewController ()

- (IBAction)insertAction:(id)sender;
- (IBAction)selectAction:(id)sender;
- (IBAction)deleteAction:(id)sender;
- (IBAction)dropAction:(id)sender;
- (IBAction)createAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)insertAction:(id)sender {
    ZLSQLite *db = [ZLSQLite shared];
    [db execute:@"insert into tb_student(stu_name) values('zhangsan');"];
    [db execute:@"insert into tb_student(stu_name) values('lisi');"];
    [db execute:@"insert into tb_student(stu_name) values('wangwu');"];
    [db execute:@"insert into tb_student(stu_name) values('zhaoliu');"];
    [db execute:@"insert into tb_student(stu_name) values('zhouqi');"];
}

- (IBAction)selectAction:(id)sender {
    sqlite3_stmt *stmt = [[ZLSQLite shared] select:@"select * from tb_student;"];
    while(sqlite3_step(stmt) == SQLITE_ROW) {
        int stu_id = sqlite3_column_int(stmt, 0);
        NSString *stu_name = [NSString stringWithUTF8String:((const char *)sqlite3_column_text(stmt, 1))];
        NSLog(@"%d\t%@", stu_id, stu_name);
    }
    
    sqlite3_reset(stmt);
}

- (IBAction)deleteAction:(id)sender {
    [[ZLSQLite shared] execute:@"delete from tb_student;"];
}

- (IBAction)dropAction:(id)sender {
    [[ZLSQLite shared] execute:@"drop table tb_student;"];
}

- (IBAction)createAction:(id)sender {
    [[ZLSQLite shared] execute:@"create table if not exists tb_student(stu_id integer primary key autoincrement,stu_name text);"];
}

@end
