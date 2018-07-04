//
//  CultivateDetailViewController.m
//  Templet
//
//

#import "CultivateDetailViewController.h"
#import "ConferenceInfo.h"
#import "CultivateInfo.h"
#import "ApplyInitInfo.h"



@interface CultivateDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *departmentLabel;//当前单位

@property (nonatomic, assign) BOOL isLoan;//是否借款 0是，1否
@property (strong, nonatomic) IBOutlet UIImageView *isLoanImag_y;//需要借款
@property (strong, nonatomic) IBOutlet UIButton *yesBtn;
@property (strong, nonatomic) IBOutlet UIImageView *isLoanImag_n;//不需要借款
@property (strong, nonatomic) IBOutlet UIButton *noBtn;

@property (weak, nonatomic) IBOutlet UITextField *trainName;
@property (weak, nonatomic) IBOutlet UITextField *trainTime;
@property (weak, nonatomic) IBOutlet UITextField *trainEnd;
@property (weak, nonatomic) IBOutlet UITextField *trainReport;
@property (weak, nonatomic) IBOutlet UITextField *trainLeave;
@property (weak, nonatomic) IBOutlet UITextField *trainPlace;
@property (weak, nonatomic) IBOutlet UITextField *trainStaffNum;
@property (weak, nonatomic) IBOutlet UITextField *trainNum;
@property (weak, nonatomic) IBOutlet UITextField *trainBudget;
@property (weak, nonatomic) IBOutlet UITextField *trainObject;

@property(strong,nonatomic) CultivateInfo* info;

@end

@implementation CultivateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    self.trainNum.text=@"预计参训\n人数:";
    
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
                                         self.info = [CultivateInfo objectWithKeyValues:data];
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

-(void)setDefaultInfo:(CultivateInfo*)info{
    
    self.trainName.text=info.trainName;
    self.trainEnd.text=info.trainEnd;
    self.trainLeave.text=info.trainLeave;
    self.trainReport.text=info.trainReport;
    self.trainPlace.text=info.trainPlace;
    self.trainBudget.text=info.trainBudget;
    self.trainTime.text=info.trainTime;
    self.trainNum.text = [NSString stringWithFormat:@"%@", info.trainNum];
    self.trainStaffNum.text=[NSString stringWithFormat:@"%@", info.trainStaffNum];
    self.trainObject.text=info.trainObject;
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
