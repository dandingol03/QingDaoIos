//
//  GoAbroadDetailViewController.h
//  Templet
//
//

#import <UIKit/UIKit.h>

@interface GoAbroadDetailViewController : BobBaseListViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) NSString *expendId;
@end
