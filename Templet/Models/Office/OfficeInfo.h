//
//  OfficeInfo.h
//  Templet
//
//  Created by 丁一明 on 2018/6/12.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfficeInfo : NSObject
@property (nonatomic, strong) NSString *internalName;
@property (nonatomic, strong) NSString *expendType;
@property (nonatomic, strong) NSString *expendTypeNum;
@property (nonatomic, strong) NSString *expendId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *createName;
@property (nonatomic, strong) NSString *applyDeptName;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *isEdit;
@property (nonatomic, strong) NSString *taskId;



@property (nonatomic) NSNumber *budgetAmount;

@end
