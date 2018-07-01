//
//  BobBaseViewController.h
//  Chainup
//
//  Created by mac on 2017/12/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BobLoadingHelper.h"
#import "BobResultView.h"
//#import "STDataStore.h"
//#import <boblibrarys/BobLoadingHelper.h>

#import "CCTableViewDataSource.h"


@interface BobBaseViewController : UIViewController

//@property (nonatomic, strong) STDataStore *dataStore;
@property (nonatomic, strong) BobResultView *resultView;                    //show Message
@property (nonatomic, strong) BobLoadingHelper *loadingHelper;              //加载视图
@property (nonatomic, strong) NSString *emptyViewMessage;                   //空视图Message

- (void)setup;

- (void)setupView;

- (void)loadData:(BOOL)forceLoad;

- (void)refresh;

#pragma mark - nav method

- (void)popToVC:(Class)vcClass animated:(BOOL)animated;

#pragma mark - show toast method
- (void)showMessage:(NSString *)message;
- (void)showMessage:(NSString *)message duration:(float) duration;
- (void)showError:(NSString *)error;
- (void)showWarning:(NSString *)warning;

- (void)showEmptyView;
- (void)showEmptyViewInView:(UIView *)view;
- (void)showEmptyViewInView:(UIView *)view emptyMessage:(NSString *)emptyMessage;
- (void)showEmptyViewInView:(UIView *)view emptyMessage:(NSString *)emptyMessage needRefresh:(BOOL)needRefresh;

//显示错误消息弹框
//- (void)handleHttpError:(NSString *)error;
//- (void)handleHttpError:(NSString *)error inView:(UIView *)view;
//- (void)handleHttpError:(NSString *)error inView:(UIView *)view hasData:(BOOL)hasData;
//- (void)handleHttpError:(NSString *)error inView:(UIView *)view hasData:(BOOL)hasData frame:(CGRect)frame;

//- (void)handleHttpError:(NSString *)error hasData:(BOOL)hasData;

- (void)handleHttpError:(NSString*)error hasData:(BOOL)hasData frame:(CGRect)frame;

- (void)handleHttpError:(NSString *)error;
- (void)handleHttpError:(NSString *)error hasData:(BOOL)hasData;
- (void)handleHttpError:(NSString*)error hasData:(BOOL)hasData frame:(CGRect)frame;

- (NSString *)getDateTimeUbtervalSince;



@end
