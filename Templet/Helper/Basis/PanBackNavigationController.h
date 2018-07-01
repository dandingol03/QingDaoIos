//
//  STNavigationController.h
//  GuXianSheng
//
//  Created by CavinTang on 9/14/15.
//  Copyright (c) 2015 BobAngus. All rights reserved.
//
// 基于PanBack改写，源代码地址https://github.com/zaishihuang/PanBack
//
#define IOS8_OR_LATERS   ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending)
#define IOS9_OR_LATERS   ([[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending)

#define IS_LANDSCAPES UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])

#define SCREEN_WIDTHS (IS_LANDSCAPES && !IOS8_OR_LATERS ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHTS (IS_LANDSCAPES && !IOS8_OR_LATERS ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)

#import <UIKit/UIKit.h>

@interface PanBackNavigationController : UINavigationController

@property (readonly, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end

@protocol STPanBackNavigationProtocol <NSObject>

@optional

- (BOOL)enablePanBack:(PanBackNavigationController *)navigationController;
- (void)startPanBack:(PanBackNavigationController *)navigationController;
- (void)finshPanBack:(PanBackNavigationController *)navigationController;
- (void)resetPanBack:(PanBackNavigationController *)navigationController;

@end

#pragma mark STPanGestureRecognizer

@interface STPanGestureRecognizer : UIPanGestureRecognizer

@property (readonly, nonatomic) UIEvent *event;

- (CGPoint)beganLocationInView:(UIView *)view;

@end

#pragma mark UIView+Snapshot

@interface UIView (Snapshot)

- (UIImage *)snapshot;

@end
