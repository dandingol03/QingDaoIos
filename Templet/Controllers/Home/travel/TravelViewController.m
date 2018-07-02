//
//  TravelViewController.m
//  Templet
//
//  Created by 王俊杰 on 2018/7/1.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "TravelViewController.h"
#import "CCTableDataItem.h"
#import "CCTableViewDelegate.h"
#import "CCTableViewDataSource.h"
#import "UITableView+CCUtil.h"
#import "BobLoadingHelper.h"
#import "OfficeMainTableViewCell.h"
#import "AddOfficeApplyViewController.h"
#import "BusinessApplyInfo.h"
#import "OfficeListDetailViewController.h"


@interface TravelViewController ()<UITableViewDataSource,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *lineView1;
@property (strong, nonatomic) IBOutlet UIView *lineView2;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *withoutFinishedButton;
@property (strong, nonatomic) IBOutlet UIButton *finishedButton;

@property (nonatomic, strong) CCTableDataItem *dataItem;
@property (nonatomic, strong) CCTableViewDelegate *delegate;
@property (nonatomic, strong) CCTableViewDataSource *dataSource;

@property (strong, nonatomic) NSArray *withoutFinishedInfoItems;
@property (strong, nonatomic) NSArray *finishedInfoItems;

@property(nonatomic,assign)BOOL update;

@end

@implementation TravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"差旅";
    [self setViewItem];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"fooder-bg11"] forBarMetrics:UIBarMetricsDefault];
    
    self.withoutFinishedButton.selected = YES;
    self.withoutFinishedButton.titleLabel.tintColor = [UIColor blueColor];
    self.finishedButton.titleLabel.tintColor = [UIColor blueColor];
    
    // [self combitionData];
    [self setTableView];
    self.isAutoReloadData = YES;
    [self addRefreshHeaderView];
    [self addLoadMoreFooterView];
    
}

-(void)setTableView{
    self.tableView.delegate = self.delegate;
    self.tableView.dataSource = self.dataSource;
    
    [self.tableView registerNibCellClasses:@[[OfficeMainTableViewCell class],
                                             ]];
    [self loadData:YES];
    
    __weak __typeof(self)weakSelf = self;
    [self.delegate setDidSelectRowAtIndexPath:^(UITableView *tableView, NSIndexPath *indexPath, id rowData, NSString *cellClassName) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        BusinessApplyInfo *data = [weakSelf.dataItem cellDataForIndexPath:indexPath];
        OfficeListDetailViewController* officeListDetailVc = [[OfficeListDetailViewController alloc]init];
        officeListDetailVc.expendId =  data.expendId;
        [weakSelf.navigationController pushViewController:officeListDetailVc animated:YES];
        
        
    }];
}


- (void)setViewItem{
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                           style:UIBarButtonItemStyleDone
                                                                          target:self
                                                                          action:@selector(addingOfficeApply)];
    rightBarButtonItem.image = [UIImage imageNamed:@"jia"];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

//右上角加号
-(void)addingOfficeApply{
    AddOfficeApplyViewController *addOfficeVc = [[AddOfficeApplyViewController alloc]init];
    addOfficeVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addOfficeVc animated:YES];
}

- (IBAction)switchOver:(UIButton *)sender {
    if (sender.tag == 1) {
        self.withoutFinishedButton.selected = YES;
        self.finishedButton.selected = NO;
        self.lineView1.backgroundColor = [UIColor blueColor];
        self.lineView2.backgroundColor = [UIColor whiteColor];
        //[self bindData];
        
    }else if (sender.tag == 2){
        self.finishedButton.selected = YES;
        self.withoutFinishedButton.selected = NO;
        self.lineView1.backgroundColor = [UIColor whiteColor];
        self.lineView2.backgroundColor = [UIColor blueColor];
        //[self bindData];
    }
}



- (void)bindData:(NSArray *)dataList
{
    @try {
        
        [self.dataItem clearData];
        if( self.withoutFinishedButton.selected){
            [self.dataItem addCellClass:[OfficeMainTableViewCell class] dataItems:dataList];
        }else{
            [self.dataItem addCellClass:[OfficeMainTableViewCell class] dataItems:self.finishedInfoItems];
        }
        
        [self.tableView reloadData];
        
    } @catch (NSException *exception) {
        DLog(@"Class = %@ Error = %@",exception,NSStringFromClass([self class]));
    } @finally {
        
    }
}

- (CCTableDataItem *)dataItem
{
    if (!_dataItem) {
        _dataItem = [CCTableDataItem dataItem];
    }
    return _dataItem;
}

- (CCTableViewDelegate *)delegate
{
    if (!_delegate) {
        _delegate = [CCTableViewDelegate delegateWithDataItem:self.dataItem];
    }
    return _delegate;
}

- (CCTableViewDataSource *)dataSource
{
    if (!_dataSource) {
        _dataSource = [CCTableViewDataSource dataSourceWithItem:self.dataItem];
    }
    return _dataSource;
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
