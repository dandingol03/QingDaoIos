//
//  AppConfig.h
//  GuXianSheng
//
//  Created by Cheney on 6/13/15.
//  Copyright (c) 2015 BobAngus. All rights reserved.
//

#ifndef GuXianSheng_AppConfig_h
#define GuXianSheng_AppConfig_h


#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//风险揭示书
#define RiskDisclosureUrl @"https://h5.api.guxiansheng.cn/compliance/contract.html"

#define AppMD5Secret @"jiaoyisuo@2017" 

#pragma mark - 通知相关参数定义
#define ReloadMemberInfoCenter @"ReloadMemberInfoCenter"    //单点登录
#define QuotationsBannerCenter @"QuotationsBannerCenter"    //行情首页Banner数据刷新
#define QuotationsCellCenter @"QuotationsCellCenter"        //行情cell数据刷新
#define KlineCenter @"KlineCenter"        //行情cell数据刷新
#define KuserCenter @"KuserCenter"        //个人中心认证按钮
#define KoderCenter @"KoderCenter"        //刷新委托列表数据
#define kSwitchMoneyFor @"kSwitchMoneyFor"        //选择币对
#define KTabbarItem @"KTabbarItem"        //行情cell数据刷新

//#define ReloadMemberInfoCenter @"ReloadMemberInfoCenter"//单点登录

#define countdown  60

// 通用颜色值
#pragma mark - 通用颜色值定义 fall

#define COLOR_MAIN  0X2562A1
#define COLOR_BACKGROUND 0XF5F5F5
#define COLOR_SEPERATE_LINE 0XDBDBDB

#define COLOR_MAIN2  0X2882E0
#define COLOR_STOCK_COLOR_ZHANG 0Xff2d5c
#define COLOR_STOCK_COLOR_DIE 0X1de9b6
//#define COLOR_STOCK_XuXian 0x323758
//#define COLOR_STOCK_MA5 0xFFFFFF
//#define COLOR_STOCK_MA10 0xFFD400
//#define COLOR_STOCK_MA30 0x21B9F0


//发送验证码 类型
//1=手机号码注册
//2=绑定手机号码
//3=修改手机号码
//4=绑定邮箱
//5=修改登录密码
//6=设置资金密码
//7=修改资金密码
//8=设置交易验证
//11=添加数字货币地址
//12=修改数字货币地址
//13=数字货币提现
//14=关闭手机验证
//15=修改邮箱

//1-邮箱注册
//2-绑定邮箱
//3-找回密码
typedef NS_ENUM(NSInteger, SmsType) {
    //    verifycode_sms
    SmsTypePhone    = 1,
    SmsTypePhoneBangDing  = 2,
    SmsTypePhoneXiuGai     = 3,
    SmsTypeEmailBangDing   = 4,
    SmsTypeDengLuMiMaXiuGai   = 5,
    SmsTypeSheZhiZiJinMiMa   = 6,
    SmsTypeXiuGaiZiJinMiMa   = 7,
    SmsTypeSheZhiJiaoYiMiMa   = 8,
    SmsTypeGuanBiPhoneYanZheng   = 14,
    SmsTypeXiuGaiEmail   = 15,
    
    //    verifycode_email
    SmsTypeEmailZhuCe   = 100,
    SmsTypeEmailBangDing2   = 101,
    SmsTypeEmailZhaoHui   = 102,
    
};


//分时 K线 类型
typedef NS_ENUM(NSInteger, kCandleType) {
    kCandleTypeMinutes      = 1,    //分时
    kCandleTypeMinute       = 2,    //一分钟
    kCandleTypeTwoMinutes   = 3,    //两分钟
    kCandleTypeFiveMinutes  = 4,    //五分钟
    kCandleTypeFifteenMinutes   = 5,    //十五分钟
    kCandleTypeAnHour           = 6,    //一小时
    kCandleTypeOneDay           = 7,    //一小时
    
};

//// K线移动方向
//typedef enum:NSInteger{
//    kChartDirectionNone,
//    kChartDirectionUp,
//    kChartDirectionDown,
//    kChartDirectionRight,
//    kChartDirectionLeft
//}ChartDirection;//枚举方向
//
////指标类型
//typedef NS_ENUM(NSInteger,ChartType){
//    ChartTypeWithPrice  = 0,
//    ChartTypeWithMA5    = 1,
//    ChartTypeWithMA10   = 2,
//    ChartTypeWithMA20   = 3,
//    ChartTypeWithMA30   = 4,
//    ChartTypeWithMA60 =    41,
//    ChartTypeWithVOL    = 5,
//    ChartTypeWithMACD   = 6,
//    ChartTypeWithKDJ    = 7,
//    ChartTypeWithCDTD   = 8,    //股机1 抄底逃顶
//    ChartTypeWithGSDQS   = 9,    //股机2 神股大趋势
//    ChartTypeWithDKJX  = 10,   //股机3 多空解析
//    
//    ChartTypeWithKDJ1    = 11,
//    ChartTypeWithKDJ2    = 12,
//    ChartTypeWithKDJ3    = 13,
//};
//
////指标 类型
//typedef NS_ENUM(NSInteger, ZhiBiaoType) {
//    ZhiBiaoTypeChengJiaoLiang   = 1,
//    ZhiBiaoTypeMACD             = 2,
//    ZhiBiaoTypeChaoDiTaoDing    = 3,
//    ZhiBiaoTypeShenGuDaQuShi    = 4,
//    ZhiBiaoTypeDuoKongJieXi     = 5,
//    ZhiBiaoTypeKDJ              = 6
//};
//




//Bnner 类型
typedef NS_ENUM(NSInteger, StockBannerType) {
    StockBannerTypeDefault      = 0,
    StockBannerTypeJinRiReDian  = 1,
    StockBannerTypeCelueBao     = 2,
    HitArticleTypeJinRiReDian   = 26,
};

#define kHangQingsx_gao     1
#define kHangQingsx_zhong   3
#define kHangQingsx_die     5
#define kHangQingsx_yibandie    10
#define kHangQingsx_hendie  15
#define kHangQingsx_tedie   20


//行情股票类型
typedef NS_ENUM(NSInteger, HomeMainViewsType) {
    homeMainViewsWithHome     = 1,//指数列表
    homeMainViewsWithCeLueBao    = 2,//板块列表
    homeMainViewsWithCaiXueTang       = 3,//
};





//K线
typedef enum {
    CandleStickChartTypeCandle  = 101,
    CandleStickChartTypeBar     = 102,
    CandleStickChartTypeLine    = 103
} CandleStickChartType;


typedef enum {
    ChartViewTypeVOL    = 101,
    ChartViewTypeMACD   = 102,
    ChartViewTypeKDJ    = 103,
    ChartViewTypeRSI    = 104,
    ChartViewTypeWR     = 105,
    ChartViewTypeCCI    = 106,
    ChartViewTypeBOLL   = 107
} ChartViewType;


//K线 类型 Horizontal,vertical
typedef NS_ENUM(NSInteger, KlineSupportType) {
    KlineSupportTypeVertical        = 1,    //竖屏
    KlineSupportTypeHorizontal      = 2,    //横屏
};


#endif

