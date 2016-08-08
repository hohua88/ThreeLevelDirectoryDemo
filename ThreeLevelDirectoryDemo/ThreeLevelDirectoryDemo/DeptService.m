//
//  DeptService.m
//  KCBuinessKey
//
//  Created by eddy on 16/6/7.
//  Copyright © 2016年 luhua. All rights reserved.
//

#import "DeptService.h"
#import "DataBaseHelper.h"
@implementation DeptService

+ (instancetype)shareDeptService{
    static DeptService *deptService  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deptService = [[DeptService alloc] init];
    });
    return deptService;
}

- (void)addDept:(DeptEnity *)dept{
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO DEPARTMENTLIST (deptname ,deptid ,companyid , parentid) VALUES ('%@','%lu','%lu','%lu')",dept.deptName,dept.deptID,dept.companyID,dept.parentID];
    [[DataBaseHelper shareDataBaseHelper] executeNonQuery:sql];
}

- (void)deleteDept:(NSInteger)deptID{
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM DEPARTMENTLIST WHERE deptid = '%ld'",(long)deptID];
    [[DataBaseHelper shareDataBaseHelper] executeNonQuery:sql];
}

- (void)modifyDept:(DeptEnity *)dept{
    NSString *sql=[NSString stringWithFormat:@"UPDATE DEPARTMENTLIST  SET (deptname = '%@' WHERE deptid = '%ld'",dept.deptName,dept.deptID];
    [[DataBaseHelper shareDataBaseHelper] executeNonQuery:sql];
}

- (DeptEnity *)getDeptNameByDeptID:(NSInteger)deptID{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM DEPARTMENTLIST WHERE deptid='%ld'", deptID];
    NSArray *array = [[DataBaseHelper shareDataBaseHelper] executeQuery:sql table:2];
    if(array && array.count > 0) {
        return (DeptEnity *)array[0];
    }
    return nil;
}

- (NSArray *)getAllDepts{
    NSMutableArray *array=[NSMutableArray array];
    NSString *sql=@"SELECT * FROM DEPARTMENTLIST";
    NSArray *rows= [[DataBaseHelper shareDataBaseHelper] executeQuery:sql table:2];
    for (DeptEnity *user in rows) {
        [array addObject:user];
    }
    return array;
}
@end
