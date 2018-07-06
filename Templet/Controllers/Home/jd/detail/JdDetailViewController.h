//
//  JdDetailViewController.h
//  Templet
//
//

#import <UIKit/UIKit.h>

@interface JdDetailViewController : BobBaseListViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) NSString *expendId;
@end
