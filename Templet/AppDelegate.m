//
//  AppDelegate.m
//  Templet
//
//  Created by 丁一明 on 2018/6/6.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "AppDelegate.h"
#import "PanBackNavigationController.h"
#import "HomeMainViewController.h"
#import "PersonMainViewController.h"
#import "UIColor+Util.h"
#import <Bugly/Bugly.h>
#import "AppService.h"
#import "LoginViewController.h"

@interface AppDelegate ()<UINavigationControllerDelegate,UITabBarControllerDelegate>



@end

@implementation AppDelegate

+ (instancetype)shareDelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [Bugly startWithAppId:@"4b92af9e4c"];
    [self setupRootView];
    
    return YES;
}

#pragma mark 根视图
- (void)setupRootView
{
    
    LoginViewController* loginVC = [[LoginViewController alloc] init];
    self.window.rootViewController = loginVC;
   
//    PersonMainViewController *person = [[PersonMainViewController alloc]init];
//    PanBackNavigationController *personNavigation = [[PanBackNavigationController alloc]initWithRootViewController:person];
//    personNavigation.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"个人中心"
//                                                                 image:[UIImage imageNamed:@"Account-icon"]
//                                                         selectedImage:[UIImage imageNamed:@"Account-icon-blue"]];
//
//
//    HomeMainViewController *home = [[HomeMainViewController alloc]init];
//    PanBackNavigationController *homeNavigation = [[PanBackNavigationController alloc]initWithRootViewController:home];
//    homeNavigation.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"首页"
//                                                              image:[UIImage imageNamed:@"icon_home_n"]
//                                                      selectedImage:[UIImage imageNamed:@"icon_home_s"]];
//
//
//    UITabBarController *tabberVC = [[UITabBarController alloc]init];
//    tabberVC.viewControllers = @[homeNavigation,personNavigation];
//    tabberVC.tabBar.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
//    tabberVC.delegate = self;
//    [tabberVC.tabBar setBackgroundImage:[UIImage imageNamed:@"fooder-bg"]];
//
//    self.rootTabBarController = tabberVC;
//    self.window.rootViewController = self.rootTabBarController;
//
//    [[UITabBar appearance] setTintColor:[UIColor colorWithHex:0x747c90]];
//    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithHex:0X21b9f0]];
//    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHex:0Xffffff alpha:0.5]];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
