//
//  BobBaseViewController.m
//  Chainup
//
//  Created by mac on 2017/12/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BobBaseViewController.h"

@interface BobBaseViewController ()<BobResultViewDelegate>
{
    UIView *toastMessageView;
    UIView *toastErrorView;
    UIView *toastWarningView;
}

@end

@implementation BobBaseViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"fooder-bg11"] forBarMetrics:UIBarMetricsDefault];
    self.view.layer.contents = (id)[UIImage imageNamed:@"bg-neiye"].CGImage;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.topItem.title = @"";
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"fooder-bg"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.topItem.title = @"";
}

#pragma mark - public method

- (void)setup
{
    
    self.loadingHelper = [[BobLoadingHelper alloc] init];
    //self.dataStore = [STDataStore dataStore];
    self.resultView = [[BobResultView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0f)];
    self.resultView.delegate = self;
}

- (void)setupView
{
    [self replaceSkin];
}


-(void) replaceSkin{
    
}

- (void)loadData:(BOOL)forceLoad
{
    
}

- (void)refresh
{
    [self loadData:YES];
}


#pragma mark - nav method

- (void)popToVC:(Class)vcClass animated:(BOOL)animated
{
    UIViewController *viewController;
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:vcClass]) {
            viewController = vc;
            break;
        }
    }
    if (!viewController) {
        UIView *willRemoveViewController = [viewControllers lastObject];
        
        viewController = [[vcClass alloc] init];
        [self.navigationController pushViewController:viewController animated:animated];
        
        viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [viewControllers removeObject:willRemoveViewController];
        
        self.navigationController.viewControllers = viewControllers;
    } else {
        [self.navigationController popToViewController:viewController animated:animated];
    }
}

#pragma mack - showerror - showwarning

#pragma mark - show toast method

- (void)showMessage:(NSString *)message
{
    [self showMessage:message position:CSToastPositionCenter];
}

- (void)showMessage:(NSString *)message duration:(float) duration
{
    if (toastMessageView) {
        [self.view hideToast:toastMessageView animated:NO];
    }
    
    toastMessageView = [self.view viewForMessage:message title:nil image:nil];
    
    [self.view showToast:toastMessageView duration:duration position:CSToastPositionCenter];
    
}

- (void)showMessage:(NSString *)message position:(id)position
{
    if (toastMessageView) {
        [self.view hideToast:toastMessageView animated:NO];
    }
    
    toastMessageView = [self.view viewForMessage:message title:nil image:nil];
    
    [self.view showToast:toastMessageView duration:2.0f position:position];
}

- (void)showError:(NSString *)error
{
    [self showError:error position:CSToastPositionCenter];
}

- (void)showError:(NSString *)error position:(id)position
{
    if (toastErrorView) {
        [self.view hideToast:toastErrorView animated:NO];
    }
    
    toastErrorView = [self.view viewForMessage:error title:nil image:nil];
    
    [self.view showToast:toastErrorView duration:2.0f position:position];
}

- (void)showWarning:(NSString *)warning
{
    [self showWarning:warning position:CSToastPositionCenter];
}

- (void)showWarning:(NSString *)warning position:(id)position
{
    if (toastWarningView) {
        [self.view hideToast:toastWarningView animated:NO];
    }
    
    toastWarningView = [self.view viewForMessage:warning title:nil image:nil];
    
    [self.view showToast:toastWarningView duration:2.0f position:position];
}

#pragma mack - showempty
- (void)showEmptyView;
{
    [self showEmptyViewInView:self.view];
}

- (void)showEmptyViewInView:(UIView *)view
{
    [self showEmptyViewInView:view emptyMessage:nil];
}

- (void)showEmptyViewInView:(UIView *)view emptyMessage:(NSString *)emptyMessage
{
    [self showEmptyViewInView:view emptyMessage:emptyMessage needRefresh:NO];
}

- (void)handleHttpError:(NSString *)error{
    [self handleHttpError:error hasData:NO];
}
- (void)handleHttpError:(NSString *)error hasData:(BOOL)hasData{
    if (self.loadingHelper) {
        [self.loadingHelper hide:NO];
    }
    
    if (hasData) {
        [self showError:error];
    } else {
        [self.resultView showInView:self.view withHCError:error];
    }
}
- (void)handleHttpError:(NSString*)error hasData:(BOOL)hasData frame:(CGRect)frame{
    
    [self handleHttpError:error hasData:hasData];
    self.resultView.frame = frame;
}
//- (void)handleHttpError:(NSString*)error inView:(UIView *)view hasData:(BOOL)hasData frame:(CGRect)frame
//{
//    [self handleHttpError:error inView:view hasData:hasData];
//    self.resultView.frame = frame;
//}


- (NSString *)getDateTimeUbtervalSince{
    
    NSDate *senddate = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    if (![date2 hasNonWhitespaceText]) {
        date2 = @"946656001";   //2000/1/1 0:0:1
    }
    return date2;
}

#pragma mark - nav method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
