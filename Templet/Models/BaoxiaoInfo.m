//
//  BaoxiaoInfo.m
//  Templet
//

#import "BaoxiaoInfo.h"

@implementation BaoxiaoInfo
+ (instancetype)BaoxiaoInfoModelWithDict:(NSDictionary *)dict
{
    BaoxiaoInfo *model = [[self alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}
@end
