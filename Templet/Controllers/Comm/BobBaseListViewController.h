//
//  BobBaseListViewController.h
//  Chainup
//
//  Created by mac on 2017/12/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BobBaseViewController.h"

#import "CCTableDataSourceHeader.h"

@interface BobBaseListViewController : BobBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, readonly) NSInteger pageIndex;
@property (nonatomic, readonly) NSInteger firstPageIndex;

@property (nonatomic, assign) BOOL  isAutoReloadData;

- (void)addRefreshHeaderView;

- (void)addLoadMoreFooterView;

- (void)endRefreshing;

- (void)requestDataService:(NSInteger)page;

-(void)addPageIndexIsFirst:(BOOL)first;

//- (BobBaseViewController *)viewControllerForIndexPath:(NSIndexPath *)indexPath previewing:(BOOL)previewing;
//
//- (BobBaseViewController *)previewingViewControllerForLocation:(CGPoint)location indexPath:(NSIndexPath *)indexPath tableViewCell:(UITableViewCell *)cell;

@end
