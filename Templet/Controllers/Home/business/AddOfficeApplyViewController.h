//
//  AddOfficeApplyViewController.h
//  Templet
//
//  Created by 丁一明 on 2018/6/12.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfficeListCellView.h"


@interface AddOfficeApplyViewController :BobBaseListViewController
<UIImagePickerControllerDelegate,UINavigationControllerDelegate,VcDDelegate>

-(void)deleteOfficeListCell:(NSInteger)position;

@end
