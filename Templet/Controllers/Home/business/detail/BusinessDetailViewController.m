//
//  TravelDetailViewController.m
//  Templet
//
//

#import "BusinessDetailViewController.h"
#import "OfficeDetailInfo.h"
#import "OfficeInfo.h"
#import "ApplyInitInfo.h"
#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)

@interface BusinessDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *office_ll;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UILabel *expenditureLabel;//支出事项
@property (strong, nonatomic) IBOutlet UILabel *departmentLabel;//当前单位
@property (strong, nonatomic) IBOutlet UITextField *budgetAmountField;//预算金额

@property (strong, nonatomic) IBOutlet UITextField *cashContentField;//用款内容
@property (strong, nonatomic) IBOutlet UITextField *remarkField;//备注

@property (nonatomic, assign) BOOL isLoan;//是否借款 0是，1否

@property (strong, nonatomic) IBOutlet UIImageView *isLoanImag_y;//需要借款
@property (strong, nonatomic) IBOutlet UIButton *yesBtn;
@property (strong, nonatomic) IBOutlet UIImageView *isLoanImag_n;//不需要借款
@property (strong, nonatomic) IBOutlet UIButton *noBtn;


@property (nonatomic ,strong) NSDictionary * expenditureItemMap;//支出事项弹框
@property (nonatomic ,strong) NSArray * expenditureItemArray;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL isFold;//是否折叠附件

@property(strong,nonatomic) NSMutableArray *officeListArray;
@property(strong,nonatomic) OfficeDetailInfo *info;
@property(strong,nonatomic) NSLayoutConstraint *heightConstraint;
@property(strong,nonatomic) NSLayoutConstraint *contentHc;

@end

@implementation BusinessDetailViewController



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
    NSArray* expenditureItemList = initInfo.zhichuList;//支出事项
    NSMutableArray* expkey = [NSMutableArray array];
    NSMutableArray* expValue = [NSMutableArray array];
    for(NSDictionary *obj in expenditureItemList){
        expkey = [expkey arrayByAddingObject:[obj objectForKey:@"value"]];
        expValue = [expValue arrayByAddingObject:[obj objectForKey:@"key"]];
    }
    _expenditureItemMap = [NSDictionary dictionaryWithObjects:expValue forKeys:expkey];
    _expenditureItemArray = expValue;
    
    NSArray* depList = initInfo.depList;//当前部门
    NSDictionary* dep = [depList objectAtIndex:0];
    self.departmentLabel.text = [dep objectForKey:@"deptName"];
    self.isFold=NO;
    
    //拉取详情
    [self getBusinessDetailInfo:self.expendId];
}

-(void)getBusinessDetailInfo:(NSString *)expendId{
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
                                         self.officeListArray = [OfficeInfo objectArrayWithKeyValuesArray:array];
                                         [self endRefreshing];
                                         [self.loadingHelper hideCommittingView:YES];
                                         
                                         [self setDefaultInfo:self.info];
                                         [self initOfficeList:self.officeListArray];
                                         
                                     }
                                      WithFailurBlock:^(NSError *error) {
                                          NSLog(@"error-->%@",error);
                                          [self endRefreshing];
                                      }];
    
}

-(void)initOfficeList:(NSMutableArray*)officeListArray{
   
    NSInteger count = officeListArray.count;
  
    //添加office_ll的高度约束
    if(self.heightConstraint!=nil)
    {
        [self.office_ll removeConstraint:self.heightConstraint];
    }
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.office_ll attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
                                                     constant:self.office_ll.frame.size.height+ 210*count];
    [self.office_ll addConstraints:@[self.heightConstraint]];
    
    
    self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height+210*count);
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.contentSize.height+210*count+20);
    //添加contentView的高度约束
    if(self.contentHc!=nil)
    {
        [self.contentView removeConstraint:self.contentHc];
    }
    NSInteger height=self.contentView.frame.size.height;
    self.contentHc=[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
                                            constant:self.contentView.frame.size.height];
    [self.contentView addConstraint:self.contentHc];
    
    
    if(officeListArray!=nil&&officeListArray.count!=0){
        
        for(OfficeInfo* listInfo in officeListArray){
            
            OfficeListCellView *officeView = [OfficeListCellView viewFromXib];
            
            
            officeView.delegate = self;
            [officeView setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            [self.office_ll addSubview:officeView];
            [officeView passViewOfficeList:officeListArray position:officeListArray.count-1 parent:self.office_ll];//在这由自己完成高度、宽度设置
            [officeView setDefaultText:listInfo];
            
        }
        [self.office_ll layoutIfNeeded];
    }
    
}


-(void)setDefaultInfo:(OfficeDetailInfo*)officeInfo{
    self.expenditureLabel.text = officeInfo.expendType;
    self.departmentLabel.text = officeInfo.applyDeptName;
    self.budgetAmountField.text = [NSString stringWithFormat:@"%@", officeInfo.budgetAmount];
    self.cashContentField.text = officeInfo.cashContent;
    self.remarkField.text = officeInfo.remarks;
    self.isLoan = officeInfo.isLoan;
    if(self.isLoan == YES){
        self.isLoanImag_y.image = [UIImage imageNamed:@"checkbox_s"];
        self.isLoanImag_n.image = [UIImage imageNamed:@"checkbox_n"];
    }else{
        self.isLoanImag_y.image = [UIImage imageNamed:@"checkbox_n"];
        self.isLoanImag_n.image = [UIImage imageNamed:@"checkbox_s"];
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
