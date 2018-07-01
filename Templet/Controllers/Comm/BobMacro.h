//
//  BobMacro.h
//  Templet
//
//  Created by 丁一明 on 2018/6/6.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#ifndef BobMacro_h
#define BobMacro_h


#ifndef BobLibrary_BobMacro_h
#define BobLibrary_BobMacro_h

#define  HTTP_SERVER @"http://211.159.151.39:81/kunlun-in-control/control_mobile"

#define MARGIN_TOP ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.9 ? 66:0)

#define IS_IOS7_0 ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] == NSOrderedSame)
#define IOS8_OR_LATER   ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending)
#define IOS9_OR_LATER   ([[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending)
#define IsiOS10   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0 ? YES: NO)


#define IS_PAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_PHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_LANDSCAPE UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])

#define SCREEN_WIDTH (IS_LANDSCAPE && !IOS8_OR_LATER ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT (IS_LANDSCAPE && !IOS8_OR_LATER ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)

#define NavigationStatus_Height 64
#define TABBAR_HEIGHT (49)

#define TABLE_VIEW_ITEM_HEIGHT_ZERO (0.001f)

#pragma Log 输出

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#endif




#endif /* BobMacro_h */
