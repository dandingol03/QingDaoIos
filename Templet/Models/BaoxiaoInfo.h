//
//  BaoxiaoInfo.h
//  Templet
//
//

#import <Foundation/Foundation.h>

@interface BaoxiaoInfo : NSObject
@property (nonatomic, strong) NSString *reimbId;
@property (nonatomic, strong) NSString *applyDeptName;
@property (nonatomic, strong) NSMutableArray *photoList;
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSNumber *staffNum;
@property (nonatomic, strong) NSString *createName;
@property (nonatomic, strong) NSString *internalName;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *trainEnd;
@property (nonatomic, strong) NSString *expendType_code;
@property (nonatomic, strong) NSString *expandTypeNum;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *internalId;
@property (nonatomic, strong) NSNumber *budgetAmount;
@property (nonatomic, strong) NSNumber *sumNum;
@property (nonatomic, strong) NSNumber *sumAmount;
@property (nonatomic, strong) NSString *createId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSNumber *offCard;
@property (nonatomic, strong) NSNumber *trans;
@property (nonatomic, strong) NSNumber *cash;
@property (nonatomic, strong) NSString *applyDeptId;
@property (nonatomic, strong) NSString *bankNum;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *dataList_zz;

@property (nonatomic, strong) NSString *expendType;
@property (nonatomic, strong) NSString *check_state;
@property (nonatomic, strong) NSString *expendId;
@property (nonatomic) BOOL isLoan;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, strong) NSString *cashContent;
@end
