//
//  BobAlertView.h
//  GuXianSheng
//
//  Created by CavinTang on 5/16/15.
//  Copyright (c) 2015 BobAngus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertViewButtonClick) (id alertView, NSInteger buttonIndex);


@interface BobAlertView : UIAlertView

@property (strong, nonatomic) NSDictionary *userInfo;

- (void)showOnClickButton:(AlertViewButtonClick)buttonClick;

- (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
        onClickButton:(AlertViewButtonClick)buttonClick;

@end
