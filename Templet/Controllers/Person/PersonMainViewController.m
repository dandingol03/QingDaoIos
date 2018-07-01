//
//  PersonMainViewController.m
//  Templet
//
//  Created by 丁一明 on 2018/6/6.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "PersonMainViewController.h"
#import "PersonInfoViewController.h"
#import "SettingMainViewController.h"
#import "LoginViewController.h"
#import "UserInfo.h"

@interface PersonMainViewController ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *workStationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *portraitImagView;
@property (strong, nonatomic) UserInfo *userInfo;

@end

@implementation PersonMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self getUserInfo];
}

-(void)getUserInfo
{
    NSString* str = @""HTTP_SERVER"/m_getUserInfoDetail.do";
    //构造参数
    AppDelegate* appDelegate = [AppDelegate shareDelegate];
    NSString* personId = appDelegate.personId;
    
    NSDictionary *parameters=@{@"personId":personId};
    [[DYMHTTPManager sharedManager] requestWithMethod:GET
                                             WithPath:str
                                           WithParams:parameters
                                     WithSuccessBlock:^(NSDictionary *dic) {
                                         NSData *strData = dic;
                                         NSDictionary *content = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingMutableContainers error:nil];//转换数据格式
                                         NSLog(@"responseObject-->%@",content);
                                         self.userInfo = [UserInfo objectWithKeyValues:[content objectForKey:@"data"]];
                                         self.nameLabel.text = self.userInfo.personName;
                                         self.workStationLabel.text = self.userInfo.roleNames;
                                     }
                                      WithFailurBlock:^(NSError *error) {
                                          NSLog(@"error-->%@",error);
                                      }];
    
}



- (IBAction)exitAction:(UIButton *)sender {
    
    AppDelegate* appDelegate = [AppDelegate shareDelegate];
    LoginViewController* login= [[LoginViewController alloc]init];
    appDelegate.window.rootViewController = login;
  
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
