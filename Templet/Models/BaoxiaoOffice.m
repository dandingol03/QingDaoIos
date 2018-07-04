//
//  BaoxiaoOffice.m
//  Templet
//
//

#import "BaoxiaoOffice.h"

@implementation BaoxiaoOffice
+ (instancetype)BusinessInfoModelWithDict:(NSDictionary *)dict
{
    BaoxiaoOffice *model = [[self alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

@end
