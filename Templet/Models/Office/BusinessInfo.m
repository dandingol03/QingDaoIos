//
//  OfficeInfo.m
//  Templet
//
//  Created by 丁一明 on 2018/6/12.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "BusinessInfo.h"

@implementation BusinessInfo

//- (instancetype)initWithTitle:(NSString *)internalName
//                   expendType:(NSString *)expendType
//                          budgetAmount:(long)budgetAmount
//                    createTime:(NSString *)createTime
//                        state:(NSString*)state
//{
//    self = [super init];
//    if (self) {
//        self.internalName = internalName;
//        self.expendType = expendType;
//        self.budgetAmount = budgetAmount;
//        self.createTime = createTime;
//        self.state = state;
//    }
//    return self;
//}

+ (instancetype)BusinessInfoModelWithDict:(NSDictionary *)dict
{
    BusinessInfo *model = [[self alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}



@end
