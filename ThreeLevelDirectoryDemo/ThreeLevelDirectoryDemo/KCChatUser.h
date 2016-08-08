//
//  KCChatUser.h
//  IPhontonKEY
//
//  Created by kuang-chi on 15-6-17.
//  Copyright (c) 2015年 kc-mac1. All rights reserved.
//

#import <Foundation/Foundation.h>

//聊天用户
@interface KCChatUser : NSObject


@property(nonatomic,copy)NSString*userPhone;//用户电话号码

@property(nonatomic,copy)NSString*realName;//真实姓名

@property(nonatomic,copy)NSURL*imageUrl;//头像地址

@property(nonatomic,copy)NSString*easemobName;//手机型号

@property(nonatomic)NSUInteger userId;//用户id

@property (nonatomic) NSInteger deptID;

@property BOOL show;


@end
