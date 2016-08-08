//
//  UserService.h
//  KCBuinessKey
//
//  Created by kuang-chi on 16/1/27.
//  Copyright © 2016年 luhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCChatUser.h"
#import "DataBaseHelper.h"
@interface UserService : NSObject

+ (instancetype)shareUserService;
//添加好友
- (void)addUserAvatar:(KCChatUser *)user;
//删除好友
- (void)deleteUserAvatar:(NSString *)user;
//根据好友名称查找用户
- (KCChatUser *)getUserAvatarByEaseMobName:(NSString *)name;

- (KCChatUser *)getUserByUserID:(NSInteger )userid;

- (void)modifyUserAvatar:(KCChatUser *)user;

- (NSArray *)getAllUsers;

@end
