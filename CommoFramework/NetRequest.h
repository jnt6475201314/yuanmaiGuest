//
//  NetRequest.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/14.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^SuccessBlock)(id data);
typedef void(^FailBlock)(NSString *errorDes);
typedef void(^HideHUDBlock)();

@interface NetRequest : NSObject

+ (void)getDataWithUrlString:(NSString *)urlString withParams:(NSDictionary *)params success:(SuccessBlock)successBlock fail:(FailBlock)failBlock;

+ (void)postDataWithUrlString:(NSString *)urlString withParams:(NSDictionary *)params success:(SuccessBlock)successBlock fail:(FailBlock)failBlock;

+ (void)AF_RegisterByPostWithUrlString:(NSString *)urlString params:(NSDictionary *)params image:(UIImage *)image success:(SuccessBlock)successBlock fail:(FailBlock)failBlock;

/* 检查是否异地登陆的操作 */
+ (void)checkOtherPlaceLoginWithUrlString:(NSString *)urlString withParams:(NSDictionary *)params success:(SuccessBlock)successBlock fail:(FailBlock)failBlock;

@end
