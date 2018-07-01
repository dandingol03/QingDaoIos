//
//  DeviceHelper.m
//  BobLibrary
//
//  Created by liusc on 15/6/3.
//  Copyright (c) 2015年 BobAngus. All rights reserved.
//

#import "DeviceHelper.h"
#import <UIKit/UIKit.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <mach/machine.h>
#import <mach-o/dyld.h>
#import <mach-o/loader.h>

#if __arm64__ || __x86_64__
#define FILE_BASE_ADDR 0x100000000
#else
#define FILE_BASE_ADDR 0x4000
#endif

static NSUUID *ExecutableUUID(void)
{
    const struct mach_header *executableHeader = NULL;
    for (uint32_t i = 0; i < _dyld_image_count(); i++)
    {
        const struct mach_header *header = _dyld_get_image_header(i);
        if (header->filetype == MH_EXECUTE)
        {
            executableHeader = header;
            break;
        }
    }
    
    if (!executableHeader)
        return nil;
    
    BOOL is64bit = executableHeader->magic == MH_MAGIC_64 || executableHeader->magic == MH_CIGAM_64;
    uintptr_t cursor = (uintptr_t)executableHeader + (is64bit ? sizeof(struct mach_header_64) : sizeof(struct mach_header));
    const struct segment_command *segmentCommand = NULL;
    for (uint32_t i = 0; i < executableHeader->ncmds; i++, cursor += segmentCommand->cmdsize)
    {
        segmentCommand = (struct segment_command *)cursor;
        if (segmentCommand->cmd == LC_UUID)
        {
            const struct uuid_command *uuidCommand = (const struct uuid_command *)segmentCommand;
            return [[NSUUID alloc] initWithUUIDBytes:uuidCommand->uuid];
        }
    }
    
    return nil;
}

@implementation DeviceHelper





//产品要求 保留1位小数 四舍五入
+ (NSString *)nsstringFenSiUnitsWith:(CGFloat)hand{
    NSString *handStr;
    CGFloat handAbs = fabs(hand);
    
    if (handAbs >= 1000000000000) {
        handStr = [NSString stringWithFormat:@"%.1f万亿",hand /1000000000000];
    }else if (handAbs >= 100000000) {
        handStr = [NSString stringWithFormat:@"%.1f亿",hand /100000000];
    }else if (handAbs >= 10000) {
        handStr = [NSString stringWithFormat:@"%.1f万",hand /10000];
    }else{
        handStr = [NSString stringWithFormat:@"%.0f",hand];
    }
    return handStr;
    
    
//    if (handAbs >= 1000000000000) {
//        float temp = floor(hand /1000000000000 * 10)/10;
//        handStr = [NSString stringWithFormat:@"%.1f万亿",temp];
//    }else if (handAbs >= 100000000) {
//        float temp = floor(hand /100000000 * 10)/10;
//        handStr = [NSString stringWithFormat:@"%.1f亿",temp];
//    }else if (handAbs >= 10000) {
//        float temp = floor(hand /10000 * 10)/10;
//        handStr = [NSString stringWithFormat:@"%.1f万",temp];
//    }else{//没有超过1万 直接显示
//        handStr = [NSString stringWithFormat:@"%.0f",hand];
//    }
//    return handStr;
    
    //注视的部分逻辑为 保留两位小数 并且如果是1.10这种数据 处理成1.1
//    if (handAbs >= 1000000000000) {
//        handStr = [NSString stringWithFormat:@"%.2f", hand /1000000000000];
//        handStr = [NSString stringWithFormat:@"%@万亿",@(handStr.floatValue)];
//    }else if (handAbs >= 100000000) {
//        
//        handStr = [NSString stringWithFormat:@"%.2f", hand /100000000];
//        handStr = [NSString stringWithFormat:@"%@亿",@(handStr.floatValue)];
//        
//    }else if (handAbs >= 10000) {
//        handStr = [NSString stringWithFormat:@"%.2f", hand /10000];
//        handStr = [NSString stringWithFormat:@"%@万",@(handStr.floatValue)];
//
//    }else{
//        handStr = [NSString stringWithFormat:@"%.2f", hand];
//        handStr = [NSString stringWithFormat:@"%@",@(handStr.floatValue)];
//    }
//    
//    return handStr;
}


+ (NSString *)nsstringUnitsWith:(CGFloat)hand{
    NSString *handStr;
    
    CGFloat handAbs = fabs(hand);
    
    if (handAbs >= 1000000000000) {
        handStr = [NSString stringWithFormat:@"%.2f万亿",hand /1000000000000];
    }else if (handAbs >= 100000000) {
        handStr = [NSString stringWithFormat:@"%.2f亿",hand /100000000];
    }else if (handAbs >= 10000) {
        handStr = [NSString stringWithFormat:@"%.2f万",hand /10000];
    }else{
        handStr = [NSString stringWithFormat:@"%.2f",hand];
    }
    return handStr;
}


+ (NSString *)nsstringUnitsWiths:(double)hand{
    
    NSString *handStr;
    
    double handAbs = fabs(hand);
    
    if (handAbs >= 1000000000000) {
        handStr = [NSString stringWithFormat:@"%@万亿",[DeviceHelper notRounding:hand /1000000000000 afterPoint:2]];
    }else if (handAbs >= 100000000) {
        handStr = [NSString stringWithFormat:@"%@亿",[DeviceHelper notRounding:hand /100000000 afterPoint:2]];
    }else if (handAbs >= 10000) {
        handStr = [NSString stringWithFormat:@"%@万",[DeviceHelper notRounding:hand /10000 afterPoint:2]];
    }else{
        handStr = [NSString stringWithFormat:@"%@",[DeviceHelper notRounding:hand afterPoint:2]];
    }
    return handStr;
    
    
//    NSString *handStr;
//    if (hand > 1000000000000) {
//        handStr = [NSString stringWithFormat:@"%.2f万亿",hand /1000000000000];
//    }else if (hand > 100000000) {
//        handStr = [NSString stringWithFormat:@"%.2f亿",hand /100000000];
//    }else if (hand > 10000) {
//        handStr = [NSString stringWithFormat:@"%.2f万",hand /10000];
//    }else{
//        handStr = [NSString stringWithFormat:@"%.2f",hand];
//    }
//    return handStr;
}
+(NSString *)notUnitRounding:(double)price afterPoint:(int)position{
    
    @try {
        
        NSString *handStr;
        if (price > 1000000000000) {
            handStr = [NSString stringWithFormat:@"%@万亿",[DeviceHelper notRounding:price /1000000000000 afterPoint:2]];
        }else if (price > 100000000) {
            handStr = [NSString stringWithFormat:@"%@亿",[DeviceHelper notRounding:price /100000000 afterPoint:2]];
        }else if (price > 10000) {
            handStr = [NSString stringWithFormat:@"%@万",[DeviceHelper notRounding:price /10000 afterPoint:2]];
        }else{
            handStr = [NSString stringWithFormat:@"%@",[DeviceHelper notRounding:price afterPoint:2]];
        }
        return handStr;
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

+(NSString *)notRoundingWithfloat:(CGFloat)price afterPoint:(int)position{
    
    @try {
        NSString *lpriceStr = [NSString stringWithFormat:@"%f",price];
        NSRange range = [lpriceStr rangeOfString:@"."];
        NSString *lpriceStr2 = [lpriceStr substringToIndex:range.location + position + 1];
        
        //特殊处理下-0.00的情况
        if(lpriceStr2.doubleValue == 0 && [lpriceStr2 containsString:@"-"] ){
            lpriceStr2 = [lpriceStr2 substringFromIndex:1];
        }
        
        return lpriceStr2;
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

//科学计数法 初步测试有用
-(NSString *)notRounding2:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

//科学计数法 初步测试有用
+(NSString *)notRoundingtwo:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}


+(NSString *)notRounding:(double)price afterPoint:(int)position{
    
    @try {
        
        if (price > 9.289 && price < 9.31) {
            NSString *lpriceStr = [NSString stringWithFormat:@"%f",price];
            NSRange range = [lpriceStr rangeOfString:@"."];
            NSString *lpriceStr2 = [lpriceStr substringToIndex:range.location + position + 1];
            
            //特殊处理下-0.00的情况
            if(lpriceStr2.doubleValue == 0 && [lpriceStr2 containsString:@"-"] ){
                lpriceStr2 = [lpriceStr2 substringFromIndex:1];
            }
            
            return lpriceStr2;
        }
        
        NSString *lpriceStr = [NSString stringWithFormat:@"%f",price];
        NSRange range = [lpriceStr rangeOfString:@"."];
        NSString *lpriceStr2 = [lpriceStr substringToIndex:range.location + position + 1];
        
        //特殊处理下-0.00的情况
        if(lpriceStr2.doubleValue == 0 && [lpriceStr2 containsString:@"-"] ){
            lpriceStr2 = [lpriceStr2 substringFromIndex:1];
        }
        
        return lpriceStr2;
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}


+ (ScreenType)getScreenType
{
    float height = [UIScreen mainScreen].bounds.size.height;
    if (height == 480.f)
        return ScreenType4s;
    if (height == 568.f)
        return ScreenType5s;
    if (height == 667.f)
        return ScreenType6;
    if (height == 736.f)
        return ScreenType6p;
    if (height == 960.f)
        return ScreenType7p;
    return ScreenType5s;
}

+ (NSString *)getDSYMUUID
{
    NSUUID *uuid = ExecutableUUID();
    if (uuid) {
        return [uuid UUIDString] ;
    }
    return nil;
}

+ (NSString *)getVMAddress
{
    return [NSString stringWithFormat:@"0x%llX", (unsigned long long)FILE_BASE_ADDR];
}

+ (NSString *)getCPUType
{
    size_t size;
    cpu_type_t type;
    cpu_subtype_t subtype;
    size = sizeof(type);
    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
    
    size = sizeof(subtype);
    sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);
    
    NSMutableDictionary *subTypeDic = [NSMutableDictionary dictionary];
    [subTypeDic setObject:@"arm" forKey:@(CPU_SUBTYPE_ARM_ALL)];
    [subTypeDic setObject:@"armv4t" forKey:@(CPU_SUBTYPE_ARM_V4T)];
    [subTypeDic setObject:@"armv5tej" forKey:@(CPU_SUBTYPE_ARM_V5TEJ)];
    [subTypeDic setObject:@"armxscale" forKey:@(CPU_SUBTYPE_ARM_XSCALE)];
    [subTypeDic setObject:@"armv6" forKey:@(CPU_SUBTYPE_ARM_V6)];
    [subTypeDic setObject:@"armv6m" forKey:@(CPU_SUBTYPE_ARM_V6M)];
    [subTypeDic setObject:@"armv7" forKey:@(CPU_SUBTYPE_ARM_V7)];
    [subTypeDic setObject:@"armv7f" forKey:@(CPU_SUBTYPE_ARM_V7F)];
    [subTypeDic setObject:@"armv7s" forKey:@(CPU_SUBTYPE_ARM_V7S)];
    [subTypeDic setObject:@"armv7k" forKey:@(CPU_SUBTYPE_ARM_V7K)];
    [subTypeDic setObject:@"armv7m" forKey:@(CPU_SUBTYPE_ARM_V7M)];
    [subTypeDic setObject:@"armv7em" forKey:@(CPU_SUBTYPE_ARM_V7EM)];
    [subTypeDic setObject:@"armv8" forKey:@(CPU_SUBTYPE_ARM_V8)];
    [subTypeDic setObject:@"arm64" forKey:@(CPU_SUBTYPE_ARM64_ALL)];
    [subTypeDic setObject:@"arm64v8" forKey:@(CPU_SUBTYPE_ARM64_V8)];
    
    /* Determine the architecture string */
    NSString *cpuName = @"???";
    switch (type) {
        case CPU_TYPE_ARM:
            cpuName = [subTypeDic objectForKey:@(subtype)];
            if (!cpuName) {
                cpuName = @"arm-unknown";
            }
            break;
            
        case CPU_TYPE_ARM64:
            /* Apple includes subtype for ARM64 binaries. */
            cpuName = [subTypeDic objectForKey:@(subtype)];
            if (!cpuName) {
                cpuName = @"arm64-unknown";
            }
            break;
            
        case CPU_TYPE_X86:
            cpuName = @"i386";
            break;
            
        case CPU_TYPE_X86_64:
            cpuName = @"x86_64";
            break;
            
        case CPU_TYPE_POWERPC:
            cpuName = @"powerpc";
            break;
            
        default:
            // Use the default cpuName value (initialized above).
            break;
    }
    
    return cpuName;
}

+ (BOOL)nsstringIsNilorSpecial:(NSString *)string{
    return string == nil || [string isEqualToString:@""] || [string isEqualToString:@"--"];
}

@end
