//
//  JdInfo.h
//  Templet
//
//

#import <Foundation/Foundation.h>

@interface JdInfo : NSObject
@property (nonatomic, strong) NSString *jdtype;
@property (nonatomic, strong) NSString *letterNo;
@property (nonatomic, strong) NSString *guestUnit;
@property (nonatomic, strong) NSString *nameAndPost;
@property (nonatomic, strong) NSString *jc_time;
@property (nonatomic, strong) NSString *jc_address;
@property (nonatomic, strong) NSString *zs_address;
@property (nonatomic, strong) NSNumber *zs_days;
@property (nonatomic, strong) NSString *yj;
@property (nonatomic, strong) NSString *jdzs_money;
@property (nonatomic, strong) NSString *jdhs_money;
@property (nonatomic, strong) NSString *jdqt_money;
@property (nonatomic, strong) NSString *receptionOject;
@property (nonatomic, strong) NSNumber *visitorNum;
@property (nonatomic, strong) NSString *activityContent;
@property (nonatomic, strong) NSNumber *accompanyNum;
@property (nonatomic, strong) NSNumber *receptionBudget;
@property (nonatomic, strong) NSString *applyDeptName;
@property (nonatomic, strong) NSMutableArray *photoList;
@property (nonatomic, strong) NSMutableArray *recordList;
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *createName;
@property (nonatomic, strong) NSString *internalName;
@property (nonatomic, strong) NSString *expendType_code;
@property (nonatomic, strong) NSString *internalId;
@property (nonatomic, strong) NSNumber *budgetAmount;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *expendType;
@property (nonatomic, strong) NSString *check_state;
@property (nonatomic, strong) NSString *expendId;
@property (nonatomic) BOOL isLoan;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, strong) NSString *cashContent;
@end
