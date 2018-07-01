//
//  ApplyInfo.m
//  Templet
//
//  Created by 丁一明 on 2018/6/24.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "ApplyInfo.h"

@implementation ApplyInfo

+ (instancetype)ApplyInfoModelWithDict:(NSDictionary *)dict
{
    ApplyInfo *model = [[self alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

@end
