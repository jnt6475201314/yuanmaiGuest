//
//  SafeSettingViewController.m
//  Working
//
//  Created by 姜宁桃 on 16/7/28.
//  Copyright © 2016年 小浩. All rights reserved.
//

#import "SafeSettingViewController.h"
#import "LoginViewController.h"

@interface SafeSettingViewController ()<UITextFieldDelegate>
{
    UITextField * _telTF;
    UITextField * _oldPwdTF;
    UITextField * _newPwdTF;
    
    UIButton * _sureBtn;
}

@end

@implementation SafeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"修改密码";
    
    [self configUI];
}

- (void)configUI
{
    NSArray * TFTitleArr = @[@" 手机号：", @" 旧密码：", @" 新密码："];
    NSArray * TFPlaceHolderArr = @[@"请输入手机号码", @"请输入旧密码", @"请输入新密码"];
    for (int i = 0; i < TFTitleArr.count; i++) {
        UITextField * TF = [MYFactoryManager createTextField:CGRectMake(20, 100 + 60* heightScale * i, screen_width - 40, 40) withPlaceholder:TFPlaceHolderArr[i] withLeftViewTitle:TFTitleArr[i] withLeftViewTitleColor:[UIColor blackColor] withLeftFont:16 withLeftViewWidth:80 withDelegate:self];
        TF.background = [UIImage imageNamed:@"TF_bg"];
        [self.view addSubview:TF];
        if (i == 0) {
            _telTF = TF;
            _telTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            NSString * tel = [UserDefaults objectForKey:@"userName"];
            _telTF.text = tel;
            _telTF.enabled = NO;
            _telTF.returnKeyType = UIReturnKeyNext;
        }else if (i == 1)
        {
            _oldPwdTF = TF;
            _oldPwdTF.secureTextEntry = YES;
            _oldPwdTF.returnKeyType = UIReturnKeyNext;
        }else if (i == 2)
        {
            _newPwdTF = TF;
            _newPwdTF.secureTextEntry = YES;
            _newPwdTF.returnKeyType = UIReturnKeyDone;
        }
    }
    _sureBtn = [UIButton buttonWithFrame:CGRectMake(20, screen_height - 100, screen_width - 40, 40) title:@"确定修改" image:@"Button Background" target:self action:@selector(sureBtnEvent)];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_sureBtn];
}

- (void)sureBtnEvent
{
    [self.view endEditing:YES];
    [self showHUD:@"信息修改中，请稍候。。" isDim:YES];
    
    NSDictionary * params = @{@"user_name":_telTF.text, @"pwd":_oldPwdTF.text, @"password":_newPwdTF.text};
    NSLog(@"%@?user_name=%@&pwd=%@&password=%@", API_UPDATEPWD_URL, _telTF.text, _oldPwdTF.text, _newPwdTF.text);
    [NetRequest postDataWithUrlString:API_UPDATEPWD_URL withParams:params success:^(id data) {
        
        [self hideHUD];
        NSLog(@"%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            [self showTipView:@"修改密码成功！即将跳转至登录界面。"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LoginViewController * loginVC = [[LoginViewController alloc] init];
                AppDelegateInstance.window.rootViewController = loginVC;
            });
        }else if ([data[@"code"] isEqualToString:@"2"]){
            [self showTipView:data[@"message"]];
        }
    } fail:^(id errorDes) {
        
        NSLog(@"%@", errorDes);
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _telTF) {
        [_oldPwdTF becomeFirstResponder];
    }else if (textField == _oldPwdTF){
        [_newPwdTF becomeFirstResponder];
    }else if (textField == _newPwdTF){
        [self.view endEditing:YES];
        [self sureBtnEvent];
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
