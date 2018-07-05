//
//  NewTravelViewController.m
//  Templet
//
//

#import "NewTravelViewController.h"
#import "OfficeDetailInfo.h"
#import "TravelInfo.h"
#import "ApplyInitInfo.h"
#import "TravelInfoCellView.h"


@interface NewTravelViewController ()
@property (weak, nonatomic) IBOutlet UIView *travel_ll;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)

@property (strong, nonatomic) IBOutlet UILabel *departmentLabel;//当前单位

@property (nonatomic, assign) BOOL isLoan;//是否借款 0是，1否

@property (strong, nonatomic) IBOutlet UIImageView *isLoanImag_y;//需要借款
@property (strong, nonatomic) IBOutlet UIButton *yesBtn;
@property (strong, nonatomic) IBOutlet UIImageView *isLoanImag_n;//不需要借款
@property (strong, nonatomic) IBOutlet UIButton *noBtn;


@property (nonatomic ,strong) NSDictionary * expenditureItemMap;//支出事项弹框
@property (nonatomic ,strong) NSArray * expenditureItemArray;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL isFold;//是否折叠附件

@property (nonatomic ,strong) NSMutableArray * travelListArray;
@property (nonatomic ,strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic ,strong) NSLayoutConstraint *contentHc;



@property(strong,nonatomic) OfficeDetailInfo* info;
@end

@implementation NewTravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"fooder-bg11"] forBarMetrics:UIBarMetricsDefault];
    
    self.travelListArray=[[NSMutableArray alloc] init];
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

- (IBAction)addTravelItemAction:(id)sender {
    OfficeInfo* officeInfo = [[OfficeInfo alloc] init];
    [self.travelListArray addObject:officeInfo];
    
    
    CGFloat view3X = self.travel_ll.frame.origin.x;
    CGFloat view3Y = self.travel_ll.frame.origin.y;
    
    
    if(self.heightConstraint!=nil)
    {
        [self.travel_ll removeConstraint:self.heightConstraint];
    }
    
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.travel_ll attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
                                                     constant:self.travel_ll.frame.size.height+ 990];
    
    
    
    [self.travel_ll addConstraints:@[self.heightConstraint]];
    
    
    self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height+990);
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
    TravelInfoCellView *travelView = [TravelInfoCellView viewFromXib];
    
    
    travelView.delegate = self;
    [travelView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.travel_ll addSubview:travelView];
    [travelView passViewOfficeList:self.travelListArray position:self.travelListArray.count-1 parent:self.travel_ll];//在这由自己完成高度、宽度设置
    
    
    [self.travel_ll layoutIfNeeded];
    
}

//cell删除的回调，用于调整height的constaint
-(void)deleteTravelItem:(NSInteger)position
{
    //更新heightConstraint
    [self.travel_ll removeConstraint:self.heightConstraint];
    [self.heightConstraint setConstant:self.travel_ll.frame.size.height-990];
    [self.travel_ll addConstraint:self.heightConstraint];
    
    self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height-990);
    if(self.contentHc!=nil)
        [self.contentView removeConstraint:self.contentHc];
    self.contentHc=[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
                                            constant:self.contentView.frame.size.height];
    [self.contentView addConstraint:self.contentHc];
    
    [self.travel_ll layoutIfNeeded];
    
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.contentSize.height-990);
    
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
