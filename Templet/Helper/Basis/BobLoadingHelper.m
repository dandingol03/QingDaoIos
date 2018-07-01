//
//  BobLoadingView.m
//  GuXianSheng
//
//  Created by liusc on 15/4/16.
//  Copyright (c) 2015年 BobAngus. All rights reserved.
//

#import "BobLoadingHelper.h"
#import "MBProgressHUD.h"

@interface BobLoadingHelper ()

@property (strong, nonatomic) MBProgressHUD *loadingProgressHUD;

@property (strong, nonatomic) MBProgressHUD *commitProgressHUD;

@property (strong, nonatomic) BobLoadingView *loadingView;

@property (assign, nonatomic) BOOL loadingHidden;

@end

@implementation BobLoadingHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        _loadingView = [[BobLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 100.0f)];
        _loadingView.title = NSLocalizedString(@"loading", nil);
        _loadingView.backgroundColor = [UIColor clearColor];
        _loadingProgressHUD = [MBProgressHUD new];
        _loadingProgressHUD.mode = MBProgressHUDModeCustomView;
        [_loadingProgressHUD setCustomView:_loadingView];
        _loadingProgressHUD.backgroundColor = [UIColor colorWithRed:245 green:245 blue:245 alpha:1];
        _loadingProgressHUD.color = [UIColor clearColor];
        _loadingProgressHUD.margin = 0.0f;
        _loadingHidden = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleApplicationWillEenterForegroud:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)handleApplicationWillEenterForegroud:(NSNotification*)sender
{
    if (self.loadingHidden) {
        [self.loadingView show:YES];
    }
}

- (void)show:(UIView *)view animated:(BOOL)animated
{
    _loadingView.frame = view.bounds;
    [view addSubview:_loadingProgressHUD];
    [_loadingView show:YES];
    _loadingHidden = YES;
    [_loadingProgressHUD show:animated];
}

- (void)show:(UIView*)view
   withTitle:(NSString*)title
    animated:(BOOL)animated
{
    _loadingView.frame = view.bounds;
    [_loadingView show:YES];
    _loadingHidden = YES;
    _loadingView.title = title;
    [view addSubview:_loadingProgressHUD];
    [_loadingProgressHUD show:animated];
}

- (void)hide:(BOOL)animated
{
    _loadingHidden = NO;
    [_loadingView hide:YES];
    [_loadingProgressHUD hide:animated];
}

- (void)showCommittingView:(UIView*)view
                 withTitle:(NSString*)title
                  animated:(BOOL)animated
{
    if (!_commitProgressHUD) {
        _commitProgressHUD = [MBProgressHUD new];
        [view addSubview:_commitProgressHUD];
    }
    _commitProgressHUD.labelText = title;
    [_commitProgressHUD show:animated];
}

- (void)hideCommittingView:(BOOL)animated
{
    if (_commitProgressHUD) {
        [_commitProgressHUD hide:YES];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
}

@end

static int kLoadingImageWidth = 80.0f;

static int kLoadingImageHeight = 80.0f;

static int kTitleHeight = 20.0f;

@interface BobLoadingView ()

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIImageView *loadingImageView;

@end

@implementation BobLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

/**
 *  配置界面
 */
- (void)setup
{
    if (!_loadingImageView) {
        _loadingImageView.image = [UIImage imageNamed:@"refresh_gsx"];
        _loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kLoadingImageWidth, kLoadingImageHeight)];
        _loadingImageView.layer.cornerRadius = kLoadingImageWidth/2;
        _loadingImageView.layer.masksToBounds = YES;
//        NSArray *gifArray = [NSArray arrayWithObjects:
//                             [UIImage imageNamed:@"01_HUDS"],
//                             [UIImage imageNamed:@"02_HUDS"],
//                             [UIImage imageNamed:@"03_HUDS"],
//                             [UIImage imageNamed:@"04_HUDS"],
//                             [UIImage imageNamed:@"05_HUDS"],
//                             [UIImage imageNamed:@"06_HUDS"],
//                             [UIImage imageNamed:@"07_HUDS"],
//                             [UIImage imageNamed:@"08_HUDS"],
//                             [UIImage imageNamed:@"09_HUDS"],
//                             [UIImage imageNamed:@"10_HUDS"],
//                             [UIImage imageNamed:@"11_HUDS"],
//                             [UIImage imageNamed:@"12_HUDS"],
//                             [UIImage imageNamed:@"13_HUDS"],nil];
//        _loadingImageView.animationImages = gifArray; //动画图片数组
//        _loadingImageView.animationDuration = 3; //执行一次完整动画所需的时长
//        _loadingImageView.animationRepeatCount = FLT_MAX;  //动画重复次数
        [self addSubview:_loadingImageView];
    }
    
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height - kTitleHeight, kLoadingImageWidth, kTitleHeight)];
        _titleLabel.font = [UIFont systemFontOfSize:12.0f];
        int hex = 0x909090;
        _titleLabel.textColor = [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                                                green:((float)((hex & 0xFF00) >> 8))/255.0
                                                 blue:((float)(hex & 0xFF))/255.0
                                                alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
}

- (void)setTitle:(NSString *)title
{
    if (title) {
        _titleLabel.text = title;
    }
}

- (void)show:(BOOL)animated
{
    _loadingImageView.frame = CGRectMake((self.frame.size.width - _loadingImageView.frame.size.width) / 2
                                         , (self.frame.size.height - _loadingImageView.frame.size.height) / 2
                                         , _loadingImageView.frame.size.width
                                         , _loadingImageView.frame.size.height);
    _titleLabel.frame = CGRectMake((self.frame.size.width - _titleLabel.frame.size.width) / 2
                                   , _loadingImageView.frame.origin.y + _loadingImageView.frame.size.height
                                   , _titleLabel.frame.size.width
                                   , _titleLabel.frame.size.height);
    _titleLabel.hidden = NO;
    [_loadingImageView startAnimating];
}

- (void)hide:(BOOL)animated
{
    _titleLabel.hidden = YES;
    [_loadingImageView stopAnimating];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
