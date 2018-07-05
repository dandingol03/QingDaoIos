//
//  TravelInfoCellView.h
//  Templet
//
//

#import <UIKit/UIKit.h>
#include "TravelInfo.h"

//创建协议
@protocol VcDDelegate <NSObject>
- (void)deleteTravelItem:(NSInteger)position; //删除通知
@end

@interface TravelInfoCellView : UIView
@property (nonatomic, weak) id<VcDDelegate> delegate;

-(void)passViewOfficeList:(NSMutableArray *)officeList position:(NSInteger)position parent:(id) parent;
-(void)setDefaultText:(TravelInfo*)travelInfo;
@end
