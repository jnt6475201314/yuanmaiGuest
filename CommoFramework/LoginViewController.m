//
//  LoginViewController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/14.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgotPwdViewController.h"
//#import "RegisterViewController.h"
#import "NewRegisterViewController.h"

#import "HomeViewController.h"
#import "HOMEMenuViewController.h"
#import "TabBarController.h"
#import "JVFloatingDrawerSpringAnimator.h"

@interface LoginViewController ()<UITextFieldDelegate,registerDelegate>
{
    UIImageView * _bgImageView;
    UIImageView * _logoImageView;
    UIImageView * _logoTextImageView;
    
    UITextField * _telTF;
    UITextField * _pwdTF;
    
    UIButton * _loginBtn;
    UIButton * _forgotPwdBtn;
    UIButton * _registBtn;
}

@end

@implementation LoginViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self animationView];
}

- (void)animationView
{
    _bgImageView = [UIImageView imageViewWithFrame:screen_bounds image:@"backgroundImage"];
    [self.view addSubview:_bgImageView];

    _logoImageView = [UIImageView imageViewWithFrame:CGRectMake(30, 51*heightScale, 135*widthScale, 95*heightScale) image:@"yuanmaiLogo"];
    _logoImageView.center = CGPointMake(self.view.center.x, 51*heightScale + 95*heightScale/2);
    [self.view addSubview:_logoImageView];
    
    _logoTextImageView = [UIImageView imageViewWithFrame:CGRectMake(100, 160*heightScale, 120*widthScale, 30*heightScale) image:@"yuanmai_text"];
    _logoTextImageView.center = CGPointMake(self.view.center.x, 160*heightScale + (30*heightScale)/2);
    [self.view addSubview:_logoTextImageView];
    
    UIImageView * telLeftImgView = [UIImageView imageViewWithFrame:CGRectMake(10, 10, 20, 22) image:@"Login_TF_userImg"];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 42)];
    [view addSubview:telLeftImgView];
    _telTF = [MYFactoryManager createTextField:CGRectMake(20, 240 * heightScale, 264 * widthScale, 42) withLeftView:view withPlaceholder:@"请输入手机号码" withDelegate:self];
    [_telTF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _telTF.background = [UIImage imageNamed:@"login_TF_bgImg"];
    _telTF.textColor = [UIColor whiteColor];
    _telTF.returnKeyType = UIReturnKeyNext;
    _telTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_telTF];
    
    UIImageView * rightImgView = [UIImageView imageViewWithFrame:CGRectMake(10, 10, 20, 22) image:@"login_TF_pwdImg"];
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 42)];
    [rightView addSubview:rightImgView];
    _pwdTF = [MYFactoryManager createTextField:CGRectMake(20, 300 * heightScale, 264 * widthScale, 42) withLeftView:rightView withPlaceholder:@"请输入密码" withDelegate:self];
    [_pwdTF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _pwdTF.background = [UIImage imageNamed:@"login_TF_bgImg"];
    _pwdTF.textColor = [UIColor whiteColor];
    _pwdTF.secureTextEntry = YES;
    [self.view addSubview:_pwdTF];
    
    _loginBtn = [UIButton buttonWithFrame:CGRectMake(60, 370*heightScale, 240*widthScale, 40) title:@"登录" image:@"login_Btn_bgImg" target:self action:@selector(loginBtnEvent:)];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:_loginBtn];
    
    _forgotPwdBtn = [UIButton buttonWithFrame:CGRectMake(108, 430*heightScale, 105*widthScale, 30) title:@"忘记密码？" image:nil target:self action:@selector(forgotPwdBtnEvent:)];
    _forgotPwdBtn.center = CGPointMake(self.view.center.x, 430*heightScale+15);
    [_forgotPwdBtn setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateNormal];
    [self.view addSubview:_forgotPwdBtn];
    
    _registBtn = [UIButton buttonWithFrame:CGRectMake(108, 525*heightScale, 105*widthScale, 30) title:@"新用户注册" image:nil target:self action:@selector(registBtnEvent:)];
    _registBtn.center = CGPointMake(self.view.center.x, 525*heightScale+15);
    [_registBtn setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateNormal];
    [self.view addSubview:_registBtn];
    
    
    if ([UserDefaults objectForKey:@"userName"]) {
        NSString * tel = [UserDefaults objectForKey:@"userName"];
        NSLog(@"tel:%@", tel);
        _telTF.text = tel;
        _pwdTF.text = [UserDefaults objectForKey:tel];
        NSLog(@"account:%@password:%@", _telTF.text, _pwdTF.text);
    }
    
    [self animationWorks];
}

- (void)animationWorks{
    _logoImageView.transform = CGAffineTransformMakeScale(0, 0);
    _logoTextImageView.transform = CGAffineTransformMakeScale(0, 0);
    
    _telTF.center = CGPointMake(_telTF.frame.origin.x - self.view.frame.size.width, 240*heightScale + 21);
    _pwdTF.center = CGPointMake(_pwdTF.frame.origin.x - self.view.frame.size.width, 300*heightScale + 21);
    _loginBtn.center = CGPointMake(_loginBtn.frame.origin.x - self.view.frame.size.width, 370*heightScale+20);
    
    _registBtn.alpha = 0;
    _forgotPwdBtn.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self animations];
}

- (void)animations{
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.23 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        _logoImageView.transform = CGAffineTransformMakeScale(1, 1); // 参数为倍数
        _logoTextImageView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _telTF.center = CGPointMake(self.view.center.x, 240*heightScale + 21);
    } completion:nil];
    
    [UIView animateWithDuration:0.25 delay:0.05 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _pwdTF.center = CGPointMake(self.view.center.x, 300*heightScale + 21);
    } completion:nil];
    
    [UIView animateWithDuration:0.2 delay:0.1 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _loginBtn.center = CGPointMake(self.view.center.x, 370*heightScale+20);
    } completion:^(BOOL finished) {
        
        _forgotPwdBtn.alpha = 1;
        _registBtn.alpha = 1;
    }];
    }];

}


- (void)setupDrawer
{
    HOMEMenuViewController *MenuVC = [[HOMEMenuViewController alloc] init];
    
    TabBarController *GHTabBar = [[TabBarController alloc] init];
    UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:GHTabBar];
    
    // 实例化它
    JVFloatingDrawerViewController *drawer = [[JVFloatingDrawerViewController alloc] init];
    
    // 设置ViewController
    drawer.leftViewController = MenuVC;
    drawer.leftDrawerWidth = screen_width * 0.618;
    
    drawer.rightDrawerWidth = screen_width / 2;
    
    drawer.centerViewController = centerNav;
    
    // 设置动画器
    JVFloatingDrawerSpringAnimator *springAnimator = [[JVFloatingDrawerSpringAnimator alloc] init];
    drawer.animator = springAnimator;
    
    // 设置背景图片
    drawer.backgroundImage = [UIImage imageNamed:@"bg"];
    
    AppDelegate * appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDele.window.rootViewController = drawer;
}

- (JVFloatingDrawerViewController *)drawerViewController
{
    return (JVFloatingDrawerViewController *)AppDelegateInstance.window.rootViewController;
}

#pragma mark - Event Hander
- (void)loginBtnEvent:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    _loginBtn.center = CGPointMake(self.view.frame.size.width/2 - 30, 370*heightScale+20);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _loginBtn.center = CGPointMake(self.view.frame.size.width/2, 370*heightScale+20);
        
    } completion:^(BOOL finished) {
        if (_telTF.text.length > 0 && _pwdTF.text.length > 0) {
            if (_telTF.text.length == 11 && _pwdTF.text.length >= 6) {
                if ([MYFactoryManager getPhoneText:_telTF.text]) {
                    [self loginNetWork];  // 登陆操作
                }else{
                    [self showTipView:@"用户名格式不正确"];
                }
            }else{
                [self showTipView:@"用户名或密码长度不正确"];
            }
        }else{
            [self showTipView:@"用户名或密码不能为空"];
        }
    }];
}

- (void)forgotPwdBtnEvent:(UIButton *)sender
{
    ForgotPwdViewController * forgotPwdVC = [[ForgotPwdViewController alloc] init];
    [self presentViewController:forgotPwdVC animated:YES completion:nil];
}

- (void)registBtnEvent:(UIButton *)sender
{
    NewRegisterViewController * registerVC = [[NewRegisterViewController alloc] init];
//    registerVC.delegate = self;
    [self presentViewController:registerVC animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _telTF) {
        [_pwdTF becomeFirstResponder];
    }else if(textField == _pwdTF)
    {
        [self.view endEditing:YES];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    else if ([textField isEqual:_telTF]) {
        return textField.text.length < 11;
    }
//    else if ([textField isEqual:self.verificationCodeTextField]) {
//        return textField.text.length < 6;
//    }
    else if ([textField isEqual:_pwdTF]) {
        return textField.text.length < 16;
    }
    return YES;
}

#pragma mark - NetWork
//  进行登陆账号密码网络验证操作
- (void)loginNetWork{
    [self showHUD:@"正在登录，请稍候" isDim:YES];
//    NSString * urlStr = [URLSTRING stringByAppendingString:@"login"];;
    NSDictionary * params = @{@"user_name":_telTF.text, @"password":_pwdTF.text};
    NSLog(@"%@?user_name=%@&password=%@", API_LOGIN_URL, _telTF.text, _pwdTF.text);
    [NetRequest postDataWithUrlString:API_LOGIN_URL withParams:params success:^(id data) {
        
        [self hideHUD];
        NSLog(@"data：%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            // 登陆成功
            NSLog(@"登陆成功");
            [self showTipView:data[@"message"]];
            NSLog(@"%@", data[@"data"]);
            [self saveUserInfo:data[@"data"]];
        }else if ([data[@"code"] isEqualToString:@"2"]){
            // 登陆失败
            [self showTipView:data[@"message"]];
        }
    } fail:^(NSString *errorDes) {
        
        NSLog(@"%@", errorDes);
        [self hideHUD];
        [self showTipView:@"登录失败，登录信息是否有误或网络出错"];
    }];
}

// 存储用户信息
- (void)saveUserInfo:(NSDictionary *)data{
    [UserDefaults setObject:data forKey:@"data"];
    NSLog(@"%@", data);
    [UserDefaults setObject:data[@"aa"] forKey:@"token_str"];  // 存储token_str
    [UserDefaults setObject:_telTF.text forKey:@"userName"];
    [UserDefaults setObject:_pwdTF.text forKey:_telTF.text];
    NSLog(@"%@", _pwdTF.text);
    [UserDefaults synchronize];
    NSLog(@"存储信息成功！");
    NSString * username = [UserDefaults objectForKey:@"userName"];
    NSString * password = [UserDefaults objectForKey:_pwdTF.text];
    NSLog(@"username:%@ , pwd:%@", username, password);
    // 跳转到首页
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@", GETData);
        [self setupDrawer];
    });
}


#pragma mark - registerDelegate
- (void)getRegisterTelNumber:(NSString *)user_name
{
    _telTF.text = user_name;
    _pwdTF.text = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
