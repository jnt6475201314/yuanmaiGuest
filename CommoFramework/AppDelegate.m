//
//  AppDelegate.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/11.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LoginViewController.h"
#import "TabBarController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<btnClickDelegate, JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [NSThread sleepForTimeInterval:1.0]; // 设置启动页时间
    [self configAPNsWithOptions:launchOptions]; // 注册通知
    
    // 启动app - 检查是否是首次启动次app
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    id haveOpen = [defaults objectForKey:@"firstOpen"];
    if (![haveOpen boolValue]) {
        ViewController * vc = [[ViewController alloc] init];
        vc.clickDelegate = self;
        self.window.rootViewController = vc;
        [defaults setValue:@"YES" forKey:@"firstOpen"];
        [UserDefaults setObject:@"YES" forKey:RELOGIN];
        [UserDefaults synchronize];
    }else{
        [self initTabBar];
    }
    
    return YES;
}

#pragma mark - btnClickDelegate
- (void)btnhaveClicked{
    [self initTabBar];
}

- (void)initTabBar{
    self.window.rootViewController = nil;
    for (UIView * view in self.window.subviews) {
        [view removeFromSuperview];
    }
    
#if 1
    // 跳转到登录界面
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = loginVC;
#endif
    
#if 0
    // 跳转到主界面
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    TabBarController *GHTabBar = [[TabBarController alloc] init];
    self.window.rootViewController = GHTabBar;
#endif
}

- (JVFloatingDrawerViewController *)drawerViewController
{
    return (JVFloatingDrawerViewController *)self.window.rootViewController;
}

#pragma mark - 通知相关
- (void)configAPNsWithOptions:(NSDictionary *)launchOptions
{
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
                          channel:JPushChannel
                 apsForProduction:YES];
    
}

#pragma mark - JPUSHRegisterDelegate
// 注册APNs成功并上报 DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    NSLog(@"%@", deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
    
    NSLog(@"deviceToken:%@",deviceToken);
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                 stringByReplacingOccurrencesOfString:@">" withString:@""]
                                stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceTokenStr:%@",deviceTokenStr);
    if (deviceToken) {
        [UserDefaults setObject:deviceTokenStr forKey:@"deviceToken"];
        [UserDefaults synchronize];
    }else
    {
        [UserDefaults setObject:@"" forKey:@"deviceToken"];
        [UserDefaults synchronize];
    }
}
// 实现注册APNs失败接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required     应用正在打开使用时，收到通知会进入这里
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"iOS 10 Support userInfo:%@", userInfo);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    
//    [MYFactoryManager uploadMyLocationToService];
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required     通过点击通知打开程序的时候会进入这里
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"iOS 10 Support userInfo:%@", userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
//    [MYFactoryManager uploadMyLocationToService];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    // 取得 APNs 标准信息内容
    
//    [MYFactoryManager uploadMyLocationToService];
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    // 取得Extras字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field  =[%@]",content,(long)badge,sound,customizeField1);
    //判断程序是否在前台运行
    if (application.applicationState ==UIApplicationStateActive) {
        //如果应用在前台，在这里执行
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"极光推送" message:content delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    // iOS 7 Support Required,处理收到的APNS信息
    //如果应用在后台，在这里执行
    NSLog(@"如果应用在后台，在这里执行 userInfo:%@", userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    [JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
    [application setApplicationIconBadgeNumber:0];//小红点清0操作
}

//2. 如果App状态为正在前台或者点击通知栏的通知消息，苹果的回调函数将被调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
//    [MYFactoryManager uploadMyLocationToService];
    // Required,For systems with less than or equal to iOS6
    NSLog(@"如果App状态为正在前台或者点击通知栏的通知消息，苹果的回调函数将被调用 userInfo:%@", userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
