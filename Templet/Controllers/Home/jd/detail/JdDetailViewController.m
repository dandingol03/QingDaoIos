//
//  JdDetailViewController.m
//  Templet
//
//

#import "JdDetailViewController.h"
#import "JdInfo.h"
#import "ApplyInitInfo.h"


@interface JdDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *departmentLabel;//当前单位

@property (nonatomic, assign) BOOL isLoan;//是否借款 0是，1否
@property (strong, nonatomic) IBOutlet UIImageView *isLoanImag_y;//需要借款
@property (strong, nonatomic) IBOutlet UIButton *yesBtn;
@property (strong, nonatomic) IBOutlet UIImageView *isLoanImag_n;//不需要借款
@property (strong, nonatomic) IBOutlet UIButton *noBtn;

@property (strong, nonatomic) IBOutlet UIImageView *isBusinessImag_y;//普通公务
@property (strong, nonatomic) IBOutlet UIButton *businessBtn;
@property (strong, nonatomic) IBOutlet UIImageView *isInvestmentImag_n;//招商引资
@property (strong, nonatomic) IBOutlet UIButton *investmentBtn;


@property (weak, nonatomic) IBOutlet UITextField *visitorNum;
@property (weak, nonatomic) IBOutlet UITextField *accompanyNum;
@property (weak, nonatomic) IBOutlet UITextField *letterNo;
@property (weak, nonatomic) IBOutlet UITextField *guestUnit;
@property (weak, nonatomic) IBOutlet UILabel *labelNameAndPost;
@property (weak, nonatomic) IBOutlet UITextField *nameAndPost;
@property (weak, nonatomic) IBOutlet UITextField *trainPlace;
@property (weak, nonatomic) IBOutlet UILabel *labelActivityContent;
@property (weak, nonatomic) IBOutlet UITextField *activityContent;
@property (weak, nonatomic) IBOutlet UITextField *jc_time;
@property (weak, nonatomic) IBOutlet UITextField *jc_address;
@property (weak, nonatomic) IBOutlet UITextField *zs_address;
@property (weak, nonatomic) IBOutlet UITextField *zs_days;

//是否饮酒
@property (nonatomic, assign) NSString *isYj;//是否饮酒 0是，1否
@property (strong, nonatomic) IBOutlet UIImageView *isYjImag_y;
@property (strong, nonatomic) IBOutlet UIButton *yjBtn;
@property (strong, nonatomic) IBOutlet UIImageView *noYjImag_n;
@property (strong, nonatomic) IBOutlet UIButton *noYjBtn;

@property (weak, nonatomic) IBOutlet UITextField *jdzs_money;
@property (weak, nonatomic) IBOutlet UITextField *jdhs_money;
@property (weak, nonatomic) IBOutlet UITextField *jdqt_money;

@property (weak, nonatomic) IBOutlet UILabel *budgetAmount;
@property (weak, nonatomic) IBOutlet UITextField *remark;
@property (weak, nonatomic) IBOutlet UIButton *save;


@property(strong,nonatomic) JdInfo* info;
@end

@implementation JdDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    self.labelNameAndPost.text=@"来宾姓名\n职务:";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"fooder-bg11"] forBarMetrics:UIBarMetricsDefault];
    
    //初始化ui
    [self initView];
}

-(void)initView{
    //拉取详情
    [self getCultivateDetailInfo:self.expendId];
}

-(void)getCultivateDetailInfo:(NSString *)expendId{
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
                                         self.info = [JdInfo objectWithKeyValues:data];
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

-(void)setDefaultInfo:(JdInfo*)info{
    
    self.visitorNum.text=[NSString stringWithFormat:@"%@", info.visitorNum];
    self.accompanyNum.text=[NSString stringWithFormat:@"%@", info.accompanyNum];
    self.letterNo.text=info.letterNo;
    self.guestUnit.text=info.guestUnit;
    self.nameAndPost.text=info.nameAndPost;
    self.activityContent.text=info.activityContent;
    self.jc_time.text=info.jc_time;
    self.jc_address.text=info.jc_address;
    self.zs_address.text=info.zs_address;
    self.zs_days.text=[NSString stringWithFormat:@"%@", info.zs_days];
    self.jdzs_money.text=info.jdzs_money;
    self.jdhs_money.text=info.jdhs_money;
    self.jdqt_money.text=info.jdqt_money;
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
    
    self.isYj=info.yj;
    if([self.isYj isEqualToString: @"否"])
    {
        self.isYjImag_y.image = [UIImage imageNamed:@"checkbox_n"];
        self.noYjImag_n.image = [UIImage imageNamed:@"checkbox_s"];
    }else{
        self.isYjImag_y.image = [UIImage imageNamed:@"checkbox_s"];
        self.noYjImag_n.image = [UIImage imageNamed:@"checkbox_n"];
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
