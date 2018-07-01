//
//  todoListInfo.m
//  Templet
//
//  Created by 丁一明 on 2018/6/18.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "TodoListInfo.h"

@implementation TodoListInfo

- (instancetype)initWithTitle:(NSString *)title
                          fee:(NSString *)fee
                    applyTime:(NSString *)applyTime
                    applyPerson:(NSString *)applyPerson
                        department:(NSString*)department
{
    self = [super init];
    if (self) {
        self.title = title;
        self.fee = fee;
        self.applyTime = applyTime;
        self.applyPerson = applyPerson;
        self.department = department;
    }
    return self;
}



@end
