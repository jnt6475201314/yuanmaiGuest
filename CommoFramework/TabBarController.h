//
//  TabBarController.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/14.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarController : UITabBarController<UINavigationControllerDelegate>

@property (nonatomic,strong)UIView *tabView;

//是否隐藏tabbar
- (void)showTabbar:(BOOL)show;

@end
