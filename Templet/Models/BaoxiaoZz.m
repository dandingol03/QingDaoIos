//
//  BaoxiaoZz.m
//  Templet
//
//  Created by 王俊杰 on 2018/7/4.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "BaoxiaoZz.h"

@implementation BaoxiaoZz
+ (instancetype)BaoxiaoZzModelWithDict:(NSDictionary *)dict
{
    BaoxiaoZz *model = [[self alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}
@end
