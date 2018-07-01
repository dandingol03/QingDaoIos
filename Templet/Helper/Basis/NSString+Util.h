//
//  NSString+Util.h
//  GuXianSheng
//
//  Created by Cheney on 5/5/15.
//  Copyright (c) 2015 BobAngus. All rights reserved.
//

#define UILABEL_LINE_SPACE 3//行间距
#define UILABEL_KERN_SPACE 1//字间距

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    PasswordStrengthWeak = 0,
    PasswordStrengthNormal = 1,
    PasswordStrengthStrong = 2
} PasswordStrength;

@interface NSString (Util)
/**
 *  将日期转换为字符串
 *
 *  @param date 日期
 *  @param formatString 格式字符串
 *
 *  @return 字符串
 */
+ (NSString*)converDateToString:(NSDate*)date
                   FormatString:(NSString*)formatString;



/**
 *  将时间戳转换为日期
 *
 *  @param timestamp    时间戳
 *  @param formatString 格式字符串
 *
 *  @return 日期
 */
+ (NSDate*)converTimestampToDate:(long long)timestamp
                    FormatString:(NSString*)formatString;
/**
 *  url中得特殊字符处理
 *
 *  @return 字符串
 */
-(NSString *)urlEncodedString:(NSString *)sourceText;
/**
 *  去除字符串的前后空格
 *
 *  @return 字符串
 */
- (NSString*)trim;
/**
 *  去除所有空格
 *
 *  @return 字符串
 */

- (NSString*)alltTrim;
/**
 *  MD5 加密
 *
 *  @param inputText 明文
 *
 *  @return 加密结果
 */
- (NSString*)md5;

/**
 *  判断是否是非空字符串
 *
 *  @return 判断结果
 */
- (BOOL)hasNonWhitespaceText;

/**
 *  判断是否包含特定字符串
 *
 *  @param string 包含的内容
 *
 *  @return 判断结果
 */
- (BOOL)containsString:(NSString *)string;

/**
 *  是否是纯数字字符串
 *
 *  @return 判断结果
 */
- (BOOL)isNumber;

/**
 *  是否是有效的邮件地址字符串
 *
 *  @return 判断结果
 */
- (BOOL)isEmailAddress;

/**
 *  是否是有效手机号 (中国)
 *
 *  @return 判断结果
 */
- (BOOL)isCellPhoneNumber;
/**
 *  是否是有效QQ号
 *
 *  @return 判断结果
 */
- (BOOL)isCellQQNumber;
/**
 *  是否与正则表达式匹配
 *
 *  @param regex 正则表达式
 *
 *  @return 判断结果
 */
- (BOOL)isMatchRegex:(NSString *)regex;

/**
 *  是否与正则表达式匹配
 *
 *  @param regex      正则表达式
 *  @param ignoreCase 是否忽略大小写
 *
 *  @return 判断结果
 */
- (BOOL)isMatchRegex:(NSString *)regex ignoreCase:(BOOL)ignoreCase;

/**
 *  将标准 UTC 日期格式字符串，格式化成特定格式字符串 (yyyy-MM-dd HH:mm:ss)
 *
 *  @return 格式化结果
 */
- (NSString *)utcDateStringToString;

/**
 *  将标准 UTC 日期格式字符串，格式化成特定格式字符串
 *
 *  @param format 格式化字符串
 *
 *  @return 格式化结果
 */
- (NSString *)utcDateStringToString:(NSString *)format;

/**
 *  计算字符串尺寸
 *
 *  @param maxSize 最大尺寸
 *  @param font    字体
 *
 *  @return 实际尺寸
 */
- (CGSize)sizeThatFit:(CGSize)maxSize font:(UIFont *)font;


/**
 *  计算字符串尺寸
 *
 *  @param maxSize 最大尺寸
 *  @param font    字体
 *  @param font    行间距
 *  @return 实际尺寸
 */
- (CGSize)sizeThatFitSpan:(CGSize)maxSize font:(UIFont *)font;



/**
 *  去除字符串后面的指定字符串
 *
 *  @param trimStr 需要去除的字符串
 *
 *  @return 去除指定字符串后的字符串
 */
- (NSString *)stringByTrimEnd:(NSString *)trimStr;


/**
 *  检查当前字符串密码强度
 *
 *  @return 密码强度
 */
- (PasswordStrength)checkPasswordStrength;

// 播放器_时间转换
+ (NSString *)convertTime:(CGFloat)second;

- (NSString *)urlComponentEncodeUsingUTF8Encoding;

- (NSString *)urlComponentDecodeUsingUTF8Encoding;

- (NSString *)urlComponentDecodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)urlEncodedUsingUTF8Encoding;

- (NSString *)urlDecodedUsingUTF8Encoding;

+ (BOOL)validateIDCardNumber:(NSString *)value;

+ (NSString *)badgeValueWithNumber:(NSInteger)number;

//格式化数字  12345-->12.3万
-(NSString *)countNumAndChangeformat;

//格式化数字 123456 -->123,456
-(NSString *)countNumAndChangeformat1;

//格式化数字 123456 -->123,456 保留两位小数
-(NSString *)countNumAndChangeformatUnit2;

//奇葩新格式：数值千分号间隔符，超过100万才简写，保留一位小数点，四舍五入。如例：1,014,000  则简写为  101.4万
-(NSString *)countNumAndChangeformat2;

@end
