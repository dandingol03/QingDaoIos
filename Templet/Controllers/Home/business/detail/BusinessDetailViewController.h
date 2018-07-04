//
//  TravelDetailViewController.h
//  Templet
//
//

#import <UIKit/UIKit.h>
#import "BobBaseListViewController.h"
#import "OfficeListCellView.h"

@interface BusinessDetailViewController : BobBaseListViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,VcDDelegate>

@property (strong, nonatomic) NSString *expendId;

@end
