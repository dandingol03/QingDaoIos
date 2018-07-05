//
//  ConferenceListViewController.m
//  Templet
//
//

#import "ConferenceListViewController.h"
#import "CCTableDataItem.h"
#import "CCTableViewDelegate.h"
#import "CCTableViewDataSource.h"
#import "UITableView+CCUtil.h"
#import "BobLoadingHelper.h"
#import "ConferenceTableViewCell.h"
#import "AddOfficeApplyViewController.h"
#import "BusinessApplyInfo.h"
#import "ConferenceDetailViewController.h"
#import "NewConferenceViewController.h"

@interface ConferenceListViewController () <UITableViewDataSource,UITableViewDataSource>
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

@implementation ConferenceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"会议";
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
    // Do any additional setup after loading the view from its nib.
}


-(void)setTableView{
    self.tableView.delegate = self.delegate;
    self.tableView.dataSource = self.dataSource;
    
    [self.tableView registerNibCellClasses:@[[ConferenceTableViewCell class],
                                             ]];
    [self loadData:YES];
    
    __weak __typeof(self)weakSelf = self;
    [self.delegate setDidSelectRowAtIndexPath:^(UITableView *tableView, NSIndexPath *indexPath, id rowData, NSString *cellClassName) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        BusinessApplyInfo *data = [weakSelf.dataItem cellDataForIndexPath:indexPath];
        ConferenceDetailViewController* conferenceDetailVc = [[ConferenceDetailViewController alloc]init];
        conferenceDetailVc.expendId =  data.expendId;
        [weakSelf.navigationController pushViewController:conferenceDetailVc animated:YES];
        
        
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if(self.withoutFinishedButton.selected){
        self.lineView1.backgroundColor = [UIColor blueColor];
    }else{
        self.lineView2.backgroundColor = [UIColor blueColor];
    }
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
    NewConferenceViewController *newConferenceVc = [[NewConferenceViewController alloc]init];
    newConferenceVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newConferenceVc animated:YES];
}

#pragma mark http
-(void)requestDataService:(NSInteger)page{
    [self.loadingHelper showCommittingView:self.view withTitle:@"loading" animated:YES];
    NSString* str = @""HTTP_SERVER"/m_getshenQingInfoList.do";
    //构造参数
    AppDelegate* appDelegate = [AppDelegate shareDelegate];
    NSString* personId = appDelegate.personId;
    NSString* pageStr = [NSString stringWithFormat:@"%ld",(long)page];
    if(page==1){
        [self addPageIndexIsFirst:YES];
    }else{
        [self addPageIndexIsFirst:NO];
    }
    NSDictionary *parameters=@{@"personId":personId,@"pageNum":pageStr,@"expendType":@"10"};
    [[DYMHTTPManager sharedManager] requestWithMethod:GET
                                             WithPath:str
                                           WithParams:parameters
                                     WithSuccessBlock:^(NSDictionary *dic) {
                                         NSData *strData = dic;
                                         NSDictionary *content = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingMutableContainers error:nil];//转换数据格式
                                         NSLog(@"responseObject-->%@",content);
                                         NSMutableArray *array = [[content objectForKey:@"data"] objectForKey:@"dataList"];
                                         NSArray *arrayM = [BusinessApplyInfo objectArrayWithKeyValuesArray:array];
                                         [self endRefreshing];
                                         if(page!=1)
                                             [self bindData:arrayM isRefresh:false];
                                         else
                                             [self bindData:arrayM isRefresh:true];
                                         [self.loadingHelper hideCommittingView:YES];
                                     }
                                      WithFailurBlock:^(NSError *error) {
                                          NSLog(@"error-->%@",error);
                                          [self endRefreshing];
                                      }];
    
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



- (void)bindData:(NSArray *)dataList isRefresh:(Boolean)isRefresh
{
    @try {
        if(isRefresh)
            [self.dataItem clearData];
        if( self.withoutFinishedButton.selected){
            [self.dataItem addCellClass:[ConferenceTableViewCell class] dataItems:dataList];
        }else{
            [self.dataItem addCellClass:[ConferenceTableViewCell class] dataItems:self.finishedInfoItems];
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
