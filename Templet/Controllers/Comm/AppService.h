//
//  AppService.h
//  Templet
//
//  Created by 丁一明 on 2018/6/6.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppService : NSObject

+ (NSString *)getAppName;

+ (NSString *)getAppUserAgent;

//+ (NSString *)getDeviceID;

//手机系统版本
+ (NSString *)getPhoneVersion;

//手机类型：iPhone 6
+ (NSString *)getPhoneModel;

//手机系统：iPhone OS
+ (NSString *)getPhoneOS;

+ (NSString *)getPhoneLang;

+ (NSString *)networktype;

+ (NSString *)parameterMd5:(NSMutableDictionary *)parameterDic;
@end
