//
//  OfficeListCellView.h
//  Templet
//
//  Created by 丁一明 on 2018/6/26.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import <UIKit/UIKit.h>
//创建协议
@protocol VcDDelegate <NSObject>
- (void)deleteOfficeListCell:(NSInteger)position; //声明协议方法
@end


@interface OfficeListCellView : UIView

@property (nonatomic, weak) id<VcDDelegate> delegate;

-(void)passViewOfficeList:(NSMutableArray *)officeList position:(NSInteger)position;

@end
