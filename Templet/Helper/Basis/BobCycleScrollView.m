//
//  BobCycleScrollView.m
//  Sotao
//
//  Created by CavinTang on 4/24/15.
//  Copyright (c) 2015 sotao. All rights reserved.
//

#import "BobCycleScrollView.h"

#define REUSE_VIEW_COUNT (5)

typedef enum{
    CycleScrollViewScrollDirectionPrev,
    CycleScrollViewScrollDirectionNext,
}CycleScrollViewScrollDirection;

@interface BobCycleScrollView () <UIScrollViewDelegate>
{
    NSTimeInterval autoPlayTimeInterval;
    BOOL isAutoScroll;
    CycleScrollViewScrollDirection scrollDirection;
    NSMutableDictionary *reuseViews;
    NSMutableDictionary *itemContentOffsets;
    UIView *m_currentItemView;
}

@property (strong, nonatomic) UIScrollView  *scrollView;

@property (assign, nonatomic) NSInteger totalViews;

@property (strong, nonatomic) NSMutableArray    *currentViews;

@property (strong, nonatomic) NSTimer *autoPlayTimer;

@property (assign, nonatomic, readonly) BOOL isScrollEnd;

@end

@implementation BobCycleScrollView

@dynamic delegate;

- (BOOL)isScrollEnd
{
    if (self.scrollView) {
        return !(self.scrollView.isDragging
                 || self.scrollView.isDecelerating
                 || self.scrollView.isTracking);
    }
    return YES;
}

- (void)setup {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self addSubview:self.scrollView];
    
    self.currentViews = [[NSMutableArray alloc] init];
    scrollDirection = CycleScrollViewScrollDirectionNext;
    reuseViews = [NSMutableDictionary dictionary];
    itemContentOffsets = [NSMutableDictionary dictionary];
    [self.scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)reloadData
{
    [self reloadDataAndAutoPlay:0];
}

- (void)reloadDataAndAutoPlay:(NSTimeInterval)timeInterval
{
    [self stopAutoPlay];
    [self removeCycleViews];
    [reuseViews removeAllObjects];
    _currentIndex = 0;
    self.totalViews = [self.dataSource numberOfViewsInCycleScrollView:self];
    if (self.totalViews == 0) {
        return;
    }
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, 0);
    [self loadData];
    [self startAutoPlay:timeInterval];
}

- (void)loadData
{
    if(self.totalViews <= 0)
    {
        return;
    }
    
    [self setupDisplayViews];
    
    for (int i = 0; i < 3; i++) {
        UIView *v = [self.currentViews objectAtIndex:i];
        if (self.canTapItemView) {
            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];
        }
        v.frame = CGRectMake(i * self.scrollView.sizeW, 0, self.scrollView.sizeW, self.scrollView.sizeH);
        [self.scrollView addSubview:v];
    }
    
    self.scrollView.scrollEnabled = self.totalViews > 1;
}

- (void)setupDisplayViews
{
    [self removeCycleViews];
    
    NSInteger pre = [self validPageValue:self.currentIndex - 1];
    NSInteger next = [self validPageValue:self.currentIndex + 1];
    
    NSString *preKey = [NSString stringWithFormat:@"%@", @(pre)];
    NSString *middleKey = [NSString stringWithFormat:@"%@", @(self.currentIndex)];
    NSString *nextKey = [NSString stringWithFormat:@"%@", @(next)];
    if (self.totalViews == 1) {
        preKey = [NSString stringWithFormat:@"%@_0", @(pre)];
        middleKey = [NSString stringWithFormat:@"%@_1", @(self.currentIndex)];
        nextKey = [NSString stringWithFormat:@"%@_2", @(next)];
    }
    if (self.totalViews == 2) {
        preKey = [NSString stringWithFormat:@"%@_0", @(pre)];
        middleKey = [NSString stringWithFormat:@"%@_0", @(self.currentIndex)];
        nextKey = [NSString stringWithFormat:@"%@_1", @(next)];
    }
    
    UIView *prevView = [reuseViews objectForKey:preKey];
    if (!prevView) {
        prevView = [self.dataSource cycleScrollView:self viewAtIndex:pre];
        [reuseViews setObject:prevView forKey:preKey];
    }
    [self updateContentOffset:prevView forIndex:pre];
    [self.currentViews addObject:prevView];
    
    UIView *middleView = [reuseViews objectForKey:middleKey];
    if (!middleView) {
        middleView = [self.dataSource cycleScrollView:self viewAtIndex:self.currentIndex];
        [reuseViews setObject:middleView forKey:middleKey];
    }
    m_currentItemView = middleView;
    [self updateContentOffset:middleView forIndex:self.currentIndex];
    [self.currentViews addObject:middleView];
    
    UIView *nextView = [reuseViews objectForKey:nextKey];
    if (!nextView) {
        nextView = [self.dataSource cycleScrollView:self viewAtIndex:next];
        [reuseViews setObject:nextView forKey:nextKey];
    }
    [self updateContentOffset:nextView forIndex:next];
    [self.currentViews addObject:nextView];
    
    if (reuseViews.count > REUSE_VIEW_COUNT) {
        for (NSString *key in reuseViews.allKeys) {
            if ([self viewNeedDeleteForKey:key]) {
                [reuseViews removeObjectForKey:key];
            }
        }
    }
}


- (void)saveContentOffset:(UIView *)view forIndex:(NSInteger)index
{
    [self updateContentOffset:view forIndex:index isSave:YES];
}

- (void)updateContentOffset:(UIView *)view forIndex:(NSInteger)index
{
    [self updateContentOffset:view forIndex:index isSave:NO];
}

- (void)updateContentOffset:(UIView *)view forIndex:(NSInteger)index isSave:(BOOL)isSave
{
    UIScrollView *scrollView;
    if ([view isKindOfClass:[UIScrollView class]]) {
        scrollView = (UIScrollView *)view;
    }
    if (!scrollView && view.subviews.count > 0 && [[view.subviews objectAtIndex:0] isKindOfClass:[UIScrollView class]]) {
        scrollView = (UIScrollView *)[view.subviews objectAtIndex:0];
    }
    if (scrollView) {
        NSNumber *contentOffsetKey = @(index);
        if (isSave) {
            [itemContentOffsets setObject:NSStringFromCGPoint(scrollView.contentOffset) forKey:contentOffsetKey];
        } else if ([itemContentOffsets.allKeys containsObject:contentOffsetKey]) {
            scrollView.contentOffset = CGPointFromString([itemContentOffsets objectForKey:contentOffsetKey]);
        }
        
        scrollView.scrollsToTop = (index == self.currentIndex);
    }
}

- (BOOL)viewNeedDeleteForKey:(NSString *)key
{
    if (self.totalViews > REUSE_VIEW_COUNT) {
        int half = (REUSE_VIEW_COUNT - 1) / 2;
        
        for (NSInteger i = 0; i <= half; i++) {
            NSInteger page = [self validCyclePage:self.currentIndex - i];
            if ([key integerValue] == page) {
                return NO;
            }
        }
        
        for (NSInteger i = 1; i <= half; i++) {
            NSInteger page = [self validCyclePage:self.currentIndex + i];
            if ([key integerValue] == page) {
                return NO;
            }
        }
        
        return YES;
    }
    
    return NO;
}

- (void)removeCycleViews
{
    //从scrollView上移除所有的subview
    NSArray *subViews = [self.scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self.currentViews removeAllObjects];
}

- (NSInteger)validPageValue:(NSInteger)value {
    
    if(value == -1) value = self.totalViews - 1;
    if(value == self.totalViews) value = 0;
    
    return value;
    
}

- (NSInteger)validCyclePage:(NSInteger)page
{
    if (page >= self.totalViews) {
        return page - self.totalViews;
    }
    if (page < 0) {
        return self.totalViews + page;
    }
    return page;
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectAtIndex:self.currentIndex];
    }
    
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    NSInteger oldIndex = _currentIndex;
    if (currentIndex == _currentIndex) {
        return;
    }
    
    //save current offset
    [self saveContentOffset:[self.currentViews objectAtIndex:1] forIndex:_currentIndex];
    
    _currentIndex = currentIndex;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cycleScrollView:changeToIndex:fromIndex:)]) {
        [self.delegate cycleScrollView:self changeToIndex:currentIndex fromIndex:oldIndex];
    }
    [self loadData];
}

- (void)setContentSize:(CGSize)contentSize
{
    self.scrollView.contentSize = contentSize;
}

- (CGSize)contentSize
{
    return self.scrollView.contentSize;
}

#pragma mark - auto play method

- (void)startAutoPlay:(NSTimeInterval)timeInterval
{
    [self stopAutoPlay];
    if (timeInterval <= 0 || self.totalViews < 2) {
        return;
    }
    autoPlayTimeInterval = timeInterval;
    self.autoPlayTimer = [NSTimer timerWithTimeInterval:timeInterval
                                                 target:self
                                               selector:@selector(timeCountDown:)
                                               userInfo:nil
                                                repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.autoPlayTimer forMode:NSRunLoopCommonModes];
}

- (void)stopAutoPlay
{
    if (self.autoPlayTimer && self.autoPlayTimer.isValid) {
        [self.autoPlayTimer invalidate];
    }
    self.autoPlayTimer = nil;
}

- (void)timeCountDown:(NSTimer *)timer
{
    isAutoScroll = YES;
    if (self.currentIndex == 0) {
        [self toNext];
        scrollDirection = CycleScrollViewScrollDirectionNext;
        return;
    }
    if (self.currentIndex == self.totalViews - 1) {
        [self toNext];
        scrollDirection = CycleScrollViewScrollDirectionPrev;
        return;
    }
    if (scrollDirection == CycleScrollViewScrollDirectionNext) {
        [self toNext];
    }else if (scrollDirection == CycleScrollViewScrollDirectionPrev) {
        [self toNext];
    }
}

- (void)toNext
{
    if (isAutoScroll) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    
    self.currentIndex = [self validPageValue:self.currentIndex + 1];
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.sizeW, 0) animated:isAutoScroll];
}

- (void)toPrev
{
    if (isAutoScroll) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.sizeW * 2, 0) animated:NO];
    }
    self.currentIndex = [self validPageValue:self.currentIndex - 1];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.sizeW, 0) animated:isAutoScroll];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    if(self.totalViews <= 0 || isAutoScroll)
    {
        [self stopAutoPlay];
        return;
    }
    
    if (!self.isScrollEnd) {
        [self stopAutoPlay];
    }else{
        [self startAutoPlay:autoPlayTimeInterval];
        isAutoScroll = NO;
        return;
    }
    
    int x = aScrollView.contentOffset.x;
    
    //往下翻
    if(x >= (2 * self.frame.size.width)) {
        [self toNext];
    }
    
    //往上翻
    if(x <= 0) {
        [self toPrev];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
    [self startAutoPlay:autoPlayTimeInterval];
    if (self.isScrollEnd) {
        isAutoScroll = NO;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
    [self startAutoPlay:autoPlayTimeInterval];
    if (self.isScrollEnd) {
        isAutoScroll = NO;
    }
}

- (UIView *)currentItemView
{
    return m_currentItemView;
}

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"frame"];
    [self stopAutoPlay];
    [self removeCycleViews];
    self.scrollView = nil;
    self.currentViews = nil;
    [reuseViews removeAllObjects];
    reuseViews = nil;
    [itemContentOffsets removeAllObjects];
    itemContentOffsets = nil;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGRect old = [[change objectForKey:@"old"] CGRectValue];
    CGRect new = [[change objectForKey:@"new"] CGRectValue];
    if (new.size.width != old.size.width) {
        NSInteger currentIndex = self.currentIndex;
        [self reloadData];
        if (currentIndex != 0) {
            self.currentIndex = currentIndex;
        }
    }
}

@end
