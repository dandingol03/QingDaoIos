//
//  GoAbroadDetailViewController.m
//  Templet
//
//

#import "GoAbroadDetailViewController.h"
#import "GoAbroadInfo.h"
#import "ApplyInitInfo.h"

@interface GoAbroadDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *departmentLabel;//当前单位
@property (weak, nonatomic) IBOutlet UILabel *budgetAmount;

@property (nonatomic, assign) BOOL isLoan;//是否借款 0是，1否
@property (strong, nonatomic) IBOutlet UIImageView *isLoanImag_y;//需要借款
@property (strong, nonatomic) IBOutlet UIButton *yesBtn;
@property (strong, nonatomic) IBOutlet UIImageView *isLoanImag_n;//不需要借款
@property (strong, nonatomic) IBOutlet UIButton *noBtn;
@property (weak, nonatomic) IBOutlet UITextField *groupName;
@property (weak, nonatomic) IBOutlet UITextField *groupUnit;
@property (weak, nonatomic) IBOutlet UITextField *colonel;
@property (weak, nonatomic) IBOutlet UITextField *groupNum;
@property (weak, nonatomic) IBOutlet UITextField *visitingCountry;
@property (weak, nonatomic) IBOutlet UITextField *visitingDay;
@property (weak, nonatomic) IBOutlet UITextField *ht_money;
@property (weak, nonatomic) IBOutlet UITextField *zs_money;
@property (weak, nonatomic) IBOutlet UITextField *hs_money;
@property (weak, nonatomic) IBOutlet UITextField *jt_money;
@property (weak, nonatomic) IBOutlet UITextField *qt_money;
@property (weak, nonatomic) IBOutlet UITextField *remark;
@property (weak, nonatomic) IBOutlet UIButton *save;
@property (weak, nonatomic) IBOutlet UIButton *apply;

@property(strong,nonatomic) GoAbroadInfo* info;
@end

@implementation GoAbroadDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"fooder-bg11"] forBarMetrics:UIBarMetricsDefault];
    
    //初始化ui
    [self initView];
}

-(void)initView{
    //拉取详情
    [self getGoAbroadDetailInfo:self.expendId];
}

-(void)getGoAbroadDetailInfo:(NSString *)expendId{
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
                                         self.info = [GoAbroadInfo objectWithKeyValues:data];
                                         NSMutableArray *array = [[content objectForKey:@"data"] objectForKey:@"dataList"];
                                         //初始化view
                                         [self setDefaultInfo:self.info];
                                         
                                         [self endRefreshing];
                                         [self.loadingHelper hideCommittingView:YES];
                                         
                                     }
                                      WithFailurBlock:^(NSError *error) {
                                          NSLog(@"error-->%@",error);
                                          [self endRefreshing];
                                      }];
}

-(void)setDefaultInfo:(GoAbroadInfo*)info{
    
    self.ht_money.text=[NSString stringWithFormat:@"%@", info.ht_money];
    self.groupName.text=info.groupName;
    self.groupUnit.text=info.groupUnit;
    self.colonel.text=info.colonel;
    self.groupNum.text=info.groupNum;
    self.visitingCountry.text=info.visitingCountry;
    self.visitingDay.text=info.visitingDay;
    self.jt_money.text=[NSString stringWithFormat:@"%@", info.jt_money];
    self.zs_money.text=[NSString stringWithFormat:@"%@", info.zs_money];
    self.hs_money.text=[NSString stringWithFormat:@"%@", info.hs_money];
    self.qt_money.text=[NSString stringWithFormat:@"%@", info.qt_money];
    
    self.budgetAmount.text=[NSString stringWithFormat:@"%@", info.budgetAmount];
    
    self.departmentLabel.text = info.applyDeptName;
    //    self.budgetAmountField.text = [NSString stringWithFormat:@"%@", conferenceInfo.budgetAmount];
    
    self.isLoan = info.isLoan;
    if(self.isLoan == YES){
        self.isLoanImag_y.image = [UIImage imageNamed:@"checkbox_s"];
        self.isLoanImag_n.image = [UIImage imageNamed:@"checkbox_n"];
    }else{
        self.isLoanImag_y.image = [UIImage imageNamed:@"checkbox_n"];
        self.isLoanImag_n.image = [UIImage imageNamed:@"checkbox_s"];
    }
    

    
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
