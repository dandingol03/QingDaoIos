//
//  VerifyMainViewController.m
//  Templet
//
//

#import "VerifyMainViewController.h"
#import "OfficeDetailInfo.h"
#import "OfficeInfo.h"
#import "OfficeListDetailViewController.h"
#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)

@interface VerifyMainViewController ()
@property (weak, nonatomic) IBOutlet UIView *office_ll;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *view8;
@property (weak, nonatomic) IBOutlet UIView *view9;

@end

@implementation VerifyMainViewController

NSMutableArray * officeListArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addOfficeListAction:(id)sender {
    OfficeInfo* officeInfo = [[OfficeInfo alloc] init];
    [officeListArray addObject:officeInfo];
    
    
    CGFloat view3X = self.office_ll.frame.origin.x;
    CGFloat view3Y = self.office_ll.frame.origin.y;
    
    
    [self.office_ll addConstraint:[NSLayoutConstraint constraintWithItem:self.office_ll attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.office_ll.frame.size.height+210]];
  
    self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height+210);
//    self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.contentSize.height+210);
    

    OfficeListCellView *officeView = [OfficeListCellView viewFromXib];
    officeView.frame= CGRectMake(view3X, view3Y, self.office_ll.frame.size.width, 210);
    
    
    //officeListCellView.delegate = self;
    [officeView passViewOfficeList:officeListArray position:0];
    [self.office_ll addSubview:officeView];
   
    [self.office_ll layoutIfNeeded];



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
