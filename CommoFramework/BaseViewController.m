//
//  BaseViewController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/14.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "BaseViewController.h"
#import <UMSocialQQHandler.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialSinaHandler.h>
#import <UMSocialSinaSSOHandler.h>
#import "TabBarController.h"

@interface BaseViewController ()<UMSocialUIDelegate>
//加载视图
@property (nonatomic,strong)UILabel *tipLabel;
@end

@implementation BaseViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.toolbar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    
    TabBarController *tabVC = (TabBarController *)self.tabBarController;
    if (self.navigationController.viewControllers.count > 1) {
        [tabVC showTabbar:NO];
    }else {
        [tabVC showTabbar:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavView];
    
    // 设置状态栏 颜色为白色
    if (iOS7Later) { // 判断是否是IOS7
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
    
    [self checkLoginEvnet];     // 允许检测异地登录
}

- (void)initNavView{
    //创建主视图包含基础视图
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, screen_width, screen_height-20)];
    //创建背景视图
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, backView.frame.size.height)];
    _backImageView.backgroundColor = background_color;
    [backView addSubview:_backImageView];
    [self.view addSubview:backView];
    
    //自定义导航栏视图
    _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    //    _navView.backgroundColor = [UIColor whiteColor];
    _navView.backgroundColor = navBar_color;
    _sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, screen_width, 1)];
    _sepView.backgroundColor = sepline_color;
    [_navView addSubview:_sepView];
    //标题视图
    _titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    _titleView.frame = CGRectMake(0, 0, 30, 24);
    _titleView.center = CGPointMake(screen_width/2, 20+22);
    [_navView addSubview:_titleView];
    //标题名
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((screen_width-200)/2, 24, 200, 36)];
    _titleLabel.textAlignment = 1;
    _titleLabel.font = [UIFont systemFontOfSize:20.0f];
    //    _titleLabel.textColor = color(0, 0, 0, 0.9);
    _titleLabel.textColor = [UIColor whiteColor];
    
    UIImageView * navImgView = [UIImageView imageViewWithFrame:_navView.bounds image:@"nav_bgImg"];
    [_navView addSubview:navImgView];
    [_navView addSubview:_titleLabel];
    [self.view addSubview:_navView];
    
    //输入提示框
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen_width, 30)];
    _tipLabel.textColor = [UIColor yellowColor];
    _tipLabel.backgroundColor = color(0, 0, 0, 0.7);
    _tipLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _tipLabel.layer.cornerRadius = 5;
    _tipLabel.clipsToBounds = YES;
    _tipLabel.textAlignment = 1;
}

#pragma mark -- 创建控件
//------默认的右边按钮-------
- (void)showRightBtn {
    if (_rightButton == nil) {
        //基础控件的初始化
        _rightButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setFrame:CGRectMake(screen_width-45, 24, 40, 36)];
        [_rightButton setBtnViewWithImage:@"" withImageWidth:30 withTitle:@"" withTitleColor:[UIColor whiteColor] withFont:systemFont(17.0f)];
        [_rightButton setOnlyText];
        [_rightButton addTarget:self action:@selector(navRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_rightButton];
    }
}
//------自定义的右边按钮(图片)-------
- (void)showRightBtn:(CGRect)rightBtnFrame withImage:(NSString *)imageName withImageWidth:(float)imageWidth{
    if (_rightButton == nil) {
        //基础控件的初始化
        _rightButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setFrame:rightBtnFrame];
        [_rightButton setBtnViewWithImage:imageName withImageWidth:imageWidth withTitle:@"" withTitleColor:[UIColor whiteColor] withFont:systemFont(17.0f)];
        [_rightButton addTarget:self action:@selector(navRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_rightButton];
    }
}
//------自定义的右边按钮(文字)-------
- (void)showRightBtn:(CGRect)rightBtnFrame withFont:(UIFont *)font withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor{
    if (_rightButton == nil) {
        //基础控件的初始化
        _rightButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setFrame:rightBtnFrame];
        [_rightButton setBtnViewWithImage:@"" withImageWidth:1 withTitle:title withTitleColor:titleColor withFont:font];
        //        _rightButton.picPlacement = 2;
        [_rightButton setOnlyText];
        [_rightButton addTarget:self action:@selector(navRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_rightButton];
    }
}

//当push的时候显示返回按钮
//------默认的返回按钮-------
- (void)showBackBtn {
    if (_backButton == nil) {
        _backButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(10, 24, 55, 36);
        _backButton.imageDistant = 0;
        [_backButton setBtnViewWithImage:@"back_high" withImageWidth:23 withTitle:@"" withTitleColor:[UIColor whiteColor] withFont:systemFont(17.0f)];
        [_backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_backButton];
        [self addSwipeRightGesture];
    }
    //    _titleView.left = _backButton.right;
}
//------自定义的返回按钮(图片)-------
- (void)showBackBtn:(CGRect)rightBtnFrame withImage:(NSString *)imageName withImageWidth:(float)imageWidth {
    if (_backButton == nil) {
        //基础控件的初始化
        _backButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:rightBtnFrame];
        [_backButton setBtnViewWithImage:imageName withImageWidth:imageWidth withTitle:@"" withTitleColor:[UIColor whiteColor] withFont:systemFont(17.0f)];
        [_backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_backButton];
    }
}
//------自定义的返回按钮(文字)-------
- (void)showBackBtn:(CGRect)rightBtnFrame withFont:(UIFont *)font withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor {
    if (_backButton == nil) {
        //基础控件的初始化
        _backButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:rightBtnFrame];
        [_backButton setBtnViewWithImage:@"" withImageWidth:1 withTitle:title withTitleColor:titleColor withFont:font];
        [_backButton setOnlyText];
        [_backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_backButton];
    }
}
//------默认的其他按钮-------
- (void)showOtherBtn {
    if (_otherButton == nil) {
        //基础控件的初始化
        _otherButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        [_otherButton setFrame:CGRectMake(screen_width-80, 27, 30, 30)];
        [_otherButton setBtnViewWithImage:@"" withImageWidth:30 withTitle:@"" withTitleColor:[UIColor whiteColor] withFont:systemFont(17.0f)];
        [_otherButton addTarget:self action:@selector(navOtherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_otherButton];
    }
}

#pragma 加载框
- (void)showHUD:(NSString *)title isDim:(BOOL)isDim{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = title;
    self.hud.dimBackground = isDim;
}

- (void)showHUDComplete:(NSString *)title{
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"查车"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.labelText = title;
    [self.hud hide:YES afterDelay:1];
}
- (void)hideHUD
{
    [self.hud hide:YES];
}

#pragma 提示框
- (void)showTipView:(NSString *)tipStr {
    if (![_tipLabel superview]) {
        [_tipLabel removeFromSuperview];
        _tipLabel.text = tipStr;
        CGSize size = [_tipLabel sizeThatFits:CGSizeMake(MAXFLOAT, 30)];
        _tipLabel.width = size.width+30;
        _tipLabel.center = CGPointMake(screen_width/2, screen_height/2);
        [self.view addSubview:_tipLabel];
    }
    [_tipLabel performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
}

#pragma 导航栏按钮事件
//左边
- (void)backClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
//右边
- (void)navRightBtnClick:(UIButton *)button {
    
}
//其他
- (void)navOtherBtnClick:(UIButton *)button {
    
}

#if 1
#pragma 分享事件
- (void)shareQQAndWechat:(NSString *)urlStr {
    [UMSocialWechatHandler setWXAppId:WEIXIN_ID appSecret:WEIXIN_KEY url:urlStr];
    [UMSocialQQHandler setQQWithAppId:YOUMENG_QQ_ID appKey:YOUMENG_QQ_KEY url:urlStr];
}
//控制器
- (void)shareController:(NSString *)shareText withImage:(NSString *)shareImage {
    [UMSocialSnsService presentSnsController:self appKey:YOUMENG_APPKEY shareText:shareText shareImage:[UIImage imageNamed:shareImage] shareToSnsNames:@[UMShareToWechatSession,UMShareToQQ,UMShareToWechatTimeline,UMShareToSina] delegate:self];
}
//活动视图
- (void)shareSheetView:(NSString *)shareText withImage:(NSString *)shareImage {
    [UMSocialSnsService presentSnsIconSheetView:self appKey:YOUMENG_APPKEY shareText:shareText shareImage:[UIImage imageNamed:shareImage] shareToSnsNames:@[UMShareToWechatSession,UMShareToQQ,UMShareToWechatTimeline,UMShareToSina] delegate:self];
}
//分享
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //分享成功操作
    if (response.responseCode == UMSResponseCodeSuccess) {
        [self showTipView:@"分享成功"];
    } else if(response.responseCode != UMSResponseCodeCancel) {
        [self showTipView:@"分享失败"];
    }
}

-(BOOL)closeOauthWebViewController:(UINavigationController *)navigationCtroller socialControllerService:(UMSocialControllerService *)socialControllerService{
    
    
    return NO;
}
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerTyp {
    
}

#endif

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

// 添加向右轻扫手势
- (void)addSwipeRightGesture
{
    _swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(addSwipeGestureRightEvent:)];
    _swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:_swipeRightGesture];
}

// 向右轻扫手势所做的事
- (void)addSwipeGestureRightEvent:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight){
        //向右轻扫做的事情
        [self addAnimationWithType:TAnimationPageCurl Derection:FAnimationFromLeft];
        //        [self.navigationController popViewControllerAnimated:YES];
        [self backClick:nil];
    }
}

// 添加向左轻扫手势
- (void)addSwipeLeftGesture{
    _swipeleftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(addSwipeGestureRightEvent:)];
    _swipeleftGesture.direction = UISwipeGestureRecognizerDirectionRight;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:_swipeleftGesture];
}

// 向左轻扫手势所做的事
- (void)addSwipeGestureLeftEvent:(UISwipeGestureRecognizer *)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft){
        //向左轻扫做的事情
//        JVFloatingDrawerViewController *drawer = [AppDelegateInstance drawerViewController];
//        [drawer closeDrawerWithSide:JVFloatingDrawerSideLeft animated:YES completion:nil];
    }
}

#pragma mark - 检测异地登录

- (void)checkLoginEvnet{
    
    if (GETTOKEN_Str) {
        [NetRequest checkOtherPlaceLoginWithUrlString:CHECK_TokenStr_UrlStr withParams:@{@"str":GETTOKEN_Str} success:^(id data) {
            NSLog(@"%@", data);
            if ([data[@"code"] isEqualToString:@"101"]) {
                // 登陆正常
                NSLog(@"未异地登录");
            }else
            {
                // 异地登陆
                [self showReloginAlertView];
            }
        } fail:^(NSString *errorDes) {
            
            NSLog(@"%@", errorDes);
        }];
    }
    
}

- (void)showReloginAlertView{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"安全提示" message:@"检测到您的账号在其他地方登陆，请重新登陆并检查账户是否安全！" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    UIAlertAction * callAction = [UIAlertAction actionWithTitle:@"重新登陆" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self turnToLoginVC];
    }];
    [alertController addAction:callAction];
}

- (void)turnToLoginVC{
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    AppDelegateInstance.window.rootViewController = loginVC;
}


/**
 *  添加翻页动画
 *
 *  @param type      翻页类型
 *  @param direction 翻页反向
 */
- (void)addAnimationWithType:(NSString *)type Derection:(NSString *)direction{
    CATransition * animation = [CATransition animation];
    animation.duration = 0.4;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = type;
    animation.subtype = direction;
    [self.view.window.layer addAnimation:animation forKey:@"animation"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}


@end
