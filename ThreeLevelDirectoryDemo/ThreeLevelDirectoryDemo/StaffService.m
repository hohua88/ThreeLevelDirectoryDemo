//
//  StaffService.m
//  KCBuinessKey
//
//  Created by eddy on 16/6/7.
//  Copyright © 2016年 luhua. All rights reserved.
//

#import "StaffService.h"
#import "DataBaseHelper.h"
@implementation StaffService

+ (instancetype)shareStaffService{
    static StaffService *staffService  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staffService = [[StaffService alloc] init];
    });
    return staffService;
}

- (void)addStaff:(KCChatUser *)user{
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO STAFFLIST (realname, userPic,easemobName,userid,userPhone,deptid) VALUES ('%@','%@','%@','%lu','%@','%ld')",user.realName,user.imageUrl,user.easemobName,(unsigned long)user.userId, user.userPhone,user.deptID];
    [[DataBaseHelper shareDataBaseHelper] executeNonQuery:sql];
}

- (void)deleteStaff:(NSString *)easemobName{
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM STAFFLIST WHERE easemobName = '%@'",easemobName];
    [[DataBaseHelper shareDataBaseHelper] executeNonQuery:sql];
}

- (void)modifyStaff:(KCChatUser *)user{
    NSString *sql=[NSString stringWithFormat:@"UPDATE STAFFLIST  SET realname = '%@',userPhone = '%@',easemobName = '%@',userPic = '%@' WHERE userid = '%ld'",user.realName,user.userPhone,user.easemobName,user.imageUrl,user.userId];
    [[DataBaseHelper shareDataBaseHelper] executeNonQuery:sql];
}

- (KCChatUser *)getStaffByEaseMobName:(NSString *)name{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM STAFFLIST WHERE easemobName='%@'", name];
    NSArray *array = [[DataBaseHelper shareDataBaseHelper] executeQuery:sql table:3];
    if(array && array.count > 0) {
        return (KCChatUser *)array[0];
    }
    return nil;
}

- (KCChatUser *)getStaffByUserID:(NSInteger)userid{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM STAFFLIST WHERE userid='%ld'", userid];
    NSArray *array = [[DataBaseHelper shareDataBaseHelper] executeQuery:sql table:3];
    if(array && array.count > 0) {
        return (KCChatUser *)array[0];
    }
    return nil;
}
- (NSArray *)getStaffsByDeptID:(NSInteger)deptID{
    NSMutableArray *array=[NSMutableArray array];
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM STAFFLIST WHERE deptid='%ld'", deptID];
    NSArray *rows= [[DataBaseHelper shareDataBaseHelper] executeQuery:sql table:3];
    for (KCChatUser *user in rows) {
        [array addObject:user];
    }
    return array;
}
- (NSArray *)getAllStaffs{
    NSMutableArray *array=[NSMutableArray array];
    NSString *sql=@"SELECT * FROM STAFFLIST";
    NSArray *rows= [[DataBaseHelper shareDataBaseHelper] executeQuery:sql table:3];
    for (KCChatUser *user in rows) {
        [array addObject:user];
    }
    return array;
}
@end
