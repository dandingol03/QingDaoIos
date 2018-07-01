//
//  UIView+Util.h
//  GuXianSheng
//
//  Created by Cheney on 4/22/15.
//  Copyright (c) 2015 BobAngus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Util)

+ (instancetype)viewFromXib;
+ (instancetype)viewFromXibName:(NSString *)xibName;
+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve;

@property(nonatomic,assign) CGPoint origin;
@property(nonatomic,assign) CGFloat originX;
@property(nonatomic,assign) CGFloat originY;
@property(nonatomic,assign) CGSize  size;
@property(nonatomic,assign) CGFloat  sizeW;
@property(nonatomic,assign) CGFloat  sizeH;
@property(nonatomic,assign) CGFloat centerX;
@property(nonatomic,assign) CGFloat centerY;

- (UIImage *)screenshot;

- (void)touchSelected;

- (void)touchNormal;

- (BOOL)isShowingOnKeyWindow;

@end
