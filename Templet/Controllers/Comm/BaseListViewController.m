//
//  BaseListViewController.m
//  GuXianSheng
//
//  Created by liusc on 15/5/27.
//  Copyright (c) 2015年 BobAngus. All rights reserved.
//

#import "BaseListViewController.h"
#import "AppDelegate.h"

@interface BaseListViewController ()

@end

@implementation BaseListViewController

#pragma mark - 直接跳转
- (void)removeViewControllerFromNav:(NSString*)className
{
    NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
    for (int index = 0; index < viewControllers.count; index++) {
        NSString *vcName = NSStringFromClass([[viewControllers objectAtIndex:index] class]);
        if ([vcName isEqualToString:className]) {
            [viewControllers removeObjectAtIndex:index];
            index++;
        }
    }
    
    self.navigationController.viewControllers = viewControllers;
}

#pragma mark - 设置只接受同时的单词点击
- (void)setExclusiveTouchForViews:(UIView *)view
{
    for (UIView *subView in [view subviews]) {
        if([subView isKindOfClass:[UIButton class]])
            [((UIButton *)subView) setExclusiveTouch:YES];
        else if ([subView isKindOfClass:[UIView class]]){
            [self setExclusiveTouchForViews:subView];
        }
    }
}
////支持旋转
//-(BOOL)shouldAutorotate{
//    return YES;
//}
//
////支持的方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}
#pragma mark - 自定义函数

- (void)setupView {
    [super setupView];
    
    self.tableView.backgroundColor = [UIColor colorWithHex:COLOR_BACKGROUND];
    self.tableView.separatorColor = [UIColor colorWithHex:COLOR_SEPERATE_LINE];
}

- (void)tabBarReplicationSelect {
    
}

- (void)steupPlayingWindow{
//    BOOL isShow = [[AppDelegate shareDelegate] isPlayingWindowShow];
//    if(self.navigationController&&isShow){//有导航控制器
//        NSMutableArray<UIBarButtonItem *> *items = [self.navigationItem.rightBarButtonItems mutableCopy];
//        
//        if(items.count == 1){
//            
//            UIView *view = [[UIView alloc] init];
//            view.frame = CGRectMake(0, 0, 22, 22);
//            UIBarButtonItem *emptyItem = [[UIBarButtonItem alloc ] initWithCustomView:view];
//            [items insertObject:emptyItem atIndex:0];
//            self.navigationItem.rightBarButtonItems = [items copy];
//        }
//        
//    }else{//没有导航控制器
//        if(isShow){//需要隐藏
//            [[AppDelegate shareDelegate] hiddenPlayingWindow];
//        }else{
//            
//        }
//    }
}


#pragma mark - ViewController Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
//    [self steupPlayingWindow];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:STViewControllerWillDisappearNotification object:nil userInfo:nil];
    
//    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
