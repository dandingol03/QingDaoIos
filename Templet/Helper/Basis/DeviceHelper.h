//
//  DeviceHelper.h
//  BobLibrary
//
//  Created by liusc on 15/6/3.
//  Copyright (c) 2015年 BobAngus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScreenType) {
    ScreenType4s = 0,
    ScreenType5s = 1,
    ScreenType6 = 2,
    ScreenType6p = 3,
    ScreenType7p = 4,
};

@interface DeviceHelper : NSObject

+ (ScreenType)getScreenType;
+ (NSString *)nsstringUnitsWiths:(CGFloat)hand;
+ (NSString *)nsstringFenSiUnitsWith:(CGFloat)hand;
+ (NSString *)nsstringUnitsWith:(CGFloat)hand;
+ (NSString *)getDSYMUUID;
+ (NSString *)getVMAddress;
+ (NSString *)getCPUType;
+ (NSString *)notUnitRounding:(double)price afterPoint:(int)position;
+ (NSString *)notRounding:(double)price afterPoint:(int)position;
+ (NSString *)notRoundingWithfloat:(CGFloat)price afterPoint:(int)position;
+ (BOOL)nsstringIsNilorSpecial:(NSString *)string;//判断字符串是否为空或者--

+ (NSString *)notRoundingtwo:(float)price afterPoint:(int)position;
@end
