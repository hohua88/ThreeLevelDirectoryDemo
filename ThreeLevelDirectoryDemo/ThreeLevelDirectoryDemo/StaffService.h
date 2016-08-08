//
//  StaffService.h
//  KCBuinessKey
//
//  Created by eddy on 16/6/7.
//  Copyright © 2016年 luhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCChatUser.h"
@interface StaffService : NSObject

+ (instancetype)shareStaffService;

- (void)addStaff:(KCChatUser *)user;

- (void)deleteStaff:(NSString *)easemobName;

- (void)modifyStaff:(KCChatUser *)user;

- (KCChatUser *)getStaffByEaseMobName:(NSString *)name;

- (KCChatUser *)getStaffByUserID:(NSInteger)userid;

- (NSArray *)getStaffsByDeptID:(NSInteger)deptID;

- (NSArray *)getAllStaffs;
@end
