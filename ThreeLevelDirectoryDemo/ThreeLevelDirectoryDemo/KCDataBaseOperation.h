//
//  KCDataBaseOperation.h
//  KCBuinessKey
//
//  Created by kuang-chi on 16/1/27.
//  Copyright © 2016年 luhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface KCDataBaseOperation : NSObject
{
    FMDatabase *db;
}
+ (void)initDataBase;
+ (void)dropDataBase;
+ (void)dropDepartmentTable;
+ (void)createDepartmentTable;
@end
