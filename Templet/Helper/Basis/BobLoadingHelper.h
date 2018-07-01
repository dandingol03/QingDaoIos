//
//  BobLoadingView.h
//  GuXianSheng
//
//  Created by liusc on 15/4/16.
//  Copyright (c) 2015年 BobAngus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BobLoadingHelper : NSObject

- (void)show:(UIView *)view animated:(BOOL)animated;

- (void)show:(UIView*)view
   withTitle:(NSString*)title
    animated:(BOOL)animated;

- (void)hide:(BOOL)animated;

- (void)showCommittingView:(UIView*)view
                 withTitle:(NSString*)title
                  animated:(BOOL)animated;

- (void)hideCommittingView:(BOOL)animated;

@end

@interface BobLoadingView : UIView

@property (strong, nonatomic) NSString *title;

- (void)show:(BOOL)animated;

- (void)hide:(BOOL)animated;

@end
