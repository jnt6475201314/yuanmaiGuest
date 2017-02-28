//
//  AppDelegate.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/11.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatingDrawerViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// 为了让点的控制器，方便地拿到抽屉
- (JVFloatingDrawerViewController *)drawerViewController;


@end

