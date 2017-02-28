//
//  navigationController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/14.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "navigationController.h"
#import "Constants.h"

@interface navigationController ()

@end

@implementation navigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 决定导航栏是否是半透明的
    self.navigationBar.translucent = NO;
    self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    
    // 设置导航条的颜色
        self.navigationBar.barTintColor = [UIColor redColor];
    self.navigationBar.barTintColor = [UIColor colorWithRed:226/255.0f green:4/255.0f blue:15/255.0f alpha:1.0f];
    self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"nav_bgImg"];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSForegroundColorAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
