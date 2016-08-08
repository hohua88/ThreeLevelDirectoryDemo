//
//  KCDataBaseOperation.m
//  KCBuinessKey
//
//  Created by kuang-chi on 16/1/27.
//  Copyright © 2016年 luhua. All rights reserved.
//

#import "KCDataBaseOperation.h"
#import "DataBaseHelper.h"
@implementation KCDataBaseOperation


+ (void)initDataBase{
    NSString *key=@"IsCreatedDb";
    NSUserDefaults *defaults=[[NSUserDefaults alloc]init];
    if ([[defaults valueForKey:key] intValue]!=1) {
        [self createUserTable];
        [self createUserAvatarTable];
        //更改通讯录
        [self createStaffTable];
        [self createDepartmentTable];
        //[self createTopContactsTable];
        [defaults setValue:@1 forKey:key];
    }
}
+ (void)dropDataBase{
    NSString *key=@"IsCreatedDb";
    NSUserDefaults *defaults=[[NSUserDefaults alloc]init];
    if ([[defaults valueForKey:key] intValue]==1) {
        [self dropUserTable];
        [self dropUserAvatarTable];
        //删除常用联系人表
        [self dropDepartmentTable];
        [self dropStaffTable];
        [defaults setValue:@0 forKey:key];
    }
}
+ (void)dropUserTable{
    NSString *sql=@"DROP TABLE ContactList";
    [[DataBaseHelper shareDataBaseHelper] executeNonQuery:sql];
}

+ (void)dropUserAvatarTable{
    NSString *sql=@"DROP TABLE UserAvatar";
    [[DataBaseHelper shareDataBaseHelper] executeNonQuery:sql];
}

+(void)createUserTable{
    NSString *sql=@"CREATE TABLE ContactList (realname text, userPhone text, userPic text, easemobName text, userid integer)";
    [[DataBaseHelper shareDataBaseHelper] executeNonQuery:sql];
}
+(void)createUserAvatarTable{
    
    NSString *sql=@"CREATE TABLE UserAvatar (realname text,  userPic text, easemobName text, userid integer,userPhone text)";
    [[DataBaseHelper shareDataBaseHelper] executeNonQuery:sql];
}

//新建常用联系人表
+ (void)createTopContactsTable{
    NSString *sql=@"CREATE TABLE TOPCONTACTSLIST (realname text,  userPic text, easemobName text, userid integer,userPhone text)";
    [[DataBaseHelper shareDataBaseHelper] executeNonQuery:sql];
}
//新建部门表
+ (void)createDepartmentTable{
    NSString *sql=@"CREATE TABLE DEPARTMENTLIST (deptname text, deptid integer , companyid integer ,parentid integer)";
    [[DataBaseHelper shareDataBaseHelper] executeNonQuery:sql];
}
//新建员工表
+ (void)createStaffTable{
    NSString *sql=@"CREATE TABLE STAFFLIST (realname text,  userPic text, easemobName text, userid integer,userPhone text,deptid integer)";
    [[DataBaseHelper shareDataBaseHelper] executeNonQuery:sql];
}

+ (void)dropTopContactsTable{
    NSString *sql=@"DROP TABLE TOPCONTACTSLIST";
    [[DataBaseHelper shareDataBaseHelper] executeNonQuery:sql];
}
+ (void)dropDepartmentTable{
    NSString *sql=@"DROP TABLE DEPARTMENTLIST";
    [[DataBaseHelper shareDataBaseHelper] executeNonQuery:sql];
}
+ (void)dropStaffTable{
    NSString *sql=@"DROP TABLE STAFFLIST";
    [[DataBaseHelper shareDataBaseHelper] executeNonQuery:sql];
}
@end
