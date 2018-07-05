//
//  NewBusinessUIViewController.m
//  Templet
//
//

#import "NewBusinessUIViewController.h"
#import "OfficeDetailInfo.h"
#import "OfficeInfo.h"
#import "ApplyInitInfo.h"
#import "MJExtension.h"


#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)
@interface NewBusinessUIViewController ()
@property (weak, nonatomic) IBOutlet UIView *office_ll;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *expenditureLabel;//支出事项
@property (strong, nonatomic) IBOutlet UILabel *departmentLabel;//当前单位
@property (weak, nonatomic) IBOutlet UILabel *budgetAmount;


@property (strong, nonatomic) IBOutlet UITextField *cashContent;//用款内容
@property (strong, nonatomic) IBOutlet UITextField *remark;//备注

@property (nonatomic, assign) BOOL isLoan;//是否借款 0是，1否

@property (strong, nonatomic) IBOutlet UIImageView *isLoanImag_y;//需要借款
@property (strong, nonatomic) IBOutlet UIButton *yesBtn;
@property (strong, nonatomic) IBOutlet UIImageView *isLoanImag_n;//不需要借款
@property (strong, nonatomic) IBOutlet UIButton *noBtn;




@property (nonatomic ,strong) NSDictionary *expenditureItemMap;//支出事项弹框
@property (nonatomic ,strong) NSArray *expenditureItemArray;
@property (nonatomic ,strong) NSArray* expenditureItemList;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL isFold;//是否折叠附件

@property(strong,nonatomic) NSMutableArray *officeListArray;
@property(strong,nonatomic) OfficeDetailInfo *info;
@property(strong,nonatomic) NSLayoutConstraint *heightConstraint;
@property(strong,nonatomic) NSLayoutConstraint *contentHc;


@end

@implementation NewBusinessUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"fooder-bg11"] forBarMetrics:UIBarMetricsDefault];
    
    self.officeListArray=[[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //初始化ui
    [self initView];
}

-(void)initView{
    AppDelegate* appDelegate = [AppDelegate shareDelegate];
    ApplyInitInfo* initInfo = appDelegate.applyInfo;
    self.expenditureItemList = initInfo.zhichuList;//支出列表
    NSMutableArray* expkey = [NSMutableArray array];
    NSMutableArray* expValue = [NSMutableArray array];
    
    for(NSDictionary *obj in self.expenditureItemList){
        expkey = [expkey arrayByAddingObject:[obj objectForKey:@"value"]];
        expValue = [expValue arrayByAddingObject:[obj objectForKey:@"key"]];
    }
    _expenditureItemMap = [NSDictionary dictionaryWithObjects:expValue forKeys:expkey];
    _expenditureItemArray = expValue;
    
    NSArray* depList = initInfo.depList;//当前部门
    NSDictionary* dep = [depList objectAtIndex:0];
    self.departmentLabel.text = [dep objectForKey:@"deptName"];
    self.isFold=NO;
}

- (IBAction)isLoanAction:(UIButton*)sender {
    switch (sender.tag) {
        case 1:{
            self.isLoan = YES;
            self.isLoanImag_y.image = [UIImage imageNamed:@"checkbox_s"];
            self.isLoanImag_n.image = [UIImage imageNamed:@"checkbox_n"];
        }
            break;
            
        case 2:{
            self.isLoan = NO;
            self.isLoanImag_y.image = [UIImage imageNamed:@"checkbox_n"];
            self.isLoanImag_n.image = [UIImage imageNamed:@"checkbox_s"];
        }
            break;
            
        default:
            break;
    }
    
}

- (IBAction)actionSheetButton:(UIButton *)sender {
    switch (sender.tag) {
        case 1:{
            [ActionSheetStringPicker showPickerWithTitle:@"选择支出事项" rows:self.expenditureItemArray initialSelection:self.selectedIndex target:self successAction:@selector(expenditureItemWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
            break;
        default:
            break;
    }
}

//办公提交
- (IBAction)apply:(id)sender {
    
    [self.loadingHelper showCommittingView:self.view withTitle:@"loading" animated:YES];
    NSString* str = @""HTTP_SERVER"/do_saveByOffice.do";
    AppDelegate* appDelegate = [AppDelegate shareDelegate];
    NSString* personId = appDelegate.personId;

    NSMutableArray *offices=[[NSMutableArray alloc] init];
    for(OfficeInfo *office in self.officeListArray)
    {
        [offices addObject: [[self.officeListArray objectAtIndex:0] keyValues]];
    }
    [offices keyValues];
    NSMutableDictionary *ob=[[NSMutableDictionary alloc] init];
    [ob setObject:offices forKey:@"dataList"];
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ob options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *converted= [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSDictionary *parameters=@{@"personId":personId,
                               @"flag":@"0",
                               @"expendType":[[self.expenditureItemList objectAtIndex:self.selectedIndex] objectForKey:@"value"],
                               @"applyDeptName":self.departmentLabel.text,
                               @"isLoan":self.isLoan?@"0":@"1",
                               @"budgetAmount":self.budgetAmount.text,
                               @"remark":self.remark.text,
                               @"cashContent":self.cashContent.text,
                               @"officeList":converted
                               };
    [[DYMHTTPManager sharedManager] requestWithMethod:GET
                                             WithPath:str
                                           WithParams:parameters
                                     WithSuccessBlock:^(NSDictionary *dic) {
                                         NSData *strData = dic;
                                         NSDictionary *content = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingMutableContainers error:nil];//转换数据格式
                                         NSLog(@"responseObject-->%@",content);
                                         NSDictionary *data = [content objectForKey:@"data"];
                                         [self endRefreshing];
                                         [self.loadingHelper hideCommittingView:YES];
                                         if([[data valueForKey:@"result"] intValue]==1)
                                         {
                                             UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"信息" message:@"办公申请提交成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                                             [alertview show];
                                         }
                                         
                                     }
                                      WithFailurBlock:^(NSError *error) {
                                          NSLog(@"error-->%@",error);
                                          [self endRefreshing];
                                        [self.loadingHelper hideCommittingView:YES];
                                      }];
    
}

- (IBAction)save:(id)sender {
}

- (IBAction)addOfficeListAction:(id)sender {
    OfficeInfo* officeInfo = [[OfficeInfo alloc] init];
    [self.officeListArray addObject:officeInfo];
    
    
    CGFloat view3X = self.office_ll.frame.origin.x;
    CGFloat view3Y = self.office_ll.frame.origin.y;
    
    
    if(self.heightConstraint!=nil)
    {
        [self.office_ll removeConstraint:self.heightConstraint];
    }
    
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.office_ll attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
                                                          constant:self.office_ll.frame.size.height+ 210];
    
    
    
    [self.office_ll addConstraints:@[self.heightConstraint]];
    
    
    self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height+210);
    if(self.contentHc!=nil)
    {
        [self.contentView removeConstraint:self.contentHc];
    }
    NSInteger height=self.contentView.frame.size.height;
    self.contentHc=[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
                                                 constant:self.contentView.frame.size.height];
    [self.contentView addConstraint:self.contentHc];
    
    //   self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.contentSize.height+210);
    
    //创建cell
    OfficeListCellView *officeView = [OfficeListCellView viewFromXib];
    
    
    officeView.delegate = self;
    [officeView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.office_ll addSubview:officeView];
    [officeView passViewOfficeList:self.officeListArray position:self.officeListArray.count-1 parent:self.office_ll];//在这由自己完成高度、宽度设置
    
    [self.office_ll layoutIfNeeded];
}

-(void)onNotifyMoneyChange{
    double total=0;
    for(OfficeInfo *info in self.officeListArray)
    {
        total+=[info.money doubleValue];
    }
    self.budgetAmount.text=[NSString stringWithFormat:@"%.2f",total];
}

//cell删除的回调，用于调整height的constaint
-(void)deleteOfficeListCell:(NSInteger)position
{
    //更新heightConstraint
    [self.office_ll removeConstraint:self.heightConstraint];
    [self.heightConstraint setConstant:self.office_ll.frame.size.height-210];
    [self.office_ll addConstraint:self.heightConstraint];
    
    self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height-210);
    if(self.contentHc!=nil)
        [self.contentView removeConstraint:self.contentHc];
    self.contentHc=[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
                                                 constant:self.contentView.frame.size.height];
    [self.contentView addConstraint:self.contentHc];
    
    [self.office_ll layoutIfNeeded];
    
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.contentSize.height-210);
    
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
