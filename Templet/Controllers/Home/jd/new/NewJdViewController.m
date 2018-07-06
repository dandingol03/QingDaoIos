//
//  NewJdViewController.m
//  Templet
//
//

#import "NewJdViewController.h"
#import "JdInfo.h"
#import "ApplyInitInfo.h"

@interface NewJdViewController ()
@property (strong, nonatomic) IBOutlet UILabel *departmentLabel;//当前单位

@property (nonatomic, assign) BOOL isLoan;//是否借款 0是，1否
@property (strong, nonatomic) IBOutlet UIImageView *isLoanImag_y;//需要借款
@property (strong, nonatomic) IBOutlet UIButton *yesBtn;
@property (strong, nonatomic) IBOutlet UIImageView *isLoanImag_n;//不需要借款
@property (strong, nonatomic) IBOutlet UIButton *noBtn;

@property (nonatomic, assign) NSString *jdtype;//是否借款 0是，1否
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



@property(strong,nonatomic) JdInfo* info;
@end

@implementation NewJdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加";
    self.labelNameAndPost.text=@"来宾姓名\n职务:";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"fooder-bg11"] forBarMetrics:UIBarMetricsDefault];
}

- (IBAction)onContentChange:(id)sender {
    switch ([sender tag]) {
        case 1:
        {
            self.info.visitorNum=[NSNumber numberWithInt:[self.visitorNum.text intValue]];
        }
            break;
        case 2:
        {
            self.info.accompanyNum=[NSNumber numberWithInt:[self.accompanyNum.text intValue]];
        }
            break;
        case 3:
        {
            self.info.letterNo=self.letterNo.text;
        }
            break;
        case 4:
        {
            self.info.guestUnit=self.guestUnit.text;
        }
            break;
        case 5:
        {
            self.info.nameAndPost=self.nameAndPost.text;
        }
            break;
        case 6:
        {
            self.info.activityContent=self.activityContent.text;
        }
            break;
        case 7:
        {
            self.info.jc_time=self.jc_time.text;
        }
            break;
        case 8:
        {
            self.info.jc_address=self.jc_address.text;
        }
            break;
        case 9:
        {
            self.info.zs_address=self.zs_address.text;
        }
            break;
        case 10:
        {
            self.info.zs_days=self.zs_days.text;
        }
            break;
        case 11:
        {
            self.info.jdzs_money=self.jdzs_money.text;
        }
            break;
        case 12:
        {
            self.info.jdhs_money=self.jdhs_money.text;
        }
            break;
        case 13:
        {
            self.info.jdqt_money=self.jdqt_money.text;
        }
            break;
        case 14:
        {
            self.info.remark=self.remark.text;
        }
            break;
        default:
            break;
    }
}

- (IBAction)onClick:(UIButton*)sender {
    switch (sender.tag) {
        case 15:{
            self.isLoan = YES;
            self.isLoanImag_y.image = [UIImage imageNamed:@"checkbox_s"];
            self.isLoanImag_n.image = [UIImage imageNamed:@"checkbox_n"];
        }
            break;
            
        case 16:{
            self.isLoan = NO;
            self.isLoanImag_y.image = [UIImage imageNamed:@"checkbox_n"];
            self.isLoanImag_n.image = [UIImage imageNamed:@"checkbox_s"];
        }
            break;
        case 17:{
            self.jdtype = @"0";
            self.isBusinessImag_y.image = [UIImage imageNamed:@"checkbox_s"];
            self.isInvestmentImag_n.image = [UIImage imageNamed:@"checkbox_n"];
        }
            break;
        case 18:{
            self.jdtype = @"1";
            self.isInvestmentImag_n.image = [UIImage imageNamed:@"checkbox_s"];
            self.isBusinessImag_y.image = [UIImage imageNamed:@"checkbox_n"];
        }
            break;
        case 19:{
            self.isYj = @"是";
            self.isYjImag_y.image = [UIImage imageNamed:@"checkbox_s"];
            self.noYjImag_n.image = [UIImage imageNamed:@"checkbox_n"];
        }
            break;
        case 20:{
            self.isYj = @"否";
            self.noYjImag_n.image = [UIImage imageNamed:@"checkbox_s"];
            self.isYjImag_y.image = [UIImage imageNamed:@"checkbox_n"];
        }
            break;
            
        default:
            break;
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)apply:(id)sender {
}


- (IBAction)save:(id)sender {
}


@end
