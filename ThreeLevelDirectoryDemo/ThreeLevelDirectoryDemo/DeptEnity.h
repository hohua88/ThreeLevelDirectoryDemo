//
//  DeptEnity.h
//  KCBuinessKey
//
//  Created by eddy on 16/6/7.
//  Copyright © 2016年 luhua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeptEnity : NSObject

@property (nonatomic) NSString *deptName;
@property (nonatomic) NSInteger deptID;
@property (nonatomic) NSInteger parentID;
@property (nonatomic) NSInteger companyID;
@property (nonatomic) NSInteger expanded;
@property (nonatomic) NSInteger level;
@end
