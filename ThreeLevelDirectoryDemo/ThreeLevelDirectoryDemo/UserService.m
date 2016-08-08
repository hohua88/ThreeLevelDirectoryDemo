//
//  UserService.m
//  KCBuinessKey
//
//  Created by kuang-chi on 16/1/27.
//  Copyright © 2016年 luhua. All rights reserved.
//

#import "UserService.h"

@implementation UserService

+ (instancetype)shareUserService{
    static UserService *userService  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userService = [[UserService alloc] init];
    });
    return userService;
}

- (void)addUserAvatar:(KCChatUser *)user{
    
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO ContactList (realname, userPic,easemobName,userid,userPhone) VALUES ('%@','%@','%@','%lu','%@')",user.realName,user.imageUrl,user.easemobName,(unsigned long)user.userId, user.userPhone];
    [[DataBaseHelper shareDataBaseHelper] executeNonQuery:sql];
}

- (void)deleteUserAvatar:(NSString *)user{
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM ContactList WHERE easemobName = '%@'",user];
    [[DataBaseHelper shareDataBaseHelper] executeNonQuery:sql];
}
- (void)modifyUserAvatar:(KCChatUser *)user{
    NSString *sql=[NSString stringWithFormat:@"UPDATE ContactList  SET realname = '%@',userPhone = '%@',easemobName = '%@',userPic = '%@' WHERE userid = '%ld'",user.realName,user.userPhone,user.easemobName,user.imageUrl,user.userId];
    [[DataBaseHelper shareDataBaseHelper] executeNonQuery:sql];
}
- (KCChatUser *)getUserAvatarByEaseMobName:(NSString *)name{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM ContactList WHERE easemobName='%@'", name];
    NSArray *array = [[DataBaseHelper shareDataBaseHelper] executeQuery:sql table:1];
    if(array && array.count > 0) {
        return (KCChatUser *)array[0];
    }
    return nil;
}

- (KCChatUser *)getUserByUserID:(NSInteger )userid{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM ContactList WHERE userid='%ld'", userid];
    NSArray *array = [[DataBaseHelper shareDataBaseHelper] executeQuery:sql table:1];
    if(array && array.count > 0) {
        return (KCChatUser *)array[0];
    }
    return nil;
}
- (NSArray *)getAllUsers{
    NSMutableArray *array=[NSMutableArray array];
    NSString *sql=@"SELECT * FROM ContactList";
    NSArray *rows= [[DataBaseHelper shareDataBaseHelper] executeQuery:sql table:1];
    for (KCChatUser *user in rows) {
        [array addObject:user];
    }
    return array;
}
@end
