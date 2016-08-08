//
//  ContactCellModel.h
//  KCBuinessKey
//
//  Created by eddy on 16/6/14.
//  Copyright © 2016年 luhua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactCellModel : NSObject

@property (nonatomic) NSInteger level;

@property (nonatomic) NSString *name;

@property (nonatomic) NSString *modelID;

@property (nonatomic) NSString *parentModelID;

@property (nonatomic) BOOL isOpened;

@property (nonatomic) ContactCellModel *parent;

@property (nonatomic) NSString *headImage;

@property (nonatomic) NSString *telNum;

@property (nonatomic) NSString *easeMobName;

@property (nonatomic) BOOL refresh;

@end
