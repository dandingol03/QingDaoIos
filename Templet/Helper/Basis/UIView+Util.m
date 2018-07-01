//
//  UIView+Util.m
//  GuXianSheng
//
//  Created by Cheney on 4/22/15.
//  Copyright (c) 2015 BobAngus. All rights reserved.
//

#import "UIView+Util.h"

//#import "BobMacro.h"

@implementation UIView (Util)

+ (instancetype)viewFromXib
{
#ifdef DEBUG
    NSDate *beginDate = [NSDate date];
#endif
    
    Class viewClass = [self class];
    NSString *viewClassName = NSStringFromClass(viewClass);
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:viewClassName owner:nil options:nil];
    
    for (id nibItem in nibArray) {
        if ([nibItem isMemberOfClass:viewClass]) {
#ifdef DEBUG
            NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:beginDate];
            
            if (timeInterval > 0.020) {
                NSLog(@"-[%@ viewFromXib] %@\n", viewClassName, @(timeInterval));
            }
#endif
            return nibItem;
        }
    }
    
    return nil;
}

+ (instancetype)viewFromXibName:(NSString *)xibName
{
#ifdef DEBUG
    NSDate *beginDate = [NSDate date];
#endif
    
    Class viewClass = [self class];
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil];
    
    for (id nibItem in nibArray) {
        if ([nibItem isMemberOfClass:viewClass]) {
#ifdef DEBUG
            NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:beginDate];
            
            if (timeInterval > 0.020) {
                NSLog(@"-[%@ viewFromXib] %@\n", xibName, @(timeInterval));
            }
#endif
            return nibItem;
        }
    }
    
    return nil;
}

+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve
{
    return curve << 16;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    
    frame.origin = origin;
    
    self.frame = frame;
}

- (CGFloat)originX {
    return self.frame.origin.x;
}

- (void)setOriginX:(CGFloat)originX {
    CGRect frame = self.frame;
    
    frame.origin.x = originX;
    
    self.frame = frame;
}

- (CGFloat)originY {
    return self.frame.origin.y;
}

- (void)setOriginY:(CGFloat)originY {
    CGRect frame = self.frame;
    
    frame.origin.y = originY;
    
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    
    frame.size = size;
    
    self.frame = frame;
}

- (CGFloat)sizeW {
    return self.frame.size.width;
}

- (void)setSizeW:(CGFloat)sizeW {
    CGRect frame = self.frame;
    
    frame.size.width = sizeW;
    
    self.frame = frame;
}

- (CGFloat)sizeH {
    return self.frame.size.height;
}

- (void)setSizeH:(CGFloat)sizeH {
    CGRect frame = self.frame;
    
    frame.size.height = sizeH;
    
    self.frame = frame;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX{
    self.center = CGPointMake(centerX, self.centerY);
}

- (CGFloat)centerY{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY{
    self.center = CGPointMake(self.centerX, centerY);
}

- (UIImage *)screenshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    
    UIImage *anImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return anImage;
}



- (void)touchSelected
{
    for (UIView *subView in [self subviews]) {
        subView.alpha = 0.5f;
    }
}

- (void)touchNormal
{
    for (UIView *subView in [self subviews]) {
        subView.alpha = 1.0f;
    }
}

- (BOOL)isShowingOnKeyWindow
{
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect winBounds = keyWindow.bounds;
    
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    
    return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}

@end
