//
//  BobView.m
//  GuXianSheng
//
//  Created by Cheney on 4/23/15.
//  Copyright (c) 2015 BobAngus. All rights reserved.
//

#import "BobView.h"

//#import "BobMacro.h"

@implementation BobView {
    BOOL isDidSetup;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (!isDidSetup) {
            isDidSetup = YES;
            
            [self setup];
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        if (!isDidSetup) {
            isDidSetup = YES;
            
            [self setup];
        }
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (!isDidSetup) {
        isDidSetup = YES;
        
        [self setup];
    }
}

- (void)setup
{
    
}

- (BOOL)isDidSetup
{
    return isDidSetup;
}

- (void)bindData:(id)viewData
{
    
}

- (void)handleTouchOnMaskView:(id)sender
{
    
}

// TODO:
- (void)dealloc
{
//    NSLog(@"dealloc %@", NSStringFromClass([self class]));
}

@end
