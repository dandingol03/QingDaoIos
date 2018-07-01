//
//  BobAlertView.m
//  GuXianSheng
//
//  Created by CavinTang on 5/16/15.
//  Copyright (c) 2015 BobAngus. All rights reserved.
// 

#import "BobAlertView.h"
//#import "BobMacro.h"

@interface BobAlertView () <UIAlertViewDelegate>

@end

@implementation BobAlertView {
    AlertViewButtonClick m_buttonClick;
}

- (void)showOnClickButton:(AlertViewButtonClick)buttonClick
{
    if (buttonClick) {
        m_buttonClick = buttonClick;
        
        self.delegate = self;
    } else {
        m_buttonClick = nil;
    }
    
    [self show];
}

- (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
        onClickButton:(AlertViewButtonClick)buttonClick
{
    
    self.title = title;
    self.message = message;
    [self setCancelButtonIndex:0];
    [self addButtonWithTitle:cancelButtonTitle];
    for (NSString *buttonTitle in otherButtonTitles) {
        [self addButtonWithTitle:buttonTitle];
    }
    
    [self showOnClickButton:buttonClick];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (m_buttonClick) {
        m_buttonClick(alertView, buttonIndex);
        m_buttonClick = nil;
    }
}

@end
