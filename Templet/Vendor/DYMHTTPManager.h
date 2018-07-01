//
//  DYMHTTPManager.h
//  Templet
//
//  Created by 丁一明 on 2018/6/15.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "AFNetworking/AFNetworking.h"

//请求成功回调block
typedef void (^requestSuccessBlock)(NSDictionary *dic);
//请求失败回调block
typedef void (^requestFailureBlock)(NSError *error);

//请求方法define
typedef enum {
    GET,
    POST,
    PUT,
    DELETE,
    HEAD
} HTTPMethod;

@interface DYMHTTPManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

- (void)requestWithMethod:(HTTPMethod)method
                 WithPath:(NSString *)path
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(requestSuccessBlock)success
          WithFailurBlock:(requestFailureBlock)failure;

@end
