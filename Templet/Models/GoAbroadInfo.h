//
//  GoAbroadInfo.h
//  Templet
//
//

#import <Foundation/Foundation.h>

@interface GoAbroadInfo : NSObject
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *colonel;
@property (nonatomic, strong) NSString *groupUnit;
@property (nonatomic, strong) NSString *groupNum;
@property (nonatomic, strong) NSString *visitingCountry;
@property (nonatomic, strong) NSNumber *ht_money;
@property (nonatomic, strong) NSString *visitingDay;
@property (nonatomic, strong) NSNumber *jt_money;
@property (nonatomic, strong) NSNumber *zs_money;
@property (nonatomic, strong) NSNumber *hs_money;
@property (nonatomic, strong) NSNumber *qt_money;

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
