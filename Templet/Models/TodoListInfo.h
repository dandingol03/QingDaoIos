//
//  todoListInfo.h
//  Templet
//
//  Created by 丁一明 on 2018/6/18.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodoListInfo : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *fee;
@property (nonatomic, strong) NSString *applyTime;
@property (nonatomic, strong) NSString *applyPerson;
@property (nonatomic, strong) NSString *department;

- (instancetype)initWithTitle:(NSString *)title
                          fee:(NSString *)fee
                    applyTime:(NSString *)applyTime
                    applyPerson:(NSString *)applyPerson
                        department:(NSString*)department;

@end
