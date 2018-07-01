//
//  NSString+Util.m
//  GuXianSheng
//
//  Created by Cheney on 5/5/15.
//  Copyright (c) 2015 BobAngus. All rights reserved.
//

#import "NSString+Util.h"
#import "CommonCrypto/CommonDigest.h"
//#import "SystemService.h"
#import "NSDate+Util.h"
#import "DeviceHelper.h"

@implementation NSString (Util)



- (NSString*)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (NSString*)alltTrim
{
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSArray *parts = [self componentsSeparatedByCharactersInSet:whitespaces];
    
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    
    
    return [filteredArray componentsJoinedByString:@""];
}

- (NSString*)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    unsigned int length = (unsigned int)strlen(cStr);
    CC_MD5(cStr, length, result);
    
    NSString *resultText = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                            result[0], result[1], result[2], result[3],
                            result[4], result[5], result[6], result[7],
                            result[8], result[9], result[10], result[11],
                            result[12], result[13], result[14], result[15]
                            ];
    
    return [resultText lowercaseString];
}


/**
 *  将日期转换为字符串
 *
 *  @param date 日期
 *  @param formatString 格式字符串
 *
 *  @return 字符串
 */
+ (NSString*)converDateToString:(NSDate*)date
                   FormatString:(NSString*)formatString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    return [formatter stringFromDate:date];
}

/**
 *  将时间戳转换为日期
 *
 *  @param timestamp    时间戳
 *  @param formatString 格式字符串
 *
 *  @return 日期
 */
+ (NSDate*)converTimestampToDate:(long long)timestamp
                    FormatString:(NSString*)formatString
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    return date;
}

- (BOOL)hasNonWhitespaceText {
//    if ((NSNull *)self == [NSNull null]) {
//        return NO;
//    }else
        if ([self isKindOfClass:[NSNull class]]) {
        return NO;
    }
    return [self trim].length > 0;
}

- (BOOL)containsString:(NSString *)string {
    NSRange range = [self rangeOfString:string];
    return range.location != NSNotFound;
}

- (BOOL)isNumber {
    return [self isMatchRegex:@"^[0-9]+$"];
}

- (BOOL)isEmailAddress {
    return [self isMatchRegex:@"^[\\w`~!#$%^&*\\-+={}\\\\|:'./?]+@[\\w-]+(\\.[\\w-]+)+$"];
}

- (BOOL)isCellPhoneNumber {
//    return [self isMatchRegex:@"^(0|86|17951)?1[0-9]{10}$"];
//    return [self isMatchRegex:@"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$"];

    return [self isMatchRegex:@"^1\\d{10}$"];
}
- (BOOL)isCellQQNumber {
    return [self isMatchRegex:@"^[1-9]\\d{5,10}"];
}

- (BOOL)isMatchRegex:(NSString *)regex {
    return [self isMatchRegex:regex ignoreCase:NO];
}

- (BOOL)isMatchRegex:(NSString *)regex ignoreCase:(BOOL)ignoreCase {
    NSStringCompareOptions options = NSRegularExpressionSearch;
    
    if (ignoreCase) {
        options = options | NSCaseInsensitiveSearch;
    }
    
    NSRange range = [self rangeOfString:regex options:options];
    
    return range.location != NSNotFound;
}

- (NSString *)utcDateStringToString
{
    return [self utcDateStringToString:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)utcDateStringToString:(NSString *)format
{
    if (self) {
        NSDate *date = [NSDate dateFromUTCString:self];
        
        return [date utcDateToString:format];
    }
    return nil;
}

- (CGSize)sizeThatFitSpan:(CGSize)maxSize font:(UIFont *)font{
    if(!self){
        return CGSizeMake(0, 0);
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@UILABEL_KERN_SPACE
                          };
    CGSize size = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}


- (CGSize)sizeThatFit:(CGSize)maxSize font:(UIFont *)font
{
    NSDictionary *attributes = @{ NSFontAttributeName: font };
    
    CGRect rect = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    CGSize size = CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
    
    return size;
}

- (NSString *)stringByTrimEnd:(NSString *)trimStr
{
    if (self && trimStr && self.length >= trimStr.length) {
        NSMutableString *tempStr = [[NSMutableString alloc] initWithString:self];
        while (YES) {
            if (tempStr.length <= trimStr.length) {
                if ([tempStr isEqualToString:trimStr]) {
                    return @"";
                }
                break;
            }
            if ([[tempStr substringFromIndex:tempStr.length - trimStr.length] isEqualToString:trimStr]) {
                tempStr = [[NSMutableString alloc] initWithString:[tempStr substringToIndex:tempStr.length - trimStr.length]];
            }else{
                break;
            }
        }
        return tempStr;
    }
    return self;
}

- (PasswordStrength)checkPasswordStrength
{
    NSString *str = self;
    NSUInteger len = str.length;
    
    BOOL hasNumChar = NO;
    BOOL hasLowerCaseChar = NO;
    BOOL hasUpperCaseChar = NO;
    BOOL hasSpeciaChar = NO;
    
    for (int i = 0; i < len; i++) {
        unichar charStr = [str characterAtIndex:i];
        
        if (charStr >= '0' && charStr <= '9') {
            hasNumChar = YES;
        } else if (charStr >= 'a' && charStr <= 'z') {
            hasLowerCaseChar = YES;
        } else if (charStr >= 'A' && charStr <= 'Z') {
            hasUpperCaseChar = YES;
        } else {
            hasSpeciaChar = YES;
        }
    }
    
    NSUInteger charTypeCount = (hasNumChar ? 1 : 0) + (hasLowerCaseChar ? 1 : 0) + (hasUpperCaseChar ? 1 : 0) + (hasSpeciaChar ? 1 : 0);
    
    if (charTypeCount >= 3 && len >= 8) {
        return PasswordStrengthStrong;
    } else if (charTypeCount >= 2 && len >= 8) {
        return PasswordStrengthNormal;
    } else {
        return PasswordStrengthWeak;
    }
}

- (NSString *)urlComponentEncodeUsingUTF8Encoding {
    return [self urlComponentEncodeUsingEncoding:NSUTF8StringEncoding];
}

-(NSString *)urlComponentEncodeUsingEncoding:(NSStringEncoding)encoding {
    NSString *str = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                          (__bridge CFStringRef)self,
                                                                                          NULL,
                                                                                          (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                          CFStringConvertNSStringEncodingToEncoding(encoding));
    return str;
}


- (NSString *)urlComponentDecodeUsingUTF8Encoding {
    return [self urlComponentDecodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlComponentDecodeUsingEncoding:(NSStringEncoding)encoding {
    NSString *str = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                          (__bridge CFStringRef)self,
                                                                                                          CFSTR(""),
                                                                                                          CFStringConvertNSStringEncodingToEncoding(encoding));
    return str;
}


- (NSString *)urlEncodedUsingUTF8Encoding {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 NULL,
                                                                                 kCFStringEncodingUTF8));
}

- (NSString *)urlDecodedUsingUTF8Encoding {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                 (__bridge CFStringRef)self,
                                                                                                 CFSTR(""),
                                                                                                 kCFStringEncodingUTF8));
}

+ (BOOL)validateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    unsigned long length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}

+ (NSString *)badgeValueWithNumber:(NSInteger)number
{
    if (number <= 0) {
        return nil;
    }
    return number > 99 ? @"99+" : [NSString stringWithFormat:@"%@", @(number)];
}

+ (NSString *)convertTime:(CGFloat)second{
    if(second < 1){
        return @"00:00";
    }
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    
    NSString *showtimeNew = [formatter stringFromDate:d];
//    if([showtimeNew isEqualToString:@"59:59"]){
//        showtimeNew = @"00:00";
//    }
    return showtimeNew;
}

-(NSString *)countNumAndChangeformatUnit2{
    
    return [DeviceHelper nsstringUnitsWith:self.doubleValue];
}

-(NSString *)countNumAndChangeformat{
    
    return [DeviceHelper nsstringFenSiUnitsWith:self.doubleValue];
}

-(NSString *)countNumAndChangeformat1{
    
    int count = 0;
    long long int a = self.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:self];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}

//奇葩新格式：数值千分号间隔符，超过100万才简写，保留一位小数点，四舍五入。如例：1,014,000  则简写为  101.4万
-(NSString *)countNumAndChangeformat2{
    
    if(self.doubleValue>=1000000){
        return [DeviceHelper nsstringFenSiUnitsWith:self.doubleValue];
    }
    
    int count = 0;
    long long int a = self.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:self];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}



-(NSString *)ChangeFormatLessThan10000:(NSString *)num{
    if (num == nil) {
        return @"";
    }
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
//        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}

-(NSString *)ChangeFormatMoreThan10000:(NSString *)num
{
    if (num == nil) {
        return @"";
    }
    float a = 0.0;
    float b = 0.0;
    if (num.integerValue >= 10000) {
        a = num.integerValue/10000.0;
    }
    if (num.integerValue - a*10000 >= 1000) {
        b = (num.integerValue - a*10000.0)/1000.0;
    }
    if (a >= 1000) {
        a = ((NSString *)[self ChangeFormatLessThan10000:[NSString stringWithFormat:@"%lf",a]]).floatValue;
    }
    return [NSString stringWithFormat:@"%0.1lf万",a+b];
}

@end
