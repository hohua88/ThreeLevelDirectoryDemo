//
//  APIManagerHelper.m
//  KCBuinessKey
//
//  Created by kuang-chi on 16/3/11.
//  Copyright © 2016年 luhua. All rights reserved.
//

#import "APIManagerHelper.h"

#import "AFNetworking.h"
__strong static AFHTTPSessionManager *AFHTTPMgr;
__strong static APIManagerHelper *apiManagerInstance=nil;
@implementation APIManagerHelper
/**
 *  @brief shareAPIManagerHelper
 *
 *  @return singleton
 */
+ (APIManagerHelper *)shareAPIManagerHelper{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        apiManagerInstance = [[APIManagerHelper alloc]init];//初始化实例
        //一下是AFHTTPSessionManager的配置
        AFHTTPMgr=[AFHTTPSessionManager manager];
        //申明返回的结果是json类型
        AFHTTPMgr.responseSerializer=[AFJSONResponseSerializer serializer];
        //设置超时时间
        AFHTTPMgr.requestSerializer.timeoutInterval=30;
        AFHTTPMgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    });
    return apiManagerInstance;
}

- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters{
    __weak APIManagerHelper *weakself = self;
    [AFHTTPMgr POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([weakself.delegate respondsToSelector:@selector(apiManagerSuccedFeedBack:)]) {
            [weakself.delegate apiManagerSuccedFeedBack:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([weakself.delegate respondsToSelector:@selector(apiManagerFailedFeedBack:)]) {
            [weakself.delegate apiManagerFailedFeedBack:error];
        }
    }];
}

- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary * jsonDic))successFeedBack failureFeedBack:(void (^)(NSError * error))failFeedBack{
    [AFHTTPMgr POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successFeedBack(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failFeedBack(error);
    }];
}
@end
