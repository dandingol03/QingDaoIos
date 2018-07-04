//
//  NewBusinessUIViewController.h
//  Templet
//
//  Created by 王俊杰 on 2018/7/4.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BobBaseListViewController.h"
#import "OfficeListCellView.h"

@interface NewBusinessUIViewController : BobBaseListViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,VcDDelegate>
-(void)deleteOfficeListCell:(NSInteger)position;
@end
