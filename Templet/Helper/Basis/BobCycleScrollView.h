//
//  BobCycleScrollView.h
//  Sotao
//
//  Created by CavinTang on 4/24/15.
//  Copyright (c) 2015 sotao. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BobView.h"
#import "UIView+Util.h"

@class BobCycleScrollView;

@protocol CycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfViewsInCycleScrollView:(BobCycleScrollView *)view;
- (UIView *)cycleScrollView:(BobCycleScrollView *)view viewAtIndex:(NSInteger)index;

@end

@protocol CycleScrollViewDelegate <NSObject>

@optional
- (void)cycleScrollView:(BobCycleScrollView *)view didSelectAtIndex:(NSInteger)selectIndex;
- (void)cycleScrollView:(BobCycleScrollView *)view changeToIndex:(NSInteger)newIndex fromIndex:(NSInteger)oldIndex;

@end

@interface BobCycleScrollView : BobView

@property (weak, nonatomic) IBOutlet id<CycleScrollViewDatasource> dataSource;
@property (weak, nonatomic) IBOutlet id<CycleScrollViewDelegate> delegate;

@property (assign, nonatomic) BOOL      canTapItemView;
@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) CGSize    contentSize;

- (void)reloadData;
- (void)reloadDataAndAutoPlay:(NSTimeInterval)timeInterval;
- (void)stopAutoPlay;
- (void)toNext;
- (UIView *)currentItemView;

@end
