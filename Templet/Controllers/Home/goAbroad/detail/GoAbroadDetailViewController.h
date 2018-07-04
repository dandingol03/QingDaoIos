//
//  GoAbroadDetailViewController.h
//  Templet
//
//  Created by 王俊杰 on 2018/7/4.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoAbroadDetailViewController : BobBaseListViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) NSString *expendId;
@end
