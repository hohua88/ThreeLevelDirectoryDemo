//
//  APIManagerHelper.h
//  KCBuinessKey
//
//  Created by kuang-chi on 16/3/11.
//  Copyright © 2016年 luhua. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APIManagerHelperDelegate <NSObject>

- (void)apiManagerSuccedFeedBack:(id)feedback;
- (void)apiManagerFailedFeedBack:(id)failInfo;

@end

@interface APIManagerHelper : NSObject

@property (nonatomic,assign)id <APIManagerHelperDelegate> delegate;

+(APIManagerHelper *)shareAPIManagerHelper;

/**
 *  @brief POST Method
 *
 *  @param URLString  Post URL String
 *  @param parameters Post Parameters
 */
- (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters;

/**
 *  @brief Post Method
 *
 *  @param URLString       Post URL String
 *  @param parameters      Post Parameters
 *  @param successFeedBack Success FeedBack
 *  @param failFeedBack   Failure Feedback
 */
- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary * jsonDic))successFeedBack failureFeedBack:(void (^)(NSError * error))failFeedBack;
@end
