//
//  TravelINfo.m
//  Templet
//
//  Created by 王俊杰 on 2018/7/5.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "TravelInfo.h"

@implementation TravelInfo
+ (instancetype)TravelInfoModelWithDict:(NSDictionary *)dict
{
    TravelInfo *model = [[self alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}
@end
