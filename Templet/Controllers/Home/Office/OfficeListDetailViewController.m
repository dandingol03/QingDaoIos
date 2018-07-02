//
//  OfficeListDetailViewController.m
//  Templet
//
//  Created by 丁一明 on 2018/6/30.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "OfficeListDetailViewController.h"
#import "OfficeDetailInfo.h"
#import "OfficeInfo.h"
#import "ApplyInitInfo.h"

#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)

@interface OfficeListDetailViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view11;
@property (strong, nonatomic) IBOutlet UIView *view12;
@property (strong, nonatomic) IBOutlet UIView *view13;
@property (strong, nonatomic) IBOutlet UIView *view14;
@property (strong, nonatomic) IBOutlet UIView *view21;
@property (strong, nonatomic) IBOutlet UIView *view22;
@property (strong, nonatomic) IBOutlet UIView *view41;
@property (strong, nonatomic) IBOutlet UIView *view42;
@property (strong, nonatomic) IBOutlet UIView *view43;
@property (strong, nonatomic) IBOutlet UIView *view44;

@property (strong, nonatomic) IBOutlet UILabel *expenditureLabel;//支出事项
@property (strong, nonatomic) IBOutlet UILabel *departmentLabel;//当前单位
@property (strong, nonatomic) IBOutlet UITextField *budgetAmountField;//预算金额

@property (strong, nonatomic) IBOutlet UIImageView *isLoanImag_y;//需要借款
@property (strong, nonatomic) IBOutlet UIButton *yesBtn;
@property (strong, nonatomic) IBOutlet UIImageView *isLoanImag_n;//不需要借款
@property (strong, nonatomic) IBOutlet UIButton *noBtn;

@property (strong, nonatomic) IBOutlet UITextField *cashContentField;//用款内容
@property (strong, nonatomic) IBOutlet UITextField *remarkField;//备注

@property (nonatomic, assign) BOOL isLoan;//是否借款 0是，1否

@property (nonatomic ,strong) NSDictionary * expenditureItemMap;//支出事项弹框
@property (nonatomic ,strong) NSArray * expenditureItemArray;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) BOOL isFold;//是否折叠附件

//officeList
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *viewCell;

@property (strong, nonatomic) IBOutlet UIView *view4;
@property (strong, nonatomic) IBOutlet UIView *view5;
@property (strong, nonatomic) IBOutlet UIView *imageViewArea;

@property (nonatomic ,assign) NSInteger viewCellTag;
@property (nonatomic, strong) NSMutableArray * officeListArray;
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
    
    self.viewCellTag = -1;
    [self getApplyInfo];
    [self getDetailInfo:self.expendId];
    self.isFold = NO;
    
    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1300);
    self.view1.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, 200);
    self.view11.frame = CGRectMake(0, 0, self.view1.frame.size.width, 48);
    self.view12.frame = CGRectMake(0, 50, self.view1.frame.size.width, 48);
    self.view13.frame = CGRectMake(0, 100, self.view1.frame.size.width, 48);
    self.view14.frame = CGRectMake(0, 150, self.view1.frame.size.width, 48);
    
    self.view2.frame = CGRectMake(10, 215, SCREEN_WIDTH-20, 100);
    self.view21.frame = CGRectMake(0, 0,self.view2.frame.size.width, 48);
    self.view22.frame = CGRectMake(0, 50,self.view2.frame.size.width, 48);
    self.view3.frame = CGRectMake(10, 325, SCREEN_WIDTH-20, 0);
    self.view4.frame = CGRectMake(10, self.view3.frame.origin.y+self.view3.frame.size.height, SCREEN_WIDTH-20, 340);
    self.view41.frame = CGRectMake(0, 0, self.view4.frame.size.width, 50);
    self.view42.frame = CGRectMake(40, 60, self.view4.frame.size.width-80, 50);
    self.view43.frame = CGRectMake(0, 125, self.view4.frame.size.width, 50);
    self.view44.frame = CGRectMake(0, 190, self.view4.frame.size.width, 110);
}

-(void)getApplyInfo{
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


-(void)initOfficeList:(NSMutableArray*)officeListArray{
    CGFloat view3X = self.view3.frame.origin.x;
    CGFloat view3Y = self.view3.frame.origin.y;
    NSInteger count = self.officeListArray.count;
    self.view3.frame = CGRectMake(view3X,view3Y,ScreenWidth-20, self.view3.frame.size.height+210*count);
    self.view4.frame = CGRectMake(view3X,view3Y+self.view3.frame.size.height+20, ScreenWidth-20, 340);
    self.view5.frame = CGRectMake(view3X, self.view4.frame.origin.y+340+10, ScreenWidth-20, 60);
    self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height+210*count);
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.contentSize.height+210*count+20);
    if(self.officeListArray!=nil&&self.officeListArray.count!=0){
        self.viewCellTag = self.viewCellTag+1;
        for(OfficeInfo* listInfo in self.officeListArray){
            if(self.viewCellTag==0){
                self.viewCell = [[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth-40, 200)];
                self.viewCell.tag = self.viewCellTag;
                OfficeListCellView *officeListCellView = [OfficeListCellView viewFromXib];
                officeListCellView.delegate = self;
                [officeListCellView passViewOfficeList:self.officeListArray position:self.viewCellTag];
                [officeListCellView setDefaultText:listInfo];
                [self.viewCell addSubview:officeListCellView];
                [self.view3 addSubview:self.viewCell];
            }else{
                OfficeListCellView *officeListCellView = [OfficeListCellView viewFromXib];
                officeListCellView.delegate = self;
                [officeListCellView passViewOfficeList:self.officeListArray position:self.viewCellTag];
                [officeListCellView setDefaultText:listInfo];
                [self.view3 addSubview:officeListCellView];
            }
           
        }
    }
    
}

- (IBAction)addOfficeListAction:(id)sender {
    OfficeInfo* officeInfo = [[OfficeInfo alloc] init];
    [self.officeListArray addObject:officeInfo];
    self.viewCellTag = self.viewCellTag+1;
    if(self.viewCellTag == 0){
        CGFloat view3X = self.view3.frame.origin.x;
        CGFloat view3Y = self.view3.frame.origin.y;
        self.view3.frame = CGRectMake(view3X, view3Y, ScreenWidth-20, self.view3.frame.size.height+210);
        self.view4.frame = CGRectMake(view3X, view3Y+self.view3.frame.size.height+20, ScreenWidth-20, 200);
        self.view5.frame = CGRectMake(view3X, self.view4.frame.origin.y+200, ScreenWidth-20, 60);
        self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height+210);
        self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.contentSize.height+210);
        
        self.viewCell = [[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth-40, 200)];
        self.viewCell.tag = self.viewCellTag;
        OfficeListCellView *officeListCellView = [OfficeListCellView viewFromXib];
        officeListCellView.delegate = self;
        [officeListCellView passViewOfficeList:self.officeListArray position:self.viewCellTag];
        [self.viewCell addSubview:officeListCellView];
        [self.view3 addSubview:self.viewCell];
    }else{
        CGFloat view3X = self.view3.frame.origin.x;
        CGFloat view3Y = self.view3.frame.origin.y;
        self.view3.frame = CGRectMake(view3X, view3Y, ScreenWidth-20, self.view3.frame.size.height+210);
        self.view4.frame = CGRectMake(view3X, view3Y+self.view3.frame.size.height+20, ScreenWidth-20, 200);
        self.view5.frame = CGRectMake(view3X, self.view4.frame.origin.y+200, ScreenWidth-20, 60);
        self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height+210);
        self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.contentSize.height+210);
        
        
        OfficeListCellView *officeListCellView = [OfficeListCellView viewFromXib];
        officeListCellView.delegate = self;
        [officeListCellView passViewOfficeList:self.officeListArray position:self.viewCellTag];
        
        [self.view3 addSubview:officeListCellView];
    }
}


//OfficeListCellView delegate 方法
-(void)deleteOfficeListCell:(NSInteger)position
{
    if(position==0){
        [self.viewCell removeFromSuperview];
        CGFloat view3X = self.view3.frame.origin.x;
        CGFloat view3Y = self.view3.frame.origin.y;
        self.view3.frame = CGRectMake(view3X, view3Y, ScreenWidth-20, self.view3.frame.size.height-200);
        self.view4.frame = CGRectMake(view3X, view3Y+self.view3.frame.size.height+10, ScreenWidth-20, 200);
        self.view5.frame = CGRectMake(view3X, self.view4.frame.origin.y+200, ScreenWidth-20, 60);
        
        self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height-200);
        self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.contentSize.height-200);
        self.viewCellTag = self.viewCellTag-1;
    }else{
        CGFloat view3X = self.view3.frame.origin.x;
        CGFloat view3Y = self.view3.frame.origin.y;
        self.view3.frame = CGRectMake(view3X, view3Y, ScreenWidth-20, self.view3.frame.size.height-210);
        self.view4.frame = CGRectMake(view3X, view3Y+self.view3.frame.size.height+20, ScreenWidth-20, 200);
        self.view5.frame = CGRectMake(view3X, self.view4.frame.origin.y+200, ScreenWidth-20, 60);
        
        self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height-210);
        self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.contentSize.height-210);
        self.viewCellTag = self.viewCellTag-1;
    }
}


- (IBAction)saveModifyAction:(id)sender {
}

- (IBAction)foldImageView:(id)sender {
    CGFloat x = self.imageViewArea.frame.origin.x;
    CGFloat y = self.imageViewArea.frame.origin.y;
    CGFloat view4X = self.view4.frame.origin.x;
    CGFloat view4Y = self.view4.frame.origin.y;
    if(self.isFold == YES){
        self.isFold = NO;
        self.imageViewArea.frame = CGRectMake(x, y, ScreenWidth-20, 110);
        self.view4.frame = CGRectMake(view4X,view4Y, ScreenWidth-20, 340);
        self.view5.frame = CGRectMake(view4X,view4Y+340+10, ScreenWidth-20, 60);
    }else{
        self.isFold = YES;
        self.imageViewArea.frame = CGRectMake(x, y, ScreenWidth-20, 0);
        self.view4.frame = CGRectMake(view4X, view4Y, ScreenWidth-20, 340-110);
        self.view5.frame = CGRectMake(view4X, view4Y+340+10-110, ScreenWidth-20, 60);
    }
}

- (IBAction)submmitAction:(id)sender {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
