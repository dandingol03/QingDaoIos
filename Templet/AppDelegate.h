//
//  AppDelegate.h
//  Templet
//
//  Created by 丁一明 on 2018/6/6.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplyInitInfo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UITabBarController *rootTabBarController;
@property (nonatomic, strong) NSString* personId;
//@property (nonatomic, strong) NSDictionary* applyInfo;
@property (nonatomic, strong) ApplyInitInfo* applyInfo;

+ (instancetype)shareDelegate;

@end

