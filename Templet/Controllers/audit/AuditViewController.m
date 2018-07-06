//
//  AuditViewController.m
//  Templet
//
//

#import "AuditViewController.h"
#import "OfficeDetailInfo.h"
#import "OfficeInfo.h"
#import "AuditApplyListViewController.h"

#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)



@interface AuditViewController ()

@end

@implementation AuditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (IBAction)onClick:(id)sender {
    switch ([sender tag]) {
        case 1:
        {
            AuditApplyListViewController *todoListVc = [[AuditApplyListViewController alloc]init];
            [self.navigationController pushViewController:todoListVc animated:YES];
        }
            break;
        case 2:
        {
            
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


@end
