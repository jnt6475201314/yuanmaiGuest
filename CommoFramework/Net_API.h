//
//  Net_API.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/17.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#ifndef Net_API_h
#define Net_API_h

#pragma mark - API

// 获取司机ID   driver_id
#define GETData [UserDefaults objectForKey:@"data"]
#define GETUID GETData[@"uid"]
#define GETTOKEN_Str [UserDefaults objectForKey:@"token_str"]
// 是否检测异地登录
#define RELOGIN @"relogin"   //
#define GetRELOGINStatus [UserDefaults objectForKey:RELOGIN]
//#define GETDeviceToken [UserDefaults objectForKey:@"deviceToken"]

#if 1   // 测试时使用的
#define CommonHeadUrl @"http://139.199.219.224/test/Admin/"
#endif

#if 0   // 上线时使用的
#define CommonHeadUrl @"http://202.91.248.43/Admin/"
#endif

#define CHECK_TokenStr_UrlStr [NSString stringWithFormat:@"%@AppCustomer/verify", CommonHeadUrl]  // 检查异地登录

#define guideCommonHeadUrl @"http://139.196.29.1/test/"
#define API_GETGUIDANCEIMAGE_URL [NSString stringWithFormat:@"%@/Admin/Applineorder/guideImage", guideCommonHeadUrl]     // 引导页图片
#define API_guideheadImageUrl [NSString stringWithFormat:@"%@Public/Admin_Uploads/guide_image/", guideCommonHeadUrl]
#define API_HOME_GETCYCLEIMG_URL @"http://202.91.248.43/Admin/Appline/carousel_figure"  // 获取轮播图片

#define API_LOGIN_URL [NSString stringWithFormat:@"%@App/login.html", CommonHeadUrl]  // 登录
#define API_GetVerifyCode_URL [NSString stringWithFormat:@"%@App/code.html", CommonHeadUrl]  // 获取验证码
#define API_ForgetPasswords_URL [NSString stringWithFormat:@"%@App/customer_password.html", CommonHeadUrl]  // 忘记密码
#define API_Register_URL [NSString stringWithFormat:@"%@App/zhuce.html", CommonHeadUrl]  // 注册

#define API_PublishOrderInfo_URL [NSString stringWithFormat:@"%@AppCustomer/orders.html", CommonHeadUrl]  // 发布货源信息
#define API_PublishOrderList_URL [NSString stringWithFormat:@"%@AppCustomer/releaseorder.html", CommonHeadUrl]  // 发布货源列表

#define API_OrderList_URL [NSString stringWithFormat:@"%@Apporder/order_info.html", CommonHeadUrl]  // 发布货源信息
#define API_OrderDetailInfo_URL [NSString stringWithFormat:@"%@Apporder/s_info.html", CommonHeadUrl]  // 获取运单详情
#define API_OrderDetailInfo_URL [NSString stringWithFormat:@"%@Apporder/s_info.html", CommonHeadUrl]  // 获取运单详情


#define API_DeletePublishInfo_URL [NSString stringWithFormat:@"%@AppCustomer/del.html", CommonHeadUrl]  // 删除发布信息

#define API_ModifyPersonalInfo_URL [NSString stringWithFormat:@"%@App/user_edit.html", CommonHeadUrl]  // 修改个人信息

//NSString * urlStr = [URLHEAD stringByAppendingString:@"release_delete.html"];
//#define API_OrderDetailWith(uid) [NSString stringWithFormat:@"%@Applineorder/test?id=%@", CommonHeadUrl,uid]   // 运单详情
//#define API_SCAN_URL [NSString stringWithFormat:@"%@Appdriver/scanning", CommonHeadUrl]  // 运单扫描
//#define API_OrderAction_URL [NSString stringWithFormat:@"%@Appdriver/goods_statu", CommonHeadUrl]  // 运单操作
//#define API_SUGGESTION_URL [NSString stringWithFormat:@"%@Apporder/opinion.html", CommonHeadUrl]   // 建议
#define API_UPDATEPWD_URL [NSString stringWithFormat:@"%@App/edit.html", CommonHeadUrl]      // 修改密码
//#define API_UPLoadLocation_URL [NSString stringWithFormat:@"%@Appdriver/location", CommonHeadUrl]      // 上传地址信息


//#define URLSTRING @"http://202.91.248.43/Admin/App/"
//#define URLHEAD @"http://202.91.248.43/Admin/Apporder/"

//#pragma mark - Methods
//
//#define GETUserInfoData [[NSUserDefaults standardUserDefaults] objectForKey:@"data"]
//#define GETUID GETUserInfoData[@"uid"]
//
//#define CHECK_TokenStr_UrlStr [NSString stringWithFormat:@"%@Appdriver/verify", CommonHeadUrl]  // 检查异地登录
//
//#define guideCommonHeadUrl @"http://139.196.29.1/test/"
//#define API_GETGUIDANCEIMAGE_URL [NSString stringWithFormat:@"%@/Admin/Applineorder/guideImage", guideCommonHeadUrl]     // 引导页图片
//#define API_guideheadImageUrl [NSString stringWithFormat:@"%@Public/Admin_Uploads/guide_image/", guideCommonHeadUrl]
//
//#define API_HOME_GETCYCLEIMG_URL @"http://202.91.248.43/Admin/Appline/carousel_figure"  // 获取轮播图片
//#define API_homeCycleHeadImgUrl [NSString stringWithFormat:@"%@/Public/Uploads/carousel_figure/", ForTestCommonHeadUrl]
//
//#define API_LOGIN_URL [NSString stringWithFormat:@"%@App/do_login.html", CommonHeadUrl]  // 登录
//#define API_GetVerifyCode_URL [URLSTRING stringByAppendingString:@"code.html"]  // 获取验证码
//#define API_ForgetPasswords_URL [URLSTRING stringByAppendingString:@"customer_password.html"]  // 忘记密码
//#define API_Register_URL [URLSTRING stringByAppendingString:@"zhuce.html"]  // 注册
//#define API_ResourceOfOrders_URL [NSString stringWithFormat:@"%@Appdriver/goods_info", CommonHeadUrl]  // 获取货源数据
//#define API_OrderDetailWith(uid) [NSString stringWithFormat:@"%@Applineorder/test?id=%@", CommonHeadUrl,uid]   // 运单详情
//#define API_SCAN_URL [NSString stringWithFormat:@"%@Appdriver/scanning", CommonHeadUrl]  // 运单扫描
//#define API_OrderAction_URL [NSString stringWithFormat:@"%@Appdriver/goods_statu", CommonHeadUrl]  // 运单操作
//#define API_SUGGESTION_URL [NSString stringWithFormat:@"%@Apporder/opinion.html", CommonHeadUrl]   // 建议
//#define API_UPDATEPWD_URL [NSString stringWithFormat:@"%@App/edit.html", CommonHeadUrl]      // 修改密码
//#define API_UPLoadLocation_URL [NSString stringWithFormat:@"%@Appdriver/location", CommonHeadUrl]      // 上传地址信息

#endif /* Net_API_h */
