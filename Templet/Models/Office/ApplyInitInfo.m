//
//  ApplyInfo.m
//  Templet
//
//  Created by 丁一明 on 2018/6/24.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "ApplyInitInfo.h"

@implementation ApplyInitInfo

+ (instancetype)ApplyInfoModelWithDict:(NSDictionary *)dict
{
    ApplyInitInfo *model = [[self alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

@end
