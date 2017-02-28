//
//  TabBarController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/14.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "TabBarController.h"
#import "HomeViewController.h"
#import "PublishViewController.h"
#import "OrderCenterViewController.h"
//#import "LookingForViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController
{
    MyPicButton *lastBtn;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBar.hidden = NO;
    if (self.viewControllers.count > 0) {
        return;
    }
    
    [self initTabBar];
    [self saveNavCon];
    
}

- (void)saveNavCon{
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    PublishViewController *publishVC = [[PublishViewController alloc] init];
    OrderCenterViewController *orderCenterVC = [[OrderCenterViewController alloc] init];
//    LookingForViewController *lookingForVC = [[LookingForViewController alloc] init];
    //    MineViewController *mineVC = [[MineViewController alloc] init];
    
    //用户默认信息
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *userId = [defaults objectForKey:@"userId"];
    NSArray *viewArr = [[NSArray alloc] initWithObjects:homeVC,publishVC,orderCenterVC, nil];
    NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:viewArr.count];
    for (UIViewController *vc in viewArr) {
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:vc];
        navCon.delegate = self;
        [mArray addObject:navCon];
    }
    self.viewControllers = mArray;
    self.selectedIndex = 0;
}

- (void)initTabBar{
    _tabView = [[UIView alloc] initWithFrame:CGRectMake(0, screen_height-49, screen_height, 49)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 49)];
    imageView.backgroundColor = tabBar_color;
    [_tabView addSubview:imageView];
    //细线
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, screen_width, 0.5)];
    sepLine.backgroundColor = background_color;
    [_tabView addSubview:sepLine];
    NSArray *titleArray = @[@"首页",@"发布",@"订单中心"];
    NSArray *picArray = @[@"tabbar_snatch",@"tab_send_unselected", @"tabbar_latest"];
    NSArray *highArray = @[@"tabbar_snatch_high",@"tab_sendGood", @"tabbar_latest_high"];
    for (int i=0; i<titleArray.count; i++) {
        MyPicButton *button = [MyPicButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(screen_width/titleArray.count*i, 0, screen_width/titleArray.count, 49);
        [button setBtnViewWithImage:[picArray objectAtIndex:i] withImageWidth:25 withTitle:[titleArray objectAtIndex:i] withTitleColor:[UIColor grayColor] withFont:systemFont(11.0f)];
        button.picPlacement = 1;
        button.imageDistant = 5;
        [button setBtnselectImage:[highArray objectAtIndex:i]withselectTitleColor:color(30, 96, 223, 1)];
        button.tag = 100+i;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_tabView addSubview:button];
        if (i == 0) {
            button.myBtnSelected = YES;
            lastBtn = button;
        }
    }
    [self.view addSubview:_tabView];
}

#pragma 标签栏按钮
- (void)btnClick:(MyPicButton *)button{
    if (button != lastBtn) {
        button.myBtnSelected = !button.myBtnSelected;
        lastBtn.myBtnSelected = NO;
        lastBtn = button;
    }
    //计算按钮间隔
    self.selectedIndex = button.tag - 100;
}

#pragma UINavigationDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //计算导航栏控制器子控制器个数
    int count = (int)navigationController.viewControllers.count;
    if (count == 2) {
        [self showTabbar:NO];
    }else if(count == 1) {
        [self showTabbar:YES];
    }
}

//是否隐藏tabbar
- (void)showTabbar:(BOOL)show
{
    [UIView animateWithDuration:0.2 animations:^{
        if (show) {
            _tabView.frame = CGRectMake(0, screen_height - 49 , screen_width, 49);
        }else{
            _tabView.frame = CGRectMake(0, screen_height , screen_width, 49);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
