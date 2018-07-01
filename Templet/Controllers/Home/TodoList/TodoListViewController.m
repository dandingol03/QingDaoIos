//
//  TodoListViewController.m
//  Templet
//
//  Created by 丁一明 on 2018/6/18.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "TodoListViewController.h"
#import "TodoListTableViewCell.h"
#import "TodoListInfo.h"


@interface TodoListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CCTableDataItem *dataItem;
@property (nonatomic, strong) CCTableViewDelegate *delegate;
@property (nonatomic, strong) CCTableViewDataSource *dataSource;

@property (strong, nonatomic) NSArray *todolistInfoItems;
@end

@implementation TodoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"待办事项";
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"fooder-bg11"] forBarMetrics:UIBarMetricsDefault];
    //self.view.layer.contents = (id)[UIImage imageNamed:@"bg-neiye"].CGImage;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    //右上角搜索按钮
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                           style:UIBarButtonItemStyleDone
                                                                          target:self
                                                                          action:@selector(addingOfficeApply)];
    rightBarButtonItem.image = [UIImage imageNamed:@"搜索-4"];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
   // [self combitionData];
    [self setTableView];
    [self addRefreshHeaderView];
    [self addLoadMoreFooterView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


-(void)combitionData{
    self.todolistInfoItems = @[[[TodoListInfo alloc]initWithTitle:@"项目前期工作奖励补助费1"
                                                                   fee:@"￥1234"
                                                             applyTime:@"05-26 09:20"
                                                           applyPerson:@"张三"
                                                            department:@"财务处"
                                       ],
                                      [[TodoListInfo alloc]initWithTitle:@"项目前期工作奖励补助费2"
                                                                   fee:@"￥5678"
                                                             applyTime:@"05-26 09:20"
                                                           applyPerson:@"05-26 09:20"
                                                            department:@"分管业务副厅长审批"
                                       ],
                                      ];

    [self getTodoList];

    //[self bindData];
}

-(void)getTodoList
{
    NSString* str = @"http://211.159.151.39:81/control/control_mobile/m_getTodoList.do";
    //构造参数
    AppDelegate* appDelegate = [AppDelegate shareDelegate];
    NSString* personId = appDelegate.personId;
    
    NSDictionary *parameters=@{@"personId":personId};
    [[DYMHTTPManager sharedManager] requestWithMethod:GET
                                             WithPath:str
                                           WithParams:parameters
                                     WithSuccessBlock:^(NSDictionary *dic) {
                                         NSData *strData = dic;
                                         NSDictionary *content = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingMutableContainers error:nil];//转换数据格式
                                         NSLog(@"responseObject-->%@",content);
                                         
                                     }
                                      WithFailurBlock:^(NSError *error) {
                                          NSLog(@"error-->%@",error);
                                      }];
    
}

-(void)setTableView{
    self.tableView.delegate = self.delegate;
    self.tableView.dataSource = self.dataSource;
    
    [self.tableView registerNibCellClasses:@[[TodoListTableViewCell class],
                                             ]];
    [self loadData:YES];
    
    //__weak __typeof(self)weakSelf = self;
    [self.delegate setDidSelectRowAtIndexPath:^(UITableView *tableView, NSIndexPath *indexPath, id rowData, NSString *cellClassName) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }];
}



#pragma mark http
-(void)requestDataService:(NSInteger)page{
    [self.loadingHelper showCommittingView:self.view withTitle:@"loading" animated:YES];
    NSString* str = @""HTTP_SERVER"/m_getTodoList.do";
    //构造参数
    AppDelegate* appDelegate = [AppDelegate shareDelegate];
    NSString* personId = appDelegate.personId;
    NSString* pageStr = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *parameters=@{@"personId":personId,@"pageNum":pageStr};
    [[DYMHTTPManager sharedManager] requestWithMethod:GET
                                             WithPath:str
                                           WithParams:parameters
                                     WithSuccessBlock:^(NSDictionary *dic) {
                                         NSData *strData = dic;
                                         NSDictionary *content = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingMutableContainers error:nil];//转换数据格式
                                         NSLog(@"responseObject-->%@",content);
                                         NSArray *array = [[content objectForKey:@"data"] objectForKey:@"dataList"];
                                         NSArray *arrayM = [TodoListInfo objectArrayWithKeyValuesArray:array];
                                         [self endRefreshing];
                                         [self bindData:arrayM];
                                         [self.loadingHelper hideCommittingView:YES];
                                     }
                                      WithFailurBlock:^(NSError *error) {
                                          NSLog(@"error-->%@",error);
                                          //[self handleHttpError:error.message];
                                          [self endRefreshing];
                                          
                                      }];

}

- (void)bindData:(NSArray *)dataList
{
    @try {
        
        [self.dataItem clearData];
        [self.dataItem addCellClass:[TodoListTableViewCell class] dataItems:dataList];
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
