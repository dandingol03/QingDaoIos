//
//  AppService.m
//  Templet
//
//  Created by 丁一明 on 2018/6/6.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "AppService.h"
#import <sys/utsname.h>
#import "NSString+Util.h"

#import "BobMacro.h"

#define kDeviceId               @"DeviceID"

#define AppMD5Secret @"jiaoyisuo@2017"

@implementation AppService


+ (NSString *)getAppName
{
    NSString *appName = @"Chainup App";
    
    return appName;
}

+ (NSString *)parameterMd5:(NSMutableDictionary *)parameterDic{
    if (!parameterDic) {
        return @"";
    }
    if ([[parameterDic allKeys] containsObject: @"sign"]){
        [parameterDic removeObjectForKey:@"sign"];
    }
    
    NSArray *array = [parameterDic allKeys];
    DLog(@"排序之前 = %@",array);
    array = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result == NSOrderedDescending;
    }];
    DLog(@"排序之后 = %@",array);
    
    NSString *assemblageStr = @"";
    for (int i = 0; i < array.count; i++) {
        NSString *key = [NSString stringWithFormat:@"%@",[array objectAtIndex:i]];
        NSString *value = [parameterDic objectForKey:key];
        assemblageStr = [assemblageStr stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"%@%@",key,value]];
    }
    assemblageStr = [assemblageStr stringByAppendingFormat:@"%@",AppMD5Secret];
    
    NSString *tempMd5 = [assemblageStr md5];
    DLog(@"MD5 %@ 的MD5值 %@",assemblageStr,tempMd5);
    
    return tempMd5;
    
}

//手机系统版本
+ (NSString *)getPhoneVersion{
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    return phoneVersion;
}

//手机类型：iPhone 6
+ (NSString *)getPhoneModel{
    NSString* iphoneType = [AppService iphoneType];
    return iphoneType;
}

//手机系统：iPhone OS
+ (NSString *)getPhoneOS{
    NSString * iphoneos = [[UIDevice currentDevice] systemName];
    return iphoneos;
}

+ (NSString *)getPhoneLang{
    
    NSString *nsLang  = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    NSString *nsCountryCod  = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    
    NSString *code = [NSString stringWithFormat:@"%@_%@",nsLang,nsCountryCod];
    DLog(@"nsLang 1 = %@",code)
    if (![code hasNonWhitespaceText] || [code isEqualToString:@"_"]) {
        code = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]  objectAtIndex:0];
        DLog(@"nsLang 2 = %@",code)
    }
    
    return code;
}


+ (NSString *)getAppUserAgent
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    // Sotao iPhone App/v1.0.0;[phone model];[os version]
    NSString *appUserAgent = [NSString stringWithFormat:@"%@/v%@;%@;%@",
                              [self getAppName],
                              [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleVersion"],
                              [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding],
                              [UIDevice currentDevice].systemVersion];
    
    return appUserAgent;
}

//+ (NSString *)getDeviceID
//{
//    STDataStore *dataStore = [STDataStore dataStore];
//    
//    NSString *deviceID = [dataStore getSecurityData:kDeviceId];
//    
//    if (!deviceID) {
//        deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//        
//        [dataStore setSecurityData:deviceID forKey:kDeviceId];
//    }
//    
//    return deviceID;
//}

+ (NSString *)networktype{
    @try {
        NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
        NSNumber *dataNetworkItemView = nil;
        
        for (id subview in subviews) {
            if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
                dataNetworkItemView = subview;
                break;
            }
        }
        
        switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"]integerValue]) {
            case 0:
                return NSLocalizedString(@"no_service", nil);
                
            case 1:
                return @"2G";
                
            case 2:
                return @"3G";
                
            case 3:
                return @"4G";
                
            case 4:
                return @"LTE";
                
            case 5:
                return @"Wifi";
                
                
            default:
                break;
        }
        return @"";
    } @catch (NSException *exception) {
        DLog(@"Class = %@ Error = %@",NSStringFromClass([self class]),exception);
    } @finally {
        return @"Wifi";
    }
}

+ (NSString*)iphoneType {
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])
        return @"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"])
        return @"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"])
        return @"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])
        return @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"])
        return @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"])
        return @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"])
        return @"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"])
        return @"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"])
        return @"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"])
        return @"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"])
        return @"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"])
        return @"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"])
        return @"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"])
        return @"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])
        return  @"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"])
        return @"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"])
        return  @"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"])
        return  @"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"])
        return  @"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"])
        return  @"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"])
        return @"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"])
        return @"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"])
        return @"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"])
        return @"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"])
        return @"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"])
        return @"iPhone X";
    
    if([platform isEqualToString:@"iPod1,1"])
        return  @"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"])
        return  @"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"])
        return  @"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"])
        return  @"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"])
        return  @"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"])
        return  @"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])
        return  @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])
        return  @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])
        return  @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])
        return  @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])
        return  @"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])
        return  @"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"])
        return  @"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"])
        return  @"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"])
        return  @"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"])
        return  @"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"])
        return  @"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"])
        return  @"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"])
        return  @"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"])
        return  @"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"])
        return  @"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"])
        return  @"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"])
        return  @"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"])
        return  @"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"])
        return  @"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"])
        return  @"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"])
        return  @"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"])
        return  @"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"])
        return  @"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"])
        return  @"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"])
        return  @"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"])
        return  @"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"])
        return  @"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"])
        return  @"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"])
        return  @"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"])
        return  @"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"])
        return  @"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"])
        return  @"iPhone Simulator";
    
    
    return platform;
    
}

@end
