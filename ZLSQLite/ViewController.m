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

@property (weak, nonatomic) IBOutlet UIImageView *stuImv;

- (IBAction)insertAction:(id)sender;
- (IBAction)selectAction:(id)sender;
- (IBAction)deleteAction:(id)sender;
- (IBAction)dropAction:(id)sender;
- (IBAction)createAction:(id)sender;
- (IBAction)removeAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%s", @encode(int));
    NSLog(@"%s", @encode(float));
    NSLog(@"%s", @encode(double));
    NSLog(@"%s", @encode(NSInteger));
    NSLog(@"%s", @encode(CGFloat));
    NSLog(@"%d", strcmp([@(1.1) objCType], @encode(double)));
    NSLog(@"%d", strcmp([@(1) objCType], @encode(int)));
    NSLog(@"%d", strcmp([@(1.1f) objCType], @encode(float)));
}

- (IBAction)insertAction:(id)sender {
    ZLSQLite *db = [ZLSQLite sharedInstance];
    [db execute:@"insert into tb_student(stu_name,stu_age) values('zhangsan',13);"];
    [db execute:@"insert into tb_student(stu_name) values('lisi');"];
    [db execute:@"insert into tb_student(stu_name,stu_age,stu_score,stu_img) values(?,?,?,?);" args:@[@"王五", @(22), @(57.43), UIImagePNGRepresentation([UIImage imageNamed:@"baozi"])]];
    [db execute:@"insert into tb_student(stu_name) values(?);" args:@[@"zhaoliu"]];
    [db execute:@"insert into tb_student(stu_name,stu_age) values(?,?);" args:@[@"周七", @(12)]];
    [db execute:@"insert into tb_student(stu_name,stu_age) values('孙八',15);" args:nil];
}

- (IBAction)selectAction:(id)sender {
    NSArray *arr = [[ZLSQLite sharedInstance] select:@"select * from tb_student;"];
    for (NSDictionary *dic in arr) {
        NSInteger stu_id = [dic[@"stu_id"] integerValue];
        NSString *stu_name = dic[@"stu_name"];
        NSInteger stu_age = [dic[@"stu_age"] integerValue];
        double stu_score = [dic[@"stu_score"] doubleValue];
        NSData *stu_img = dic[@"stu_img"];
        NSLog(@"%ld - %@ - %ld - %f - %@", stu_id, stu_name, stu_age, stu_score, stu_img);
        if (stu_img != nil) {
            self.stuImv.image = [UIImage imageWithData:stu_img];
        }
    }
}

- (IBAction)deleteAction:(id)sender {
    [[ZLSQLite sharedInstance] execute:@"delete from tb_student;"];
}

- (IBAction)dropAction:(id)sender {
    [[ZLSQLite sharedInstance] execute:@"drop table tb_student;"];
}

- (IBAction)createAction:(id)sender {
    [[ZLSQLite sharedInstance] execute:@"create table if not exists tb_student(stu_id integer primary key autoincrement,stu_name text,stu_age integer,stu_score double,stu_img blob);"];
}

- (IBAction)removeAction:(id)sender {
    [[ZLSQLite sharedInstance] removeDBFile];
}

@end
