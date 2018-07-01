//
//  HomeMainViewController.m
//  Templet
//
//  Created by 丁一明 on 2018/6/6.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "HomeMainViewController.h"
#import "BobCycleScrollView.h"
#import "HomeCmsAdvertList.h"
#import "OfficeMainViewController.h"
#import "TodoListViewController.h"
#import "ApplyInfo.h"
#import "NSObject+MJKeyValue.h"

#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)


@interface HomeMainViewController () <CycleScrollViewDatasource, CycleScrollViewDelegate>

@property (strong, nonatomic) IBOutlet BobCycleScrollView *cycleScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *bannerArray;

@end

@implementation HomeMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.cycleScrollView.dataSource = self;
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.canTapItemView = YES;
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    self.cycleScrollView.contentSize = CGSizeMake(ScreenWidth, 200);
    
    UIImage* image1 = [UIImage imageNamed:@"组 4"];
    UIImage* image2 = [UIImage imageNamed:@"组 35"];
    NSString *image1Path = [path stringByAppendingPathComponent:@"组 4"];
    NSString *image2Path = [path stringByAppendingPathComponent:@"组 35"];
    
    self.bannerArray = @[@"组 4",@"组 35",@"组 4",];
    self.pageControl.numberOfPages =3;
    if (self.bannerArray.count == 1) {
        self.pageControl.hidden = YES;
        [self.cycleScrollView reloadData];
    } else {
        self.pageControl.hidden = NO;
        [self.cycleScrollView reloadDataAndAutoPlay:3.f];
    }
    
    [self getApplyInfo];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
     [super viewWillDisappear:animated];
     self.tabBarController.tabBar.hidden = NO;
     [self.navigationController setNavigationBarHidden:NO animated:YES];  
}

-(void)getApplyInfo
{
    NSString* str = @""HTTP_SERVER"/m_out_apply_add_init.do";
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
                                         AppDelegate* appDelegate = [AppDelegate shareDelegate];
                                         //appDelegate.applyInfo = [content objectForKey:@"data"];
                                         appDelegate.applyInfo = [ApplyInfo objectWithKeyValues:[content objectForKey:@"data"]];
                                     }
                                      WithFailurBlock:^(NSError *error) {
                                          NSLog(@"error-->%@",error);
                                      }];
    
}



#pragma mark - CycleScrollViewDataSource

- (NSInteger)numberOfViewsInCycleScrollView:(BobCycleScrollView *)view
{
    return self.bannerArray.count;
}

- (UIView *)cycleScrollView:(BobCycleScrollView *)view viewAtIndex:(NSInteger)index
{
    UIView *bannerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, -20.0f, SCREEN_WIDTH, 220)];
    
    UIImageView *bannerImageView = [[UIImageView alloc] initWithFrame:bannerView.bounds];
    bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *imageUrl = [self.bannerArray objectAtIndex:index];

    [bannerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                       placeholderImage:[UIImage imageNamed:imageUrl]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  if(!error){

                                  }
                              }];
    
    [bannerView addSubview:bannerImageView];
    
    return bannerView;
}

- (void)cycleScrollView:(BobCycleScrollView *)view changeToIndex:(NSInteger)newIndex fromIndex:(NSInteger)oldIndex
{
    self.pageControl.currentPage = newIndex;
}

- (void)cycleScrollView:(BobCycleScrollView *)view didSelectAtIndex:(NSInteger)selectIndex
{
    
}


- (IBAction)itemAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1:{
            OfficeMainViewController *officeMainVc = [[OfficeMainViewController alloc]init];
            [self.navigationController pushViewController:officeMainVc animated:YES];
        }
            break;
        case 2:{
           
        }
            break;
        case 3:{
            
        }
            break;
        case 4:{
            
        }
            break;
        case 5:{
           
        }
            break;
        case 9:{
            TodoListViewController *todoListVc = [[TodoListViewController alloc]init];
            [self.navigationController pushViewController:todoListVc animated:YES];
        }
            break;
            
        default:
            break;
    }
}





- (void)dealloc
{
    [self.cycleScrollView stopAutoPlay];
    self.cycleScrollView.delegate = nil;
    self.cycleScrollView.dataSource = nil;
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
