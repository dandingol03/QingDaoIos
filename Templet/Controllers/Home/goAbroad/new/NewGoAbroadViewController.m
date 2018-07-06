//
//  NewGoAbroadViewController.m
//  Templet
//
//

#import "NewGoAbroadViewController.h"
#import "GoAbroadInfo.h"
#import "ApplyInitInfo.h"



@interface NewGoAbroadViewController ()
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


@property(strong,nonatomic) GoAbroadInfo* info;
@end

@implementation NewGoAbroadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加";
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"fooder-bg11"] forBarMetrics:UIBarMetricsDefault];
    
   
}

- (IBAction)onContentChange:(id)sender {
    switch ([sender tag]) {
        case 1:
        {
            self.info.groupName=self.groupName.text;
        }
            break;
        case 2:
        {
            self.info.groupUnit=self.groupUnit.text;
        }
            break;
        case 3:
        {
            self.info.colonel=self.colonel.text;
        }
            break;
        case 4:
        {
            self.info.groupNum=self.groupNum.text;
        }
            break;
        case 5:
        {
            self.info.visitingCountry=self.visitingCountry.text;
        }
            break;
        case 6:
        {
            self.info.visitingDay=self.visitingDay.text;
        }
            break;
        case 7:
        {
            self.info.ht_money=[NSNumber numberWithDouble:[self.ht_money.text doubleValue]];
        }
            break;
        case 8:
        {
             self.info.zs_money=[NSNumber numberWithDouble:[self.zs_money.text doubleValue]];
        }
            break;
        case 9:
        {
            self.info.hs_money=[NSNumber numberWithDouble:[self.hs_money.text doubleValue]];
        }
            break;
        case 10:
        {
            self.info.jt_money=[NSNumber numberWithDouble:[self.jt_money.text doubleValue]];
        }
            break;
        case 11:
        {
            self.info.hs_money=[NSNumber numberWithDouble:[self.hs_money.text doubleValue]];
        }
            break;
        case 12:
        {
            self.info.qt_money=[NSNumber numberWithDouble:[self.qt_money.text doubleValue]];
        }
            break;
        default:
            break;
    }
}

- (IBAction)onClick:(UIButton*)sender {
    switch (sender.tag) {
        case 13:{
            self.isLoan = YES;
            self.isLoanImag_y.image = [UIImage imageNamed:@"checkbox_s"];
            self.isLoanImag_n.image = [UIImage imageNamed:@"checkbox_n"];
        }
            break;
            
        case 14:{
            self.isLoan = NO;
            self.isLoanImag_y.image = [UIImage imageNamed:@"checkbox_n"];
            self.isLoanImag_n.image = [UIImage imageNamed:@"checkbox_s"];
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
