//
//  TravelINfo.h
//  Templet
//
//

#import <Foundation/Foundation.h>

@interface TravelInfo : NSObject
@property (nonatomic, strong) NSString *persons;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *city_parent;
@property (nonatomic, strong) NSString *city_town;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *type_code;
@property (nonatomic, strong) NSString *go_time;
@property (nonatomic, strong) NSString *back_time;
@property (nonatomic, strong) NSString *jt_tools;
@property (nonatomic, strong) NSString *fh_tools;
@property (nonatomic, strong) NSString *jt_tools_str;
@property (nonatomic, strong) NSString *fh_tools_str;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *b_number;
@property (nonatomic, strong) NSNumber *w_number;
@property (nonatomic, strong) NSNumber *days;
@property (nonatomic, strong) NSString *zs_jd;
@property (nonatomic, strong) NSString *sendCar;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, strong) NSNumber *fare;
@property (nonatomic, strong) NSNumber *ht_money;
@property (nonatomic, strong) NSNumber *jt_money;
@property (nonatomic, strong) NSNumber *zs_money;
@property (nonatomic, strong) NSNumber *hs_money;
@property (nonatomic, strong) NSNumber *qt_money;
@property (nonatomic, strong) NSNumber *all_money;
@property (nonatomic, strong) NSString *pers;

@property (nonatomic, strong) NSString *reimbId;
@property (nonatomic, strong) NSString *applyDeptName;
@property (nonatomic, strong) NSMutableArray *photoList;
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *createName;
@property (nonatomic, strong) NSString *internalName;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *expendType_code;
@property (nonatomic, strong) NSString *expandTypeNum;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *internalId;
@property (nonatomic, strong) NSNumber *sumNum;
@property (nonatomic, strong) NSNumber *sumAmount;
@property (nonatomic, strong) NSString *createId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *applyDeptId;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *dataList_zz;

@property (nonatomic, strong) NSString *expendType;
@property (nonatomic, strong) NSString *check_state;
@property (nonatomic, strong) NSString *expendId;
@property (nonatomic) BOOL isLoan;

@end
