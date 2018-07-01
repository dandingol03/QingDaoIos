//
//  BobResultView.h
//  GuXianSheng 当无数据或者网络错误时，展示视图
//
//  Created by liusc on 15/5/6.
//  Copyright (c) 2015年 BobAngus. All rights reserved.
//

//#import "HttpClient.h"

typedef NS_ENUM(NSInteger, BobResultViewType) {
    BobResultViewTypeEmpty = 0,
    BobResultViewTypeNetworkError = 1,
};

@class BobResultView;

@protocol BobResultViewDelegate <NSObject>

@optional

- (void)refresh:(BobResultView*)resultView;

@end

@interface BobResultView : UIView

@property (weak, nonatomic) id<BobResultViewDelegate> delegate;

- (void)showInView:(UIView*)view;

- (void)showInView:(UIView *)view withHCError:(NSString *)error;

- (void)showInView:(UIView *)view withEmptyMessage:(NSString *)emptyMessage;

- (void)showInView:(UIView *)view
    resultViewType:(BobResultViewType)resultViewType;

- (void)showInView:(UIView *)view
   resultImageName:(NSString *)resultImageName
       resultTitle:(NSString *)resultTitle
 resultDescription:(NSString *)resultDescription
       needRefresh:(BOOL)needRefresh;

- (void)hide;

@end
