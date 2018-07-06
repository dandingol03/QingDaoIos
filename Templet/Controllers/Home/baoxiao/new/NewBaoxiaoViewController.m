//
//  NewBaoxiaoViewController.m
//  Templet
//
//

#import "NewBaoxiaoViewController.h"
#import "BaoxiaoInfo.h"
#import "BaoxiaoOffice.h"
#import "BaoxiaoZz.h"
#import "ApplyInitInfo.h"
#import "BaoxiaoOfficeCellView.h"
#import "BaoxiaoZzCellView.h"
#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)

@interface NewBaoxiaoViewController ()
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
@property (weak, nonatomic) IBOutlet UITextField *cash;


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

@implementation NewBaoxiaoViewController

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

- (IBAction)apply:(id)sender {
}


- (IBAction)save:(id)sender {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
