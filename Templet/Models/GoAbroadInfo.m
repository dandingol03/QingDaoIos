//
//  GoAbroadInfo.m
//  Templet
//
//  Created by 王俊杰 on 2018/7/4.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "GoAbroadInfo.h"

@implementation GoAbroadInfo
+ (instancetype)GoAbroadDetailInfoModelWithDict:(NSDictionary *)dict
{
    GoAbroadInfo *model = [[self alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}
@end
