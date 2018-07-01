//
//  UIColor+Convert.m
//  CustomerTool
//
//  Created by liusc on 14-11-24.
//  Copyright (c) 2014年 GFD. All rights reserved.
//

#import "UIColor+Util.h"

@implementation UIColor (Util)

/**
 *  将十六进制数字转换为UIColor
 *
 *  @param hex 十六进制数字
 *
 *  @return UIColor
 */
+ (UIColor*)colorWithHex:(int)hex {
    
//    float red = ((hex & 0xFF0000) >> 16)/255.0;
//    float green = ((hex & 0xFF00) >> 8)/255.0;
//    float blue = (hex & 0xFF)/255.0;
//    NSLog(@"red = %f green = %f blue = %f",red,green,blue);
    
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0
                           alpha:1.0];
}

+ (UIColor*)colorWithHex:(int)hex alpha:(float) alpha {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0
                           alpha:alpha];
    
}

+ (UIColor*)colorWithHexStr:(NSString *)hex {
    if (hex) {
        int lcolorint =  (int)strtoul([hex UTF8String], 0, 16);
        
        return [UIColor colorWithRed:((float)((lcolorint & 0xFF0000) >> 16))/255.0
                               green:((float)((lcolorint & 0xFF00) >> 8))/255.0
                                blue:((float)(lcolorint & 0xFF))/255.0
                               alpha:1.0];
    }else{
        return [UIColor colorWithRed:255.0
                               green:255.0
                                blue:255.0
                               alpha:1.0];
    }
}


@end
