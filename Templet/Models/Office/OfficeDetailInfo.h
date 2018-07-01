//
//  OfficeDetailInfo.h
//  Templet
//
//  Created by 丁一明 on 2018/7/1.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfficeDetailInfo : NSObject
@property (nonatomic, strong) NSString *applyDeptName;
@property (nonatomic, strong) NSMutableArray *photoList;
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *meetingName;
@property (nonatomic, strong) NSNumber *staffNum;
@property (nonatomic, strong) NSString *createName;
@property (nonatomic, strong) NSString *internalName;
@property (nonatomic, strong) NSString *meetingCategory;
@property (nonatomic, strong) NSString *meetingReason;
@property (nonatomic, strong) NSString *trainEnd;
@property (nonatomic, strong) NSString *expendType_code;
@property (nonatomic, strong) NSString *meetingPlace;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *internalId;
@property (nonatomic, strong) NSNumber *budgetAmount;
@property (nonatomic, strong) NSString *meetingTime;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSString *expendType;
@property (nonatomic, strong) NSString *check_state;
@property (nonatomic, strong) NSString *expendId;
@property (nonatomic, strong) NSNumber *estimatedNum;
@end
