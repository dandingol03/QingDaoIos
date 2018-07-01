//
//  BobView.h
//  GuXianSheng
//
//  Created by Cheney on 4/23/15.
//  Copyright (c) 2015 BobAngus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BobView : UIView

@property (nonatomic, assign) id delegate;

@property (nonatomic, readonly) BOOL isDidSetup;

- (void)setup;

- (void)bindData:(id)viewData;

- (void)handleTouchOnMaskView:(id)sender;

@end
