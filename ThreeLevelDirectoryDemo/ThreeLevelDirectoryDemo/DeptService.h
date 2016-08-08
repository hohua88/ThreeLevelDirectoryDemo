//
//  DeptService.h
//  KCBuinessKey
//
//  Created by eddy on 16/6/7.
//  Copyright © 2016年 luhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeptEnity.h"
@interface DeptService : NSObject

+ (instancetype)shareDeptService;

- (void)addDept:(DeptEnity *)dept;

- (void)deleteDept:(NSInteger)deptID;

- (void)modifyDept:(DeptEnity *)dept;

- (DeptEnity *)getDeptNameByDeptID:(NSInteger)deptID;

- (NSArray *)getAllDepts;
@end
