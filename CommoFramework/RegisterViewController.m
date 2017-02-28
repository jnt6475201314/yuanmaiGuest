//
//  RegisterViewController.m
//  Working
//
//  Created by 姜宁桃 on 16/7/25.
//  Copyright © 2016年 小浩. All rights reserved.
//

#import "RegisterViewController.h"
#import <JKCountDownButton/JKCountDownButton.h>
#import "UIViewController+XHPhoto.h"
#import "RegisterInfoModel.h"

@interface RegisterViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    UIButton * _headImgBtn;
    UIImage * _headImage;
    
    UITextField * _nameTF;
    UITextField * _telTF;
    UITextField * _codeTF;
    UITextField * _pwdTF;
    
    JKCountDownButton * _codeBtn;
    MyPicButton * _sexBtn;
    MyPicButton * _womenBtn;
    
    UIButton * _registerBtn;
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * titleArray;

@property (nonatomic, strong) RegisterInfoModel * registerModel;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"注册";
    [self configUI];
}

- (void)configUI
{
    self.registerModel = [RegisterInfoModel new];
    _titleArray = @[@"姓名", @"选择性别", @"手机号码", @"验证码", @"设置密码"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height) style:UITableViewStylePlain];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellId"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [_tableView addGestureRecognizer:tap];
    [self.view addSubview:_tableView];
    
    _registerBtn = [UIButton buttonWithFrame:CGRectMake(20, screen_height - 120, screen_width - 40, 40) title:@"注册" image:@"Button Background" target:self action:@selector(registerBtnEvent)];
    [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_registerBtn];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellId" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        _headImgBtn = [UIButton buttonWithFrame:CGRectMake(screen_width/2 - 25, 10, 50, 50) title:nil image:@"个人中心 (1)" target:self action:@selector(headImgBtnEvent)];
        _headImgBtn.layer.cornerRadius = _headImgBtn.width/2;
        _headImgBtn.clipsToBounds = YES;
        [cell.contentView addSubview:_headImgBtn];
    }else if (indexPath.section == 1)
    {
        cell.textLabel.text = _titleArray[indexPath.row];
        if (indexPath.row == 0) {
            _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(screen_width - 220, 0, 200, 40)];
            _nameTF.delegate = self;
            _nameTF.placeholder = @"请输入您的姓名";
            [cell.contentView addSubview:_nameTF];
        }else if (indexPath.row == 1)
        {
            NSArray * titleArr = @[@"男", @"女"];
            for (int i = 0; i < 2; i++) {
                _sexBtn = [[MyPicButton alloc] initWithFrame:CGRectMake(screen_width - 220 + i * 100, 0, 100, 40)];
                [_sexBtn setBtnViewWithImage:@"circle_o" withImageWidth:20 withTitle:titleArr[i] withTitleColor:[UIColor grayColor] withFont:systemFont(16)];
                if (i == 0) {
                    [_sexBtn setMyBtnSelected:YES];
                }else
                {
                    [_sexBtn setMyBtnSelected:NO];
                }
                [_sexBtn setBtnNomalImage:@"circle_o" withNomalTitle:titleArr[i] withNomalTitleColor:[UIColor grayColor]];
                [_sexBtn setBtnselectImage:@"dot_circle_o" withselectTitleColor:[UIColor blackColor]];
                _sexBtn.tag = 20 + i;
                self.registerModel.sex = @"1";
                [_sexBtn addTarget:self action:@selector(selectedMenEvent:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:_sexBtn];
            }
            
        }else if (indexPath.row == 2)
        {
            _telTF = [[UITextField alloc] initWithFrame:CGRectMake(screen_width - 220, 0, 200, 40)];
            _telTF.delegate = self;
            _telTF.placeholder = @"请输入手机号";
            _telTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            [cell.contentView addSubview:_telTF];
        }else if (indexPath.row == 3)
        {
            _codeBtn = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
            _codeBtn.frame = CGRectMake(_codeTF.frame.size.width - 100, 2, 100, 36);
            [_codeBtn addTarget:self action:@selector(codeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_codeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [_codeBtn setTitle:@"获取验证码 " forState:UIControlStateNormal];
            _codeBtn.titleLabel.font = systemFont(15);
            _codeTF = [MYFactoryManager createTextField:CGRectMake(screen_width - 220, 0, 200, 40) withPlaceholder:@"请输入验证码" withLeftViewTitle:nil withLeftViewTitleColor:[UIColor clearColor] withLeftFont:12 withLeftViewWidth:0 withRightView:_codeBtn withDelegate:self];
            _codeTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            [cell.contentView addSubview:_codeTF];
        }else if (indexPath.row == 4)
        {
            _pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(screen_width - 220, 0, 200, 40)];
            _pwdTF.delegate = self;
            _pwdTF.placeholder = @"请输入设置密码";
            _pwdTF.keyboardType = UIKeyboardTypeASCIICapable;
            [cell.contentView addSubview:_pwdTF];
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1)
    {
    return _titleArray.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    }else if (indexPath.section == 1)
    {
        return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == _telTF) {
//        if ([MYFactoryManager getPhoneText:_telTF.text]) {
//            self.registerModel.user_name = _telTF.text;
//            return YES;
//        }else{
//            [self showHUDComplete:@"手机号码格式不正确，请重新输入"];
//            _telTF.text = nil;
//            return NO;
//        }
        self.registerModel.user_name = _telTF.text;
    }else if (textField == _nameTF){
//        if (_nameTF.text.length > 0 && _nameTF.text.length < 8) {
//            self.registerModel.nickname = _nameTF.text;
//            return YES;
//        }else
//        {
//            [self showHUDComplete:@"姓名长度不正确，请重新输入"];
//            _nameTF.text = nil;
//            return NO;
//        }
        self.registerModel.nickname = _nameTF.text;
    }else if (textField == _pwdTF){
        self.registerModel.password = _pwdTF.text;
    }else if (textField == _codeTF){
        self.registerModel.code = _codeTF.text;
    }
    return YES;
}

#pragma mark - Event Hander
- (void)headImgBtnEvent
{
    [self showCanEdit:YES photo:^(UIImage *photo) {
        
        [_headImgBtn setBackgroundImage:photo forState:UIControlStateNormal];
        _headImage = photo;
    }];
}

- (void)selectedMenEvent:(MyPicButton *)sexBtn
{
    NSLog(@"%d", sexBtn.tag);
    [sexBtn setMyBtnSelected:YES];
    if (sexBtn.tag == 20) {
        self.registerModel.sex = @"1";
        MyPicButton * btn = (MyPicButton *)[self.view viewWithTag:21];
        [btn setMyBtnSelected:NO];
    }else if (sexBtn.tag == 21)
    {
        self.registerModel.sex = @"2";
        MyPicButton * btn = (MyPicButton *)[self.view viewWithTag:20];
        [btn setMyBtnSelected:NO];
    }
//    [self.tableView reloadData];
}

// 发送验证码
- (void)codeBtnClicked:(JKCountDownButton *)sender
{
    [self.view endEditing:YES];
    if (self.registerModel.user_name) {
        if ([MYFactoryManager getPhoneText:self.registerModel.user_name]) {
            sender.enabled = NO;
            //button type要 设置成custom 否则会闪动
            [sender startCountDownWithSecond:10];
            
            [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
                
                NSString *title = [NSString stringWithFormat:@"%d秒后重试",second];
                return title;
            }];
            
            [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
                countDownButton.enabled = YES;
                return @"重新获取 ";
            }];
            
            [self sendMessage];
        }else{
            [self showTipView:@"请检查手机号码是否有误"];
        }
    }else{
        [self showTipView:@"请填写手机号后再发送验证码"];
    }
    
}

// 发送验证码数据请求
- (void)sendMessage{
    
//    NSString * urlStr = [URLSTRING stringByAppendingString:@"code.html"];
    NSDictionary * params = @{@"state":@"2", @"user_name":self.registerModel.user_name};
    NSLog(@"%@?state=2&user_name=%@", API_GetVerifyCode_URL, self.registerModel.user_name);
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

- (void)registerBtnEvent
{
    [self.view endEditing:YES];
    if (self.registerModel.user_name.length > 0 && self.registerModel.password.length > 0 && self.registerModel.sex.length > 0 && self.registerModel.nickname.length > 0 && self.registerModel.code.length > 0) {
        if (_headImage != nil) {
//            NSString * urlStr = [URLSTRING stringByAppendingString:@"zhuce.html"];
            NSDictionary *params = @{@"user_name": self.registerModel.user_name, @"password": self.registerModel.password, @"sex":self.registerModel.sex, @"nickname":self.registerModel.nickname, @"kehu":@"kehu", @"code":self.registerModel.code};
            UIImage *image = [UIImage imageNamed:@"test"];
            if (_headImage) {
                image = _headImage;
            }
            [NetRequest AF_RegisterByPostWithUrlString:API_Register_URL params:params image:image success:^(id data) {
                NSLog(@"success : %@", data);
                if ([data[@"code"] isEqualToString:@"1"]) {
                    // 注册成功
                    [self dismissViewControllerAnimated:YES completion:^{
                        [self showTipView:@"注册成功"];
                        if ([self.delegate respondsToSelector:@selector(getRegisterTelNumber:)]) {
                            [self.delegate getRegisterTelNumber:self.registerModel.user_name];
                        }
                    }];
                }else if ([data[@"code"] isEqualToString:@"2"]) {
                    // 注册失败
                    [self showTipView:data[@"message"]];
                }
                
            } fail:^(id errorDes) {
                [self showTipView:@"注册失败"];
                NSLog(@"error : %@", errorDes);
            }];
        }else
        {
            [self showTipView:@"请选择头像"];
        }
    }else
    {
        [self showTipView:@"请检查注册信息是否完整"];
    }
//    [self uploadImageWithAFNetworking];
}


- (void)tapEvent:(UITapGestureRecognizer *)tapGestEvent
{
    [self.view endEditing:YES];
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
