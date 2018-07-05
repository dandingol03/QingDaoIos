//
//  ConferenceDetailViewController.h
//  Templet
//
//

#import <UIKit/UIKit.h>
#import "BobBaseListViewController.h"
#import "OfficeListCellView.h"

@interface ConferenceDetailViewController : BobBaseListViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) NSString *expendId;

@end
