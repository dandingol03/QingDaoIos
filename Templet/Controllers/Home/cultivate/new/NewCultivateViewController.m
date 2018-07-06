//
//  NewCultivateViewController.m
//  Templet
//
//

#import "NewCultivateViewController.h"
#import "ConferenceInfo.h"
#import "CultivateInfo.h"
#import "ApplyInitInfo.h"


@interface NewCultivateViewController ()
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
@property (weak, nonatomic) IBOutlet UILabel *trainNumLabel;

@property(strong,nonatomic) CultivateInfo* info;
@end

@implementation NewCultivateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加";
    self.trainNumLabel.text=@"预计参训\n人数:";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"fooder-bg11"] forBarMetrics:UIBarMetricsDefault];
    
    
}

- (IBAction)onLoanChange:(id)sender {
    switch ([sender tag]) {
        case 1:
        {
            self.info.isLoan=@"0";
        }
            break;
        case 2:
        {
            self.info.isLoan=@"1";
        }
        default:
            break;
    }
}

- (IBAction)onInfoChange:(id)sender {
    switch ([sender tag]) {
        case 3:
        {
            self.info.trainName=self.trainName.text;
        }
            break;
        case 4:
        {
            self.info.trainTime=self.trainTime.text;
        }
            break;
        case 5:
        {
            self.info.trainEnd=self.trainEnd.text;
        }
            break;
        case 6:
        {
            self.info.trainReport=self.trainReport.text;
        }
            break;
        case 7:
        {
            self.info.trainLeave=self.trainLeave.text;
        }
            break;
        case 8:
        {
            self.info.trainPlace=self.trainPlace.text;
        }
            break;
        case 9:
        {
            self.info.trainBudget=self.trainBudget.text;
        }
            break;
        case 10:
        {
            self.info.trainNum=[NSNumber numberWithInt: [self.trainNum.text intValue]];
        }
            break;
        case 11:
        {
            self.info.trainObject=self.trainObject.text;
        }
            break;
        case 12:
        {
            self.info.trainStaffNum=[NSNumber numberWithInt:[self.trainStaffNum.text intValue]];
        }
            break;
            
        default:
            break;
    }
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
