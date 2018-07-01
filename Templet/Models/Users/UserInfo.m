//
//  UserInfo.m
//  Templet
//
//  Created by 丁一明 on 2018/6/9.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+ (instancetype)ApplyInfoModelWithDict:(NSDictionary *)dict
{
    ApplyInfo *model = [[self alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

@end
