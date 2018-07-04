//
//  OfficeListCellView.h
//  Templet
//
//

#import <UIKit/UIKit.h>
#import "BaoxiaoOffice.h"
//创建协议
@protocol VcDDelegate <NSObject>
- (void)deleteOfficeListCell:(NSInteger)position; //删除通知
- (void)onNotifyChange;//金钱变动通知
@end


@interface BaoxiaoOfficeCellView : UIView

@property (nonatomic, weak) id<VcDDelegate> delegate;
-(void)passViewOfficeList:(NSMutableArray *)officeList position:(NSInteger)position;
-(void)passViewOfficeList:(NSMutableArray *)officeList position:(NSInteger)position parent:(id) parent;
-(void)setDefaultText:(BaoxiaoOffice*)officeInfo;
@end
