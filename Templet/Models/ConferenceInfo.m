//
//  ConferenceInfo.m
//  Templet
//
//  Created by 王俊杰 on 2018/7/3.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "ConferenceInfo.h"

@interface ConferenceInfo ()

@end

@implementation ConferenceInfo

+ (instancetype)ConferenceDetailInfoModelWithDict:(NSDictionary *)dict
{
    ConferenceInfo *model = [[self alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}


@end

