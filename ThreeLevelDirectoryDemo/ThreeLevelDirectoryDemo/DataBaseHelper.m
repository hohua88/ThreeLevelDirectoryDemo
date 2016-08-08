//
//  DataBaseHelper.m
//  KCBuinessKey
//
//  Created by kuang-chi on 16/1/27.
//  Copyright © 2016年 luhua. All rights reserved.
//

#import "DataBaseHelper.h"
#import "KCChatUser.h"
#import "DeptEnity.h"
#define KDataBaseName @"db.sqlite"

@implementation DataBaseHelper

+(instancetype)shareDataBaseHelper{
    static DataBaseHelper *dataBaseHelper  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataBaseHelper = [[DataBaseHelper alloc] init];
    });
    return dataBaseHelper;
}
- (id)init{
    DataBaseHelper *helper;
    if ((helper = [super init])) {
        [helper openDB:KDataBaseName];
    }
    return helper;
}
- (void)openDB:(NSString *)dbName{
    NSString *directory=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"%@",directory);
    NSString *filePath=[directory stringByAppendingPathComponent:dbName];
    NSLog(@"filePath : %@",filePath);
    //如果有数据库则直接打开，否则创建并打开（注意filePath是ObjC中的字符串，需要转化为C语言字符串类型）
    myDB = [FMDatabase databaseWithPath:filePath];
    database = [FMDatabaseQueue databaseQueueWithPath:filePath];
    
    if ([myDB open]) {
        NSLog(@"数据库打开成功");
    }
    else{
        NSLog(@"数据库打开失败");
    }
}

-(void)executeNonQuery:(NSString *)sql{
    [database inDatabase:^(FMDatabase *db) {
        BOOL flag= [db executeUpdate:sql];
        NSLog(@"flag : %d",flag);
    }];
//    if (![myDB executeUpdate:sql]) {
//        NSLog(@"executeNonQuery : error %@",sql);
//    }
}

- (NSArray *)executeQuery:(NSString *)sql table:(NSInteger)tableType{
    __block NSMutableArray *array = [NSMutableArray array];
    [database inDatabase:^(FMDatabase *db) {
        FMResultSet *setData = [db executeQuery:sql];
        
        while ([setData next]) {
            if (tableType == 1) {
                KCChatUser *user = [[KCChatUser alloc] init];
                NSString *userName = [setData stringForColumn:@"realname"];
                user.realName = userName;
                user.imageUrl = [ NSURL URLWithString:[setData stringForColumn:@"userPic"]];
                user.userPhone = [setData stringForColumn:@"userPhone"];
                user.easemobName = [setData stringForColumn:@"easemobName"];
                user.userId = [setData intForColumn:@"userid"];
                [array addObject:user];
            }
            else if(tableType == 2){
                DeptEnity *dept = [[DeptEnity alloc] init];
                dept.deptName = [setData stringForColumn:@"deptname"];
                dept.deptID = [setData intForColumn:@"deptid"];
                dept.parentID = [setData intForColumn:@"parentid"];
                dept.companyID = [setData intForColumn:@"companyid"];
                [array addObject:dept];
            }
            else if (tableType == 3)
            {
                KCChatUser *user = [[KCChatUser alloc] init];
                NSString *userName = [setData stringForColumn:@"realname"];
                user.realName = userName;
                user.imageUrl = [ NSURL URLWithString:[setData stringForColumn:@"userPic"]];
                user.userPhone = [setData stringForColumn:@"userPhone"];
                user.easemobName = [setData stringForColumn:@"easemobName"];
                user.userId = [setData intForColumn:@"userid"];
                user.deptID = [setData intForColumn:@"deptid"];
                [array addObject:user];
            }
        }
        [setData close];
    }];
    return array;
}

@end
