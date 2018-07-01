
//
//  STNavigationController.m
//  GuXianSheng
//
//  Created by CavinTang on 9/14/15.
//  Copyright (c) 2015 BobAngus. All rights reserved.
//

#import "PanBackNavigationController.h"
#import "UIView+Util.h"

#define BACK_IMAGE_VIEW_TAG     1111111111
#define BACK_MASK_VIEW_ALPHA    0.5f

@interface PanBackNavigationController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) STPanGestureRecognizer *pan;

@property (strong, nonatomic) NSMutableDictionary *shotStackDic;

@property (assign, nonatomic) BOOL animatedFlag;

@property (nonatomic, strong) UIView *backContainerView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIView *backMaskView;
@property (nonatomic, strong) UIView *shadowView;

@end

@implementation PanBackNavigationController

 


#pragma mark - Property

- (UIPanGestureRecognizer *)panGestureRecognizer
{
    return self.pan;
}

- (UIView *)controllerWrapperView
{
    return self.visibleViewController.view.superview;
}

- (UIView *)snapshotView
{
    return self.tabBarController ? self.tabBarController.view : self.view;
}

- (UIView *)remoteKeyboardWindow
{
    UIView *remoteKeyboardWindow;
    for (UIView *window in [UIApplication sharedApplication].windows) {
        if (IOS9_OR_LATERS) {
            if ([window isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")]) {
                remoteKeyboardWindow = window;
                break;
            }
        } else {
            if ([window isKindOfClass:NSClassFromString(@"UITextEffectsWindow")]) {
                remoteKeyboardWindow = window;
                break;
            }
        }
    }
    return remoteKeyboardWindow;
}

- (UIView *)textEffectsWindow
{
    UIView *textEffectsWindow;
    for (UIView *window in [UIApplication sharedApplication].windows) {
        if (IOS9_OR_LATERS) {
            if ([window isKindOfClass:NSClassFromString(@"UITextEffectsWindow")]) {
                textEffectsWindow = window;
                break;
            }
        }
    }
    return textEffectsWindow;
}

#pragma mark - view cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    _pan = [[STPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    _pan.delegate = self;
    _pan.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:_pan];
    
    _shotStackDic = [NSMutableDictionary dictionary];
    
    self.backContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.backContainerView.clipsToBounds = YES;
    self.backContainerView.backgroundColor = [UIColor blackColor];
    
    
    self.backImageView = [[UIImageView alloc] initWithFrame:self.backContainerView.bounds];
    [self.backContainerView addSubview:self.backImageView];
    
    self.backMaskView = [[UIView alloc] initWithFrame:self.backContainerView.bounds];
    self.backMaskView.backgroundColor = [UIColor blackColor];
    [self.backContainerView addSubview:self.backMaskView];
    
    self.shadowView = [[UIView alloc]initWithFrame:CGRectMake(self.backContainerView.bounds.size.width + 2.5f, 0, 1, self.backContainerView.bounds.size.height)];
    self.shadowView.backgroundColor = [UIColor redColor];
    self.shadowView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.shadowView.layer.shadowOpacity = 0.6f;
    self.shadowView.layer.shadowOffset = CGSizeMake(-2.5f, 0);
    [self.backContainerView addSubview:self.shadowView];
    
    [self.navigationBar addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)dealloc
{
    self.pan.delegate = nil;
    [self.navigationBar removeObserver:self forKeyPath:@"alpha"];
}

#pragma mark - private method

- (void)startAnimated:(BOOL)animated
{
    self.animatedFlag = YES;
    
    NSTimeInterval delay = animated ? 0.8 : 0.1;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishedAnimated) object:nil];
    [self performSelector:@selector(finishedAnimated) withObject:nil afterDelay:delay];
}

- (void)finishedAnimated
{
    self.animatedFlag = NO;
}

- (void)removeBackImageView
{
    UIViewController *viewController = [self.viewControllers lastObject];
    for (UIView *view in viewController.view.subviews) {
        if (view.tag == BACK_IMAGE_VIEW_TAG) {
            [view removeFromSuperview];
        }
    }
}

- (void)resetKeyboard
{
    self.remoteKeyboardWindow.transform =
    self.textEffectsWindow.transform = CGAffineTransformIdentity;
}

#pragma mark - public method

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
    //TODO:there has a bug, if new viewControllers has a new, then that has no snapshot, when you pan bank, you will see the wrong snapshot
    
    //set new shot key index
    NSMutableArray *shotStackKeyIndex = [NSMutableArray array];
    if (viewControllers.count > 1) {
        for (int index = 0; index < viewControllers.count - 1; index++) {
            UIViewController *viewController = viewControllers[index];
            [shotStackKeyIndex addObject:[viewController description]];
        }
    }
    //remove not exist shot
    for (NSString *key in self.shotStackDic.allKeys) {
        if (![shotStackKeyIndex containsObject:key]) {
            [self.shotStackDic removeObjectForKey:key];
        }
    }
    
    [super setViewControllers:viewControllers animated:animated];
    
    [self removeBackImageView];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.visibleViewController && !self.visibleViewController.isViewLoaded) return;
    
    UIViewController *previousViewController = [self.viewControllers lastObject];
    
    if (previousViewController) {
        UIImage *viewImage = [self.snapshotView snapshot];
        NSString *key = [previousViewController description];
        [self.shotStackDic setObject:viewImage forKey:key];
        
        UIImageView *tempBackImageView = [[UIImageView alloc] initWithImage:viewImage];
        tempBackImageView.tag = BACK_IMAGE_VIEW_TAG;
        [previousViewController.view addSubview:tempBackImageView];
    }
    
    // 动画标识，在动画的情况下，禁掉右滑手势
    [self startAnimated:animated];
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated;
{
    [self.shotStackDic removeObjectForKey:[self.visibleViewController description]];
    
    [self startAnimated:animated];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTHS, 64)];
    imageView.contentMode = UIViewContentModeTop;
    imageView.image = [self.snapshotView snapshot];
    [self.visibleViewController.view addSubview:imageView];
    
    UIViewController *popViewController = [super popViewControllerAnimated:animated];
    
    [self removeBackImageView];
    
    return popViewController;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
    NSArray *popToViewControllers = [super popToViewController:viewController animated:animated];
    
    NSMutableArray *tempViewControllers = [NSMutableArray arrayWithArray:popToViewControllers];
    [tempViewControllers addObject:viewController];
    for (UIViewController *viewController in tempViewControllers) {
        NSString *key = [viewController description];
        [self.shotStackDic removeObjectForKey:key];
    }
    [self removeBackImageView];
    
    return popToViewControllers;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray *popViewControllers = [super popToRootViewControllerAnimated:animated];
    
    [self.shotStackDic removeAllObjects];
    [self removeBackImageView];
    
    return popViewControllers;
}

#pragma mark - GestureRecognizer

- (void)pan:(UIPanGestureRecognizer *)pan
{
    UIGestureRecognizerState state = pan.state;
    switch (state) {
        case UIGestureRecognizerStateBegan:{
            UIViewController *previousViewController = self.viewControllers[self.viewControllers.count - 2];
            UIImage *viewImage = [self.shotStackDic objectForKey:[previousViewController description]];
            
            [self startPanBack];
            
            self.backContainerView.originX = SCREEN_WIDTHS * -1;
            self.backImageView.image = viewImage;
            self.backMaskView.alpha = BACK_MASK_VIEW_ALPHA;
            [self.view.window addSubview:self.backContainerView];
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:{
            CGPoint translationPoint = [self.pan translationInView:self.view];
            CGFloat movePercent = MAX(translationPoint.x, 0) / SCREEN_WIDTHS;
            
            self.navigationBar.superview.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, MAX(translationPoint.x, 0), 0);
            self.backContainerView.originX = SCREEN_WIDTHS * -1 + MAX(translationPoint.x, 0);
            self.backMaskView.alpha = BACK_MASK_VIEW_ALPHA * (1 - movePercent);
            self.remoteKeyboardWindow.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, MAX(translationPoint.x, 0), 0);
            self.textEffectsWindow.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, MAX(translationPoint.x, 0), 0);

            break;
        }
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            CGPoint translationPoint = [self.pan translationInView:self.view];
            CGPoint velocity = [self.pan velocityInView:self.view];
            BOOL reset = (velocity.x * 0.2 + MAX(translationPoint.x, 0)) < SCREEN_WIDTHS / 2;
            
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            [UIView animateWithDuration:0.3 animations:^{
                self.navigationBar.superview.transform =  reset ? CGAffineTransformIdentity : CGAffineTransformTranslate(CGAffineTransformIdentity, SCREEN_WIDTHS, 0);
                self.backContainerView.originX = reset ? SCREEN_WIDTHS * -1 : 0;
                self.backMaskView.alpha = reset ? BACK_MASK_VIEW_ALPHA : 0;
                self.remoteKeyboardWindow.transform =  reset ? CGAffineTransformIdentity : CGAffineTransformTranslate(CGAffineTransformIdentity, SCREEN_WIDTHS, 0);
                self.textEffectsWindow.transform =  reset ? CGAffineTransformIdentity : CGAffineTransformTranslate(CGAffineTransformIdentity, SCREEN_WIDTHS, 0);
            } completion:^(BOOL finished) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                [self finshPanBackWithReset:reset];
                
                if (!reset) {
                    [self performSelector:@selector(resetKeyboard) withObject:nil afterDelay:.5f];
                    [self popViewControllerAnimated:NO];
                }
                self.navigationBar.superview.transform =  CGAffineTransformIdentity;
                [self.backContainerView removeFromSuperview];
            }];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate

#define MIN_TAN_VALUE tan(M_PI/6)

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count < 2) return NO;
    if (self.animatedFlag) return NO;
    if (![self enablePanBack]) return NO; // 询问当前viewconroller 是否允许右滑返回
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.controllerWrapperView];
    if (touchPoint.x < 0 || touchPoint.y < 10 || touchPoint.x > 30) return NO;
    
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    if (translation.x <= 0) return NO;
    
    // 是否是右滑
    BOOL succeed = fabs(translation.y / translation.x) < MIN_TAN_VALUE;
    
    return succeed;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer != self.pan) return NO;
    if (self.pan.state != UIGestureRecognizerStateBegan) return NO;
    
    if (otherGestureRecognizer.state != UIGestureRecognizerStateBegan) {
        
        return YES;
    }
    
    CGPoint touchPoint = [self.pan beganLocationInView:self.controllerWrapperView];
    
    // 点击区域判断 如果在左边 30 以内, 强制手势后退
    if (touchPoint.x < 30) {
        
        [self cancelOtherGestureRecognizer:otherGestureRecognizer];
        return YES;
    }
    
    // 如果是scrollview 判断scrollview contentOffset 是否为0，是 cancel scrollview 的手势，否cancel自己
    if ([[otherGestureRecognizer view] isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)[otherGestureRecognizer view];
        if (scrollView.contentOffset.x <= 0) {
            
            [self cancelOtherGestureRecognizer:otherGestureRecognizer];
            return YES;
        }
    }
    
    return NO;
}

- (void)cancelOtherGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSSet *touchs = [self.pan.event touchesForGestureRecognizer:otherGestureRecognizer];

//    [otherGestureRecognizer touchesCancelled:[touchs anyObject] withEvent:self.pan.event];
}

#pragma mark - STNavigationPanBackProtocol

- (BOOL)enablePanBack
{
    BOOL enable = YES;
    if ([self.visibleViewController respondsToSelector:@selector(enablePanBack:)]) {
        UIViewController<STPanBackNavigationProtocol> * viewController = (UIViewController<STPanBackNavigationProtocol> *)self.visibleViewController;
        enable = [viewController enablePanBack:self];
    }
    return enable;
}

- (void)startPanBack
{
    if ([self.visibleViewController respondsToSelector:@selector(startPanBack:)]) {
        UIViewController<STPanBackNavigationProtocol> * viewController = (UIViewController<STPanBackNavigationProtocol> *)self.visibleViewController;
        [viewController startPanBack:self];
    }
}

- (void)finshPanBackWithReset:(BOOL)reset
{
    if (reset) {
        [self resetPanBack];
    } else {
        [self finshPanBack];
    }
}

- (void)finshPanBack
{
    if ([self.visibleViewController respondsToSelector:@selector(finshPanBack:)]) {
        UIViewController<STPanBackNavigationProtocol> * viewController = (UIViewController<STPanBackNavigationProtocol> *)self.visibleViewController;
        [viewController finshPanBack:self];
    }
}

- (void)resetPanBack
{
    if ([self.visibleViewController respondsToSelector:@selector(resetPanBack:)]) {
        UIViewController<STPanBackNavigationProtocol> * viewController = (UIViewController<STPanBackNavigationProtocol> *)self.visibleViewController;
        [viewController resetPanBack:self];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"alpha"]) {
        CGFloat old = [[change objectForKey:@"old"] floatValue];
        CGFloat new = [[change objectForKey:@"new"] floatValue];
        if (old < 1 && self.presentedViewController) {
            self.navigationBar.alpha = old;
            NSLog(@"restore %@ from %@", @(old), @(new));
        }
    }
}

@end

#pragma mark - STPanGestureRecognizer

#import <UIKit/UIGestureRecognizerSubclass.h>

@interface STPanGestureRecognizer ()

@property (assign, nonatomic) CGPoint beganLocation;
@property (strong, nonatomic) UIEvent *event;
@property (assign, nonatomic) NSTimeInterval beganTime;

@end

@implementation STPanGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.beganLocation = [touch locationInView:self.view];
    self.event = event;
    self.beganTime = event.timestamp;
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.state == UIGestureRecognizerStatePossible && event.timestamp - self.beganTime > 0.3) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    [super touchesMoved:touches withEvent:event];
}

- (void)reset
{
    self.beganLocation = CGPointZero;
    self.event = nil;
    self.beganTime = 0;
    [super reset];
}

- (CGPoint)beganLocationInView:(UIView *)view
{
    return [view convertPoint:self.beganLocation fromView:self.view];
}

@end

#pragma mark - UIView+Snapshot

@implementation UIView (Snapshot)

- (UIImage *)snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, [[UIScreen mainScreen] scale]);;
    
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    } else {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.layer renderInContext:context];
    }
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

@end
