//
//  OfficeListDetailViewController.h
//  Templet
//
//  Created by 丁一明 on 2018/6/30.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "BobBaseListViewController.h"
#import "OfficeListCellView.h"

@interface OfficeListDetailViewController : BobBaseListViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,VcDDelegate>

@property (strong, nonatomic) NSString *expendId;

@end
