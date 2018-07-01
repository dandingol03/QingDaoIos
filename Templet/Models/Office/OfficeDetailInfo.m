//
//  OfficeDetailInfo.m
//  Templet
//
//  Created by 丁一明 on 2018/7/1.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "OfficeDetailInfo.h"

@implementation OfficeDetailInfo

+ (instancetype)OfficeDetailInfoModelWithDict:(NSDictionary *)dict
{
    OfficeDetailInfo *model = [[self alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

@end
