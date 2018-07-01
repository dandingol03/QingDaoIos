//
//  BobBaseListViewController.m
//  Chainup
//
//  Created by mac on 2017/12/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BobBaseListViewController.h"
#import "MJRefresh.h"
#import "BobMacro.h"
//#import "UITableViewCell+Util.h"

#define LIST_PAGE_INDEX_FIRST 1
#define LIST_PAGE_SIZE 5

@interface BobBaseListViewController ()

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger firstPageIndex;
@property (nonatomic, assign) BOOL hasNextPage;

@end

@implementation BobBaseListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setup {
    [super setup];
    
    self.pageSize = LIST_PAGE_SIZE;
    self.firstPageIndex = LIST_PAGE_INDEX_FIRST;
    
    self.isAutoReloadData = YES;
}

- (void)dealloc
{
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}


- (void)addRefreshHeaderView {
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestDataService:weakSelf.firstPageIndex];
    }];
    
}

- (void)addLoadMoreFooterView {
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestDataService:weakSelf.pageIndex + 1];
    }];
}

- (void)endRefreshing {
    if (self.tableView.mj_header) {
        [self.tableView.mj_header endRefreshing];
    }
    if (self.tableView.mj_footer) {
        [self.tableView.mj_footer endRefreshing];
    }
}


- (void)loadData:(BOOL)forceLoad {
 
    [self requestDataService:_firstPageIndex];
    
}

- (void)requestDataService:(NSInteger)page {
    
}
/**
 *  pageIndex ＋1
 *
 */
-(void)addPageIndexIsFirst:(BOOL)first{
    if (first) {
        self.pageIndex = LIST_PAGE_INDEX_FIRST;
        
    }else{
        self.pageIndex++;
    }
}

#pragma mark - handle http error method

- (void)handleHttpError:(NSString *)error
{
    [self endRefreshing];
    
    [super handleHttpError:error hasData:YES];
}

- (void)handleHttpError:(NSString *)error hasData:(BOOL)hasData
{
    [self endRefreshing];
    
    [super handleHttpError:error hasData:hasData];
}

- (void)handleHttpError:(NSString*)error hasData:(BOOL)hasData frame:(CGRect)frame {
    [self endRefreshing];
    
    [super handleHttpError:error hasData:hasData frame:frame];
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
