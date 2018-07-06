//
//  CultivateDetailViewController.h
//  Templet
//
//

#import <UIKit/UIKit.h>
#import "BobBaseListViewController.h"
#import "OfficeListCellView.h"

@interface CultivateDetailViewController : BobBaseListViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) NSString *expendId;
@end
