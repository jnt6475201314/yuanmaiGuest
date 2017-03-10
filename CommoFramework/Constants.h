//
//  Constants.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/14.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

// 系统的版本判断
#define kSysVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#define iOS8Later (kSysVersion >= 8.0f)
#define iOS7Later (kSysVersion >= 7.0f)
#define iOS6Later (kSysVersion >= 6.0f)

#define iOS7 (kSysVersion >= 7.0f && kSysVersion < 8.0f)

//图片宽度
#define pic_width (screen_width-5*4-10*2)/5
//背景颜色
#define background_color color(244, 244, 244, 1)
//app默认橙色
#define pink_color color(238, 109, 140, 1)
#define blue_color color(70, 150, 252, 1)
#define red_color color(247, 43, 43, 1)
//文本颜色
#define default_text_color color(57, 57, 70, 1)
//tabBar颜色
#define navBar_color color(67, 89, 224, 1)
//tabBar颜色
#define tabBar_color color(255, 255, 255, 1)
//边框颜色
#define pic_borderColor color(229, 229, 229, 1)
//分割线颜色
#define sepline_color color(242, 242, 242, 1)
//广告视图高度
#define adver_picHeight 150

#define imageView_width 50

#define iPhone6                                                                \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(750, 1334),                              \
[[UIScreen mainScreen] currentMode].size)           \
: NO)
#define iPhone6Plus                                                            \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(1242, 2208),                             \
[[UIScreen mainScreen] currentMode].size)           \
: NO)
#define AppDelegateInstance ((AppDelegate*)([UIApplication sharedApplication].delegate))

// 判断输入是否为数字和字母的 密码正则表达式
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

//高德配置
#define GAODEMAP_APIKEY @"bcc021ddc512ceab0a4df9d112cbd144"
//融云基础设置
#define SERVICE_ID @"KEFU145829438876942"
#define RONGCLOUD_IM_APPKEY @"25wehl3uwm6kw"
#define RONGCLOUD_IM_USER_TOKEN @"H9jiUyfYboCeMoq7s6xjdhUemNGWtqIdEqgZhC0uPXJ0zmjg46ZldwlxLp4Rj8uwp2W4svd4Skkkvmuic5cmlXeGUQDvyBU3"
//极光配置
#define JPushAppKey @"df89266798e9ab539431ff73"
#define JPushChannel @"Publish channel"
//友盟配置
#define YOUMENG_APPKEY @"58b536f565b6d6688d000858"
//------QQ-------
#define YOUMENG_QQ_ID @"1105938205"
#define YOUMENG_QQ_KEY @"6msUeDZZbAIKU5Ey"
//------WX-------
#define WEIXIN_ID @"wxf8d5e65f7981db80"
#define WEIXIN_KEY @"2afaf80969179b5a3783df5372500b94"
//------WB-------
#define YOUMENG_WEIBO_KEY @"1312967830"

#define ORDER_PAY_NOTIFICATION @"ORDER_PAY_NOTIFICATION"

#define BASE_URL @"http://digwork.gzfwwl.com:8089/"
//#define BASE_URL @"http://192.168.1.88:8080/Dig_Work/"

#define SHAREAPP_URL @"https://itunes.apple.com/cn/app/远迈物流-客户版/id1210285299?mt=8"

//token验证
#define CHECK_TOKEN_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"user/chooseToken"]//验证token

// 是否通知
#define NOTIFICATION @"notification"   //
#define GetNotificationStatus [UserDefaults objectForKey:NOTIFICATION]

#endif /* Constants_h */
