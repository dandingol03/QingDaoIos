//
//  BaoxiaoDetailViewController.m
//  Templet
//

//

#import "BaoxiaoDetailViewController.h"
#import "BaoxiaoInfo.h"
#import "BaoxiaoOffice.h"
#import "BaoxiaoZz.h"
#import "ApplyInitInfo.h"
#import "BaoxiaoOfficeCellView.h"
#import "BaoxiaoZzCellView.h"

#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)

@interface BaoxiaoDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *departmentLabel;//当前单位
@property (strong, nonatomic) IBOutlet UILabel *expenditureLabel;//支出事项
@property (weak, nonatomic) IBOutlet UITextField *reason;

@property (weak, nonatomic) IBOutlet UIView *office_ll;
@property (weak, nonatomic) IBOutlet UIView *zz_ll;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *totalNumber;
@property (weak, nonatomic) IBOutlet UILabel *totalAmount;
@property (weak, nonatomic) IBOutlet UITextField *offCard;


@property (nonatomic ,strong) NSDictionary * expenditureItemMap;//支出事项弹框
@property (nonatomic ,strong) NSArray * expenditureItemArray;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL isFold;//是否折叠附件

@property(strong,nonatomic) NSMutableArray *officeListArray;
@property(strong,nonatomic) NSMutableArray *zzListArray;

@property(strong,nonatomic) BaoxiaoInfo *info;
@property(strong,nonatomic) NSLayoutConstraint *heightConstraint;
@property(strong,nonatomic) NSLayoutConstraint *contentHc;




@end

@implementation BaoxiaoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"fooder-bg11"] forBarMetrics:UIBarMetricsDefault];
    self.officeListArray=[[NSMutableArray alloc] init];
    self.zzListArray=[[NSMutableArray alloc] init];
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
    [self getBaoxiaoDetailInfo:self.reimbId];
}

-(void)getBaoxiaoDetailInfo:(NSString *)reimbId{
    
    [self.loadingHelper showCommittingView:self.view withTitle:@"loading" animated:YES];
    NSString* str = @""HTTP_SERVER"/m_getBaoxiaoDetail.do";
    //构造参数
    AppDelegate* appDelegate = [AppDelegate shareDelegate];
    NSString* personId = appDelegate.personId;
    NSDictionary *parameters=@{@"personId":personId,@"expendId":reimbId};
    [[DYMHTTPManager sharedManager] requestWithMethod:GET
                                             WithPath:str
                                           WithParams:parameters
                                     WithSuccessBlock:^(NSDictionary *dic) {
                                         NSData *strData = dic;
                                         NSDictionary *content = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingMutableContainers error:nil];//转换数据格式
                                         NSLog(@"responseObject-->%@",content);
                                         NSDictionary *data = [content objectForKey:@"data"];
                                         self.info = [BaoxiaoInfo objectWithKeyValues:data];
                                         NSMutableArray *array = [[content objectForKey:@"data"] objectForKey:@"dataList"];
                                         self.officeListArray = [BaoxiaoInfo objectArrayWithKeyValuesArray:array];
                                         [self endRefreshing];
                                         [self.loadingHelper hideCommittingView:YES];
                                         
                                         [self setDefaultInfo:self.info];
                                         [self initOfficeList:self.officeListArray];
                                         
                                     }
                                      WithFailurBlock:^(NSError *error) {
                                          NSLog(@"error-->%@",error);
                                          [self endRefreshing];
                                           [self.loadingHelper hideCommittingView:YES];
                                      }];
    
}

-(void)setDefaultInfo:(BaoxiaoInfo*)info{
    self.expenditureLabel.text = info.expendType;
    self.departmentLabel.text = info.applyDeptName;
    //self.budgetAmountField.text = [NSString stringWithFormat:@"%@", info.budgetAmount];
    self.reason.text = info.reason;
    
 
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
        
        for(BaoxiaoOffice* info in officeListArray){
            
            BaoxiaoOfficeCellView *baoxiaoOfficeView = [BaoxiaoOfficeCellView viewFromXib];
            
            
            baoxiaoOfficeView.delegate = self;
            [baoxiaoOfficeView setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            [self.office_ll addSubview:baoxiaoOfficeView];
            [baoxiaoOfficeView passViewOfficeList:officeListArray position:officeListArray.count-1 parent:self.office_ll];//在这由自己完成高度、宽度设置
            [baoxiaoOfficeView setDefaultText:info];
            
        }
        [self.office_ll layoutIfNeeded];
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

- (IBAction)addOfficeItemAction:(id)sender {
    BaoxiaoOffice* officeInfo = [[BaoxiaoOffice alloc] init];
    [self.officeListArray addObject:officeInfo];
    
    
    CGFloat view3X = self.office_ll.frame.origin.x;
    CGFloat view3Y = self.office_ll.frame.origin.y;
    
    
    if(self.heightConstraint!=nil)
    {
        [self.office_ll removeConstraint:self.heightConstraint];
    }
    
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.office_ll attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
                                                          constant:self.office_ll.frame.size.height+ 60];
    
    
    
    [self.office_ll addConstraints:@[self.heightConstraint]];
    
    
    self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height+60);
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
    BaoxiaoOfficeCellView *baoxiaoOfficeView = [BaoxiaoOfficeCellView viewFromXib];
    
    
    baoxiaoOfficeView.delegate = self;
    [baoxiaoOfficeView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.office_ll addSubview:baoxiaoOfficeView];
    [baoxiaoOfficeView passViewOfficeList:self.officeListArray position:self.officeListArray.count-1 parent:self.office_ll];//在这由自己完成高度、宽度设置
    
    [self.office_ll layoutIfNeeded];
    
}

- (IBAction)addZzItemAction:(id)sender {
    BaoxiaoZz* zzInfo = [[BaoxiaoZz alloc] init];
    [self.zzListArray addObject:zzInfo];
    
    
    CGFloat view3X = self.zz_ll.frame.origin.x;
    CGFloat view3Y = self.zz_ll.frame.origin.y;
    
    
    if(self.heightConstraint!=nil)
    {
        [self.zz_ll removeConstraint:self.heightConstraint];
    }
    
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.zz_ll attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
                                                          constant:self.zz_ll.frame.size.height+ 100];
    
    
    [self.zz_ll addConstraints:@[self.heightConstraint]];
    
    
    self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height+100);
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
    BaoxiaoZzCellView *baoxiaoZzView = [BaoxiaoZzCellView viewFromXib];
    
    
    baoxiaoZzView.delegate = self;
    [baoxiaoZzView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.zz_ll addSubview:baoxiaoZzView];
    [baoxiaoZzView passViewOfficeList:self.zzListArray position:self.zzListArray.count-1 parent:self.zz_ll];//在这由自己完成高度、宽度设置
    
    [self.zz_ll layoutIfNeeded];
}


//cell删除的回调，用于调整height的constaint
-(void)deleteOfficeListCell:(NSInteger)position
{
    //更新heightConstraint
    [self.office_ll removeConstraint:self.heightConstraint];
    [self.heightConstraint setConstant:self.office_ll.frame.size.height-60];
    [self.office_ll addConstraint:self.heightConstraint];
    
    self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height-60);
    if(self.contentHc!=nil)
        [self.contentView removeConstraint:self.contentHc];
    self.contentHc=[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
                                                 constant:self.contentView.frame.size.height];
    [self.contentView addConstraint:self.contentHc];
    
    [self.office_ll layoutIfNeeded];
    
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.contentSize.height-60);
    
}

-(void)deleteZzItem:(NSInteger)position
{
    [self.zz_ll removeConstraint:self.heightConstraint];
    [self.heightConstraint setConstant:self.zz_ll.frame.size.height-100];
    [self.zz_ll addConstraint:self.heightConstraint];
    
    self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height-100);
    if(self.contentHc!=nil)
        [self.contentView removeConstraint:self.contentHc];
    self.contentHc=[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
                                                 constant:self.contentView.frame.size.height];
    [self.contentView addConstraint:self.contentHc];
    
    [self.zz_ll layoutIfNeeded];
    
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.contentSize.height-100);
}

-(void)onNotifyChange{
    int numberTotal=0;
    double amountTotal=0;
    for(BaoxiaoOffice *info in self.officeListArray)
    {
        amountTotal+=[info.amount doubleValue];
        numberTotal+=[info.number intValue];
    }
    self.totalNumber.text=[NSString stringWithFormat:@"%d",numberTotal];
    self.totalAmount.text=[NSString stringWithFormat:@"%.2f",amountTotal];
   
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
