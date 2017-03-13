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

#define GETData [UserDefaults objectForKey:@"data"]
#define GETUID GETData[@"uid"]
#define GETTOKEN_Str [UserDefaults objectForKey:@"token_str"]
#define GETDeviceToken [UserDefaults objectForKey:@"deviceToken"]

// 是否检测异地登录
#define RELOGIN @"relogin"   //
#define GetRELOGINStatus [UserDefaults objectForKey:RELOGIN]

#if 1   // 测试时使用的
//#define CommonHeadUrl @"http://139.199.219.224/test/Admin/"

#define CommonHeadUrl @"https://ymapp.yuanmaiwuliu.com/Admin/"
#endif

#if 0   // 上线时使用的
#define CommonHeadUrl @"http://202.91.248.43/Admin/"
#endif

#define CHECK_TokenStr_UrlStr [NSString stringWithFormat:@"%@AppCustomer/verify", CommonHeadUrl]  // 检查异地登录
#define API_uploadPushStr_URL [NSString stringWithFormat:@"%@AppPublic/GetDevice", CommonHeadUrl]  // 上传推送信息到服务器
//
#define API_GETGUIDANCEIMAGE_URL [NSString stringWithFormat:@"%@AppPublic/guideImage", CommonHeadUrl]     // 引导页图片

#define API_HOME_GETCYCLEIMG_URL [NSString stringWithFormat:@"%@AppPublic/carousel_figure", CommonHeadUrl]  // 获取轮播图片

#define API_LOGIN_URL [NSString stringWithFormat:@"%@App/login.html", CommonHeadUrl]  // 登录
#define API_GetVerifyCode_URL [NSString stringWithFormat:@"%@App/code.html", CommonHeadUrl]  // 获取验证码
#define API_ForgetPasswords_URL [NSString stringWithFormat:@"%@App/customer_password.html", CommonHeadUrl]  // 忘记密码
#define API_Register_URL [NSString stringWithFormat:@"%@App/zhuce.html", CommonHeadUrl]  // 注册

#define API_SCAN_URL [NSString stringWithFormat:@"%@Appdriver/scanning", CommonHeadUrl]  // 运单扫描
#define API_PublishOrderInfo_URL [NSString stringWithFormat:@"%@AppCustomer/orders.html", CommonHeadUrl]  // 发布货源信息
#define API_PublishOrderList_URL [NSString stringWithFormat:@"%@AppCustomer/releaseorder.html", CommonHeadUrl]  // 发布货源列表
#define API_PushlishDetailWithGid(gid) [NSString stringWithFormat:@"%@AppCustomer/CustomerOrderInfo?uid=%@&gid=%@", CommonHeadUrl,GETUID,gid]   // 发布／运单／评论 详情接口
//
#define API_CommentList_URL [NSString stringWithFormat:@"%@AppCustomer/CommentList.html", CommonHeadUrl]  // 获取评论列表
#define API_CommentOrder_URL [NSString stringWithFormat:@"%@AppCustomer/Comment.html", CommonHeadUrl]  // 评论订单
#define API_OrderCommentInfo_URL [NSString stringWithFormat:@"%@AppCustomer/CommentInfo.html", CommonHeadUrl]  // 获取订单单条评论信息

#define API_OrderAffirmArrivedAction_URL [NSString stringWithFormat:@"%@AppCustomer/CompleteOrder.html", CommonHeadUrl]  // 运单操作：确认到达
#define API_DriverCurrentLocation_URL [NSString stringWithFormat:@"%@AppPublic/Position.html", CommonHeadUrl]  // 获取订单司机位置
//
//
#define API_DeletePublishInfo_URL [NSString stringWithFormat:@"%@AppCustomer/del.html", CommonHeadUrl]  // 删除发布信息
//
#define API_UPDATEPWD_URL [NSString stringWithFormat:@"%@App/edit.html", CommonHeadUrl]      // 修改密码
#define API_ModifyPersonalInfo_URL [NSString stringWithFormat:@"%@App/user_edit.html", CommonHeadUrl]  // 修改个人信息
#define API_Suggestion_URL [NSString stringWithFormat:@"%@AppPublic/feedback", CommonHeadUrl]      // 意见反馈



#endif /* Net_API_h */
