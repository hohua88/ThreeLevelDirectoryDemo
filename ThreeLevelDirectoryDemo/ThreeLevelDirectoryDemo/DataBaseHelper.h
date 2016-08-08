//
//  DataBaseHelper.h
//  KCBuinessKey
//
//  Created by kuang-chi on 16/1/27.
//  Copyright © 2016年 luhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "KCChatUser.h"

@interface DataBaseHelper : NSObject
{
    FMDatabaseQueue *database;
    FMDatabase *myDB;
}
+(instancetype)shareDataBaseHelper;

-(void)executeNonQuery:(NSString *)sql;

- (NSArray *)executeQuery:(NSString *)sql table:(NSInteger )tableType;

@end
