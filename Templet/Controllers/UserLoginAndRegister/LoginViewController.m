//
//  LoginViewController.m
//  Templet
//
//  Created by 丁一明 on 2018/6/8.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "LoginViewController.h"
#import "JVFloatLabeledTextField.h"
#import "IQKeyboardManager.h"
#import "NSString+Util.h"
#import "PanBackNavigationController.h"
#import "HomeMainViewController.h"
#import "PersonMainViewController.h"
#import "VerifyMainViewController.h"
#import "AuditViewController.h"
#import "DYMHTTPManager.h"


@interface LoginViewController ()<UINavigationControllerDelegate,UITabBarControllerDelegate>
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *userNameField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *showPasswordButton;
@property (strong, nonatomic) IBOutlet UIButton *useLoginButton;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
   // [self.navigationController setNavigationBarHidden:YES animated:YES];
   
    
    //保存用户名密码
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    NSString *password = [defaults objectForKey:@"password"];
    
    if(username != nil && username.length > 0)
    {
        self.userNameField.text = username;
    }
    if(password != nil && password.length > 0)
    {
        self.passwordField.text = password;
    }
    
    
    
}


- (IBAction)loginAction:(id)sender {
    [self login];
}

- (void)login{
    //NSString *username = [self.userNameField.text trim];
    //NSString *password = [self.passwordField.text trim];
    NSString *username = @"刘雪青";
    NSString *password = @"1";
    
    if(username != nil && username.length > 0
       && password != nil && password.length > 0)
    {
        NSString* str = [NSString stringWithFormat:@""HTTP_SERVER"/mb_login.do"];
        //NSString* str = [NSString stringWithFormat:@"http://211.159.151.39:81/kunlun-in-control/control_mobile/mb_login.do"];
        NSDictionary *parametersIn=@{@"userName":username,@"passWord":password};
        
        [[DYMHTTPManager sharedManager] requestWithMethod:GET
                                                 WithPath:str
                                               WithParams:parametersIn
                                         WithSuccessBlock:^(NSDictionary *dic) {
                                             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                             [defaults setObject:username forKey:@"username"];
                                             [defaults setObject:password forKey:@"password"];
                                             
                                             AppDelegate* appDelegate = [AppDelegate shareDelegate];
                                             NSData *strData = dic;
                                             NSDictionary *content = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingMutableContainers error:nil];//转换数据格式
                                             NSLog(@"responseObject-->%@",content);
                                             //存储personId
                                             appDelegate.personId = [[content objectForKey:@"data"] objectForKey:@"personId"];
                                             [self gotoHome];
            
        }
                                          WithFailurBlock:^(NSError *error) {
            
        }];
        
        
    }
    
}

-(void)gotoHome{
    
    HomeMainViewController *home = [[HomeMainViewController alloc]init];
    PanBackNavigationController *homeNavigation = [[PanBackNavigationController alloc]initWithRootViewController:home];
    homeNavigation.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"申请"
                                                              image:[UIImage imageNamed:@"文件"]
                                                      selectedImage:[UIImage imageNamed:@"文件"]];
    
    
    
    AuditViewController *verify = [[AuditViewController alloc]init];
    PanBackNavigationController *verifyNavigation = [[PanBackNavigationController alloc]initWithRootViewController:verify];
    verifyNavigation.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"审核"
                                                              image:[UIImage imageNamed:@"审核-2"]
                                                      selectedImage:[UIImage imageNamed:@"审核-2"]];
    
    
    PersonMainViewController *person = [[PersonMainViewController alloc]init];
    PanBackNavigationController *personNavigation = [[PanBackNavigationController alloc]initWithRootViewController:person];
    personNavigation.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"我的"
                                                                image:[UIImage imageNamed:@"图层31拷贝"]
                                                        selectedImage:[UIImage imageNamed:@"图层31拷贝"]];
    
    
    UITabBarController *tabberVC = [[UITabBarController alloc]init];
    tabberVC.viewControllers = @[homeNavigation,verifyNavigation,personNavigation];
    tabberVC.tabBar.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    tabberVC.delegate = self;
    //[tabberVC.tabBar setBackgroundImage:[UIImage imageNamed:@"fooder-bg"]];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithHex:0x747c90]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithHex:0X21b9f0]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHex:0Xffffff alpha:0.5]];
    
    AppDelegate* appDelegate = [AppDelegate shareDelegate];
    appDelegate.window.rootViewController = tabberVC;
    
}


- (NSString *)getDateTimeUbtervalSince{
    
    NSDate *senddate = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    if (![date2 hasNonWhitespaceText]) {
        date2 = @"946656001";   //2000/1/1 0:0:1
    }
    return date2;
}


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
