//
//  BobResultView.m
//  GuXianSheng
//
//  Created by liusc on 15/5/6.
//  Copyright (c) 2015年 BobAngus. All rights reserved.
//

#import "BobResultView.h"

#import "NSString+Util.h"
#import "UIColor+Util.h"
#import "UIView+Util.h"

//#import <boblibrarys/NSString+Util.h>
//#import <boblibrarys/UIColor+Util.h>
//#import <boblibrarys/UIView+Util.h>

@interface BobResultView ()
{
    BOOL isSetup;
}
@property (strong, nonatomic) UIImage *resultImage;

@property (strong, nonatomic) UIImageView *resultImageView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *descriptionLabel;

@property (strong, nonatomic) UIButton *refreshBtn;

@end

@implementation BobResultView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    if (isSetup) {
        return;
    }
    self.backgroundColor = [UIColor colorWithHex:0XF5F5F5];
    
    self.resultImageView = [[UIImageView alloc] init];
    [self addSubview:self.resultImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.titleLabel.textColor = [UIColor colorWithHex:0x909090];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.font = [UIFont systemFontOfSize:14.0f];
    self.descriptionLabel.textColor = [UIColor colorWithHex:0x909090];
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptionLabel.numberOfLines = 0;
    [self addSubview:self.descriptionLabel];
    
    self.refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.refreshBtn.backgroundColor = [UIColor clearColor];
    [self.refreshBtn addTarget:self
                        action:@selector(refresh:)
              forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.refreshBtn];
    isSetup = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat contentHeight = 0;
    if (self.resultImage) {
        contentHeight = self.resultImage.size.height;
        self.resultImageView.size = self.resultImage.size;
    }
    
    if ([self.titleLabel.text hasNonWhitespaceText]
        || [self.descriptionLabel.text hasNonWhitespaceText]) {
        contentHeight += 10;
    }
    
    if ([self.titleLabel.text hasNonWhitespaceText]) {
        self.titleLabel.size = [self.titleLabel.text sizeThatFit:CGSizeMake(self.sizeW - 20.0f, INT32_MAX) font:self.titleLabel.font];
        contentHeight += self.titleLabel.sizeH;
    }else{
        self.titleLabel.sizeH = 0;
    }
    
    if ([self.descriptionLabel.text hasNonWhitespaceText]) {
        self.descriptionLabel.size = [self.descriptionLabel.text sizeThatFit:CGSizeMake(self.sizeW, INT32_MAX) font:self.descriptionLabel.font];
        contentHeight += self.descriptionLabel.sizeH;
    }else{
        self.descriptionLabel.sizeH = 0;
    }
    
    CGFloat offsetY = (self.sizeH - contentHeight) / 2;
    
    self.resultImageView.origin = CGPointMake((self.sizeW - self.resultImageView.sizeW) / 2, offsetY);
    offsetY += (self.resultImageView.sizeH + 10);
    self.titleLabel.origin = CGPointMake((self.sizeW - self.titleLabel.sizeW) / 2, offsetY);
    offsetY += (self.titleLabel.sizeH + 10);
    self.descriptionLabel.origin = CGPointMake((self.sizeW - self.descriptionLabel.sizeW) / 2, offsetY);
}

- (void)refresh:(UIButton*)sender
{
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(refresh:)]) {
        [self.delegate refresh:self];
    }
}

- (void)showInView:(UIView*)view
{
    [view addSubview:self];
}

- (void)showInView:(UIView *)view withHCError:(NSString *)error
{
    NSString *resultImageName = nil;
    NSString *resultDescription = nil;
    BOOL needRefresh = NO;
    
//    if (error.type == HCErrorTypeNetwork) {
//        resultImageName = @"wifi";
//        resultDescription = @"请点击屏幕重试";
//        needRefresh = YES;
//    } else {
        resultImageName = @"file";
        resultDescription = NSLocalizedString(@"waiting", nil);
        needRefresh = NO;
//    }
    
    [self showInView:view resultImageName:resultImageName resultTitle:error resultDescription:resultDescription needRefresh:needRefresh];
}

- (void)showInView:(UIView *)view withEmptyMessage:(NSString *)emptyMessage
{
    if (![emptyMessage hasNonWhitespaceText]) {
        emptyMessage = NSLocalizedString(@"not_check_data", nil);
    }
    
    [self showInView:view resultImageName:@"file" resultTitle:emptyMessage resultDescription:nil needRefresh:NO];
}

- (void)showInView:(UIView *)view
    resultViewType:(BobResultViewType)resultViewType
{
    switch (resultViewType) {
        case BobResultViewTypeEmpty:
            _resultImageView.image = [UIImage imageNamed:@"file"];
            _titleLabel.text = NSLocalizedString(@"not_match_data", nil);
            _descriptionLabel.text = @"";
            break;
        case BobResultViewTypeNetworkError:
            _resultImageView.image = [UIImage imageNamed:@"wifi"];
            _titleLabel.text = NSLocalizedString(@"network_not_used", nil);
            _descriptionLabel.text = NSLocalizedString(@"check_network_state", nil);
            break;
        default:
            break;
    }
    
    [view addSubview:self];
    
    [self setNeedsLayout];
}

- (void)showInView:(UIView *)view
   resultImageName:(NSString *)resultImageName
       resultTitle:(NSString *)resultTitle
 resultDescription:(NSString *)resultDescription
       needRefresh:(BOOL)needRefresh
{
    self.frame = view.bounds;
    
    self.resultImage = [UIImage imageNamed:resultImageName];
    self.resultImageView.image = self.resultImage;
    self.titleLabel.text = resultTitle;
    self.descriptionLabel.text = resultDescription;
    self.refreshBtn.enabled = needRefresh;
    self.refreshBtn.frame = view.bounds;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [view addSubview:self];
    
    [self setNeedsLayout];
}

- (void)hide
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
