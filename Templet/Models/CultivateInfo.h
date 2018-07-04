//
//  CultivateInfo.h
//  Templet
//
//  Created by 王俊杰 on 2018/7/3.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CultivateInfo : NSObject
@property (nonatomic, strong) NSString *applyDeptName;
@property (nonatomic, strong) NSMutableArray *photoList;
@property (nonatomic, strong) NSMutableArray *recordList;
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *trainName;
@property (nonatomic, strong) NSNumber *trainStaffNum;
@property (nonatomic, strong) NSString *createName;
@property (nonatomic, strong) NSString *internalName;
@property (nonatomic, strong) NSString *meetingCategory;
@property (nonatomic, strong) NSString *meetingReason;
@property (nonatomic, strong) NSString *trainEnd;
@property (nonatomic, strong) NSString *expendType_code;
@property (nonatomic, strong) NSString *trainPlace;
@property (nonatomic, strong) NSString *internalId;
@property (nonatomic, strong) NSNumber *budgetAmount;
@property (nonatomic, strong) NSString *trainTime;
@property (nonatomic, strong) NSString *trainLeave;
@property (nonatomic, strong) NSString *trainReport;
@property (nonatomic, strong) NSString *trainBudget;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *expendType;
@property (nonatomic, strong) NSString *check_state;
@property (nonatomic, strong) NSString *expendId;
@property (nonatomic, strong) NSNumber *trainNum;
@property (nonatomic) BOOL isLoan;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, strong) NSString *cashContent;
@property (nonatomic, strong) NSString *trainObject;
@end
