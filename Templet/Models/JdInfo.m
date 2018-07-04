//
//  JdInfo.m
//  Templet
//
//

#import "JdInfo.h"

@implementation JdInfo
+ (instancetype)JdDetailInfoModelWithDict:(NSDictionary *)dict
{
    JdInfo *model = [[self alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

@end
