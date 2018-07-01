//
//  OfficeListDetailViewController.m
//  Templet
//
//  Created by 丁一明 on 2018/6/30.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "OfficeListDetailViewController.h"
#import "OfficeDetailInfo.h"
#import "OfficeListInfo.h"

#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)

@interface OfficeListDetailViewController ()
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *view4;
@property (strong, nonatomic) IBOutlet UIView *imageViewArea;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property(strong,nonatomic) OfficeDetailInfo* info;
@end

@implementation OfficeListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, 1000);
    self.navigationItem.title = @"详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"fooder-bg11"] forBarMetrics:UIBarMetricsDefault];
    
    [self getDetailInfo:self.expendId];
    
}

-(void)getDetailInfo:(NSString*)expendId{
    
    [self.loadingHelper showCommittingView:self.view withTitle:@"loading" animated:YES];
    NSString* str = @""HTTP_SERVER"/m_getApplyInfoDetail.do";
    //构造参数
    AppDelegate* appDelegate = [AppDelegate shareDelegate];
    NSString* personId = appDelegate.personId;
    NSDictionary *parameters=@{@"personId":personId,@"expendId":expendId};
    [[DYMHTTPManager sharedManager] requestWithMethod:GET
                                             WithPath:str
                                           WithParams:parameters
                                     WithSuccessBlock:^(NSDictionary *dic) {
                                         NSData *strData = dic;
                                         NSDictionary *content = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingMutableContainers error:nil];//转换数据格式
                                         NSLog(@"responseObject-->%@",content);
                                         NSDictionary *data = [content objectForKey:@"data"];
                                         self.info = [OfficeDetailInfo objectWithKeyValues:data];
                                         NSMutableArray *array = [[content objectForKey:@"data"] objectForKey:@"dataList"];
                                         NSMutableArray* officeList = [OfficeListInfo objectArrayWithKeyValuesArray:array];
                                         
                                         [self endRefreshing];
                                         [self.loadingHelper hideCommittingView:YES];
                                         
                                         if(officeList!=nil&&officeList.count!=0){
                                             for(OfficeListInfo* listInfo in officeList){
                                                 
                                             }
                                         }
                                         
                                     }
                                      WithFailurBlock:^(NSError *error) {
                                          NSLog(@"error-->%@",error);
                                          [self endRefreshing];
                                      }];
    
}

- (IBAction)addOfficeListAction:(id)sender {
}

- (IBAction)saveModifyAction:(id)sender {
}

- (IBAction)foldImageView:(id)sender {
}

- (IBAction)submmitAction:(id)sender {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
