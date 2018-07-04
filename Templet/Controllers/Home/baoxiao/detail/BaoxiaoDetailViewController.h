//
//  BaoxiaoDetailViewController.h
//  Templet
//
//

#import <UIKit/UIKit.h>
#import "BobBaseListViewController.h"
#import "OfficeListCellView.h"


@interface BaoxiaoDetailViewController : BobBaseListViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,VcDDelegate>
@property (strong, nonatomic) NSString *reimbId;
@end
