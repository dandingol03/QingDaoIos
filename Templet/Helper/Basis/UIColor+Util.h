//
//  UIColor+Convert.h
//  CustomerTool
//
//  Created by liusc on 14-11-24.
//  Copyright (c) 2014年 GFD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util)

/**
 *  将十六进制数字转换为UIColor
 *
 *  @param hex 十六进制数字
 *
 *  @return UIColor
 */
+ (UIColor*)colorWithHex:(int)hex;



+ (UIColor*)colorWithHex:(int)hex alpha:(float) alpha;


+ (UIColor*)colorWithHexStr:(NSString *)hex;
@end
