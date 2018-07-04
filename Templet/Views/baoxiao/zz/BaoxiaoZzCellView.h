//
//  BaoxiaoZzCellView.h
//  Templet
//
//
#import <UIKit/UIKit.h>
#import "BaoxiaoZz.h"
//创建协议
@protocol VcDDelegate <NSObject>
- (void)deleteZzItem:(NSInteger)position; //删除通知
- (void)onNotifyChange;//金钱变动通知
@end

@interface BaoxiaoZzCellView : UIView
@property (nonatomic, weak) id<VcDDelegate> delegate;

-(void)passViewOfficeList:(NSMutableArray *)officeList position:(NSInteger)position;
-(void)passViewOfficeList:(NSMutableArray *)officeList position:(NSInteger)position parent:(id) parent;
-(void)setDefaultText:(BaoxiaoZz*)zzInfo;
@end
