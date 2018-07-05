//
//  NewConferenceViewController.m
//  Templet
//
//

#import "NewConferenceViewController.h"
#import "ConferenceInfo.h"
#import "OfficeInfo.h"
#import "ApplyInitInfo.h"



@interface NewConferenceViewController ()
@property (strong, nonatomic) IBOutlet UILabel *departmentLabel;//当前单位

@property (nonatomic, assign) BOOL isLoan;//是否借款 0是，1否
@property (strong, nonatomic) IBOutlet UIImageView *isLoanImag_y;//需要借款
@property (strong, nonatomic) IBOutlet UIButton *yesBtn;
@property (strong, nonatomic) IBOutlet UIImageView *isLoanImag_n;//不需要借款
@property (strong, nonatomic) IBOutlet UIButton *noBtn;

@property (weak, nonatomic) IBOutlet UITextField *meetingName;//会议名称
@property (weak, nonatomic) IBOutlet UITextField *meetingTime;
@property (weak, nonatomic) IBOutlet UITextField *trainEnd;
@property (weak, nonatomic) IBOutlet UITextField *trainReport;
@property (weak, nonatomic) IBOutlet UITextField *trainLeave;
@property (weak, nonatomic) IBOutlet UITextField *meetingCategory;
@property (weak, nonatomic) IBOutlet UITextField *meetingPlace;
@property (weak, nonatomic) IBOutlet UITextField *estimatedNum;
@property (weak, nonatomic) IBOutlet UITextField *staffNum;
@property (weak, nonatomic) IBOutlet UITextField *meetingReason;

@property(strong,nonatomic) ConferenceInfo* info;
@end

@implementation NewConferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    self.estimatedNum.text=@"会议预计\n人数:";
    
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
            self.info.meetingName=self.meetingName.text;
        }
            break;
        case 4:
        {
            self.info.meetingTime=self.meetingTime.text;
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
            self.info.meetingCategory=self.meetingCategory.text;
        }
            break;
        case 9:
        {
            self.info.meetingPlace=self.meetingPlace.text;
        }
            break;
        case 10:
        {
            self.info.estimatedNum=[NSNumber numberWithInt: [self.estimatedNum.text intValue]];
        }
            break;
        case 11:
        {
            self.info.meetingReason=self.meetingReason.text;
        }
            break;
        case 12:
        {
            self.info.staffNum=[NSNumber numberWithInt:[self.meetingPlace.text intValue]];
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
