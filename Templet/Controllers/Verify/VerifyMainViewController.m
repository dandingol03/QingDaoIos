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
NSLayoutConstraint *heightConstraint;

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
    
  
    if(heightConstraint!=nil)
    {
            [self.office_ll removeConstraint:heightConstraint];
    }
    
    heightConstraint = [NSLayoutConstraint constraintWithItem:self.office_ll attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:210];
    

    
    [self.office_ll addConstraints:@[heightConstraint]];
  
    self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height+210);
//    self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.contentSize.height+210);
    
    //创建cell
    OfficeListCellView *officeView = [OfficeListCellView viewFromXib];

    
    officeView.delegate = self;
    [officeView passViewOfficeList:officeListArray position:0];
    [officeView setTranslatesAutoresizingMaskIntoConstraints:NO];

    
    [self.office_ll addSubview:officeView];
    
    //设置left
    NSLayoutConstraint* leftConstraint =[NSLayoutConstraint constraintWithItem:officeView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.office_ll attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    //设置top
    NSLayoutConstraint* topConstraint=
    [NSLayoutConstraint constraintWithItem:officeView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.office_ll attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    //设置高度
    NSLayoutConstraint* hc=
    [NSLayoutConstraint constraintWithItem:officeView
                                 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:210];
    //设置宽度
    NSLayoutConstraint* rightConstraint=
    [NSLayoutConstraint constraintWithItem:officeView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.office_ll attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    
    [self.office_ll addConstraints:@[leftConstraint, rightConstraint, topConstraint, hc]];
    
    //[self.office_ll removeConstraint:heightConstraint];
    

    
//    leftConstraint.active=true;
//    rightConstraint.active=true;
//    topConstraint.active=true;
//    hc.active=true;
//
    
    
    [self.office_ll layoutIfNeeded];

}

//cell删除的回调，用于调整height的constaint
-(void)deleteOfficeListCell:(NSInteger)position
{
    //更新heightConstraint
    [self.office_ll removeConstraint:heightConstraint];
    [heightConstraint setConstant:self.office_ll.frame.size.height-210];
    [self.office_ll addConstraint:heightConstraint];
    
    self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height-210);
    [self.office_ll layoutIfNeeded];
    
    //self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.contentSize.height-210);

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
