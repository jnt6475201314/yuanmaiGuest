//
//  NewRegisterViewController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2017/2/27.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "NewRegisterViewController.h"

@interface NewRegisterViewController ()<UITextFieldDelegate>
{
    UITextField * _telTF;
    UITextField * _codeTF;
    UITextField * _pwdTF;
    UITextField * _nameTF;
    
    JKCountDownButton * _codeBtn;
    UIButton * _sureBtn;
}

@end

@implementation NewRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showBackBtn];
    self.titleLabel.text = @"注册账号";
    
    [self configUI];
}

- (void)configUI
{
    _nameTF = [MYFactoryManager createTextField:CGRectMake(20, 100*heightScale, screen_width - 40, 40) withPlaceholder:@"请输入您的真实姓名" withLeftViewTitle:@" 姓    名:" withLeftViewTitleColor:[UIColor blackColor] withLeftFont:16 withLeftViewWidth:80 withDelegate:self];
    //通过layer设置圆角
    _nameTF.layer.cornerRadius = 5;
    _nameTF.layer.borderColor = pic_borderColor.CGColor;
    _nameTF.layer.borderWidth = 1;
    [self.view addSubview:_nameTF];
    
    _telTF = [MYFactoryManager createTextField:CGRectMake(20, _nameTF.bottom + 20*heightScale, screen_width - 40, 40) withPlaceholder:@"请输入手机号" withLeftViewTitle:@" 手机号:" withLeftViewTitleColor:[UIColor blackColor] withLeftFont:16 withLeftViewWidth:80 withDelegate:self];
    _telTF.keyboardType = UIKeyboardTypeNumberPad;
    //通过layer设置圆角
    _telTF.layer.cornerRadius = 5;
    _telTF.layer.borderColor = pic_borderColor.CGColor;
    _telTF.layer.borderWidth = 1;
    [self.view addSubview:_telTF];
    
    _codeBtn = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    _codeBtn.frame = CGRectMake(_codeTF.width - 120, 0, 110, 40);
    [_codeBtn addTarget:self action:@selector(codeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _codeBtn.titleLabel.font = systemFont(15);
    //    [_codeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_codeBtn setTitle:@"获取验证码 " forState:UIControlStateNormal];
    _codeBtn.enabled = NO;
    [_codeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _codeTF = [MYFactoryManager createTextField:CGRectMake(20, _telTF.bottom + 20*heightScale, screen_width - 40, 40) withPlaceholder:@"请输入验证码" withLeftViewTitle:@" 验证码:" withLeftViewTitleColor:[UIColor blackColor] withLeftFont:16 withLeftViewWidth:70 withRightView:_codeBtn withDelegate:self];
    _codeTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _codeTF.layer.cornerRadius = 5;
    _codeTF.layer.borderColor = pic_borderColor.CGColor;
    _codeTF.layer.borderWidth = 1;
    [self.view addSubview:_codeTF];
    
    _pwdTF = [MYFactoryManager createTextField:CGRectMake(20, _codeTF.bottom + 20*heightScale, screen_width - 40, 40) withPlaceholder:@"请设置登录密码" withLeftViewTitle:@" 密    码:" withLeftViewTitleColor:[UIColor blackColor] withLeftFont:16 withLeftViewWidth:80 withDelegate:self];
    _pwdTF.keyboardType = UIKeyboardTypeASCIICapable;
    _pwdTF.secureTextEntry = YES;
    _pwdTF.layer.cornerRadius = 5;
    _pwdTF.layer.borderColor = pic_borderColor.CGColor;
    _pwdTF.layer.borderWidth = 1;
    [self.view addSubview:_pwdTF];
    
    _sureBtn = [UIButton buttonWithFrame:CGRectMake(20, _pwdTF.bottom + 80*heightScale, screen_width - 40, 40) title:@"确认注册" image:nil target:self action:@selector(sureBtnEvent)];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sureBtn.enabled = NO;
    _sureBtn.backgroundColor = [UIColor grayColor];
    _sureBtn.layer.cornerRadius = 8;
    _sureBtn.clipsToBounds = YES;
    [self.view addSubview:_sureBtn];
}

// 发送验证码
- (void)codeBtnClicked:(JKCountDownButton *)sender
{
    [self.view endEditing:YES];
    if ([MYFactoryManager phoneNum:_telTF.text]) {
        sender.enabled = NO;
        //button type要 设置成custom 否则会闪动
        [sender startCountDownWithSecond:10];
        
        [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
            
            NSString *title = [NSString stringWithFormat:@"%ld秒后重试",second];
            [countDownButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            return title;
        }];
        
        [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
            countDownButton.enabled = YES;
            [countDownButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            return @"重新获取 ";
        }];
        [self sendMessage];
    }else{
        [self showTipView:@"手机号码格式不正确"];
        _telTF.text = nil;
        [_telTF becomeFirstResponder];
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor = navBar_color.CGColor;
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.layer.borderColor = pic_borderColor.CGColor;
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    else if ([textField isEqual:_telTF]) {
        // 避免崩溃
        if(range.length + range.location > textField.text.length){
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        // 设置限制长度
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        BOOL canChange = [string isEqualToString:filtered];
        [self judgeTelNumberAndSetCodeBtn];
        return canChange && newLength <= 11?canChange:NO;
    }
    else if ([textField isEqual:_codeTF]) {
        return textField.text.length < 6;
    }
    else if ([textField isEqual:_pwdTF]) {
        return textField.text.length < 16;
    }
    
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _telTF) {
        [self judgeTelNumberAndSetCodeBtn];
    }
    // 判断信息是否完整  改变按钮的状态
    [self judgeInfomationisOKOrNOT];
}

- (void)judgeTelNumberAndSetCodeBtn{
    if (_telTF.text.length == 11) {
        if ([MYFactoryManager phoneNum:_telTF.text]) {
            _codeBtn.enabled = YES;
            [_codeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }else
        {
            [self showTipView:@"手机号码格式不正确，请验证后重新输入"];
            _telTF.text = nil;
            _codeBtn.enabled = NO;
            [_codeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }else
    {
        _codeBtn.enabled = NO;
        [_codeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (void)judgeInfomationisOKOrNOT{
    if (_telTF.text.length == 0 || _codeTF.text.length == 0 || _pwdTF.text.length == 0 || _nameTF.text.length == 0) {
        // 信息不完整
        _sureBtn.enabled = NO;
        _sureBtn.backgroundColor = [UIColor grayColor];
    }else
    {
        // 信息完整
        _sureBtn.enabled = YES;
        _sureBtn.backgroundColor = navBar_color;
    }
}

- (void)sureBtnEvent
{
    // 注册的网络请求
    [self NetWorkOfRegister];
}

- (void)NetWorkOfRegister{
    [self.view endEditing:YES];
    NSDictionary *params = @{@"user_name": _telTF.text, @"password": _pwdTF.text,  @"nickname":_nameTF.text, @"kehu":@"kehu", @"code":_codeTF.text};
    [self showHUD:@"正在提交" isDim:YES];
    [NetRequest postDataWithUrlString:API_Register_URL withParams:params success:^(id data) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@", data);
            if ([data[@"code"] isEqualToString:@"1"]) {
                [self showTipView:data[@"message"]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:^{
                        if ([self.delegate respondsToSelector:@selector(getRegisterTelNumber:)]) {
                            [self.delegate getRegisterTelNumber:_telTF.text];
                        }
                    }];
                });
            }else if ([data[@"code"] isEqualToString:@"2"]) {
                [self showTipView:data[@"message"]];
            }else{
                [self showTipView:data[@"message"]];
            }
        });
        
    } fail:^(id errorDes) {
        [self hideHUD];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showTipView:@"注册失败！请检查当前网络状态或稍后重试。"];
        });
        NSLog(@"%@", errorDes);
    }];
}

// 发送验证码数据请求
- (void)sendMessage{
    
    NSDictionary * params = @{@"state":@"2", @"user_name":_telTF.text};
    NSLog(@"%@?state=2&user_name=%@", API_GetVerifyCode_URL, _telTF.text);
    [NetRequest postDataWithUrlString:API_GetVerifyCode_URL withParams:params success:^(id data) {
        [_codeTF becomeFirstResponder];
        NSLog(@"%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            [self showTipView:data[@"message"]];
        }else if ([data[@"code"] isEqualToString:@"2"]) {
            [self showTipView:data[@"message"]];
        }else{
            [self showTipView:data[@"message"]];
        }
    } fail:^(id errorDes) {
        
        NSLog(@"%@", errorDes);
    }];
}


-(void)backClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
