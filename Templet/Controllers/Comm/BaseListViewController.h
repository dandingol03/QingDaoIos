//
//  BaseListViewController.h
//  GuXianSheng
//
//  Created by liusc on 15/5/27.
//  Copyright (c) 2015年 BobAngus. All rights reserved.
//

@interface BaseListViewController : BobBaseListViewController

- (void)removeViewControllerFromNav:(NSString*)className;

- (void)setExclusiveTouchForViews:(UIView *)view;

- (void)tabBarReplicationSelect;

@end
