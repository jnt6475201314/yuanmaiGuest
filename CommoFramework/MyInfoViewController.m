//
//  MyInfoViewController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/17.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "MyInfoViewController.h"
#import "UserInfoModel.h"
#import "IDentityViewController.h"

@interface MyInfoViewController ()
{
    UIImageView *imageView;
    
    UITextField * _userName;
    MyPicButton * _sexBtn;
    UIButton * _sendBtn;
    UIImage * _image;
    
    NSDictionary * userData;
}
@property (nonatomic, strong) UserInfoModel * userModel;

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userData = GETData;
    self.userModel = [[UserInfoModel alloc] initWithDictionary:userData error:nil];
    [self configUI];
    NSLog(@"%@", self.userModel);
}

- (void)configUI{
    self.titleLabel.text = @"我的信息";
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/2 - 30, 100, 60*widthScale, 60*widthScale)];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    NSString * headImgUrlStr = [NSString stringWithFormat:@"http://202.91.248.43/project/Public/Uploads/userimages/%@", userData[@"photo"]];
    NSURL * url = [NSURL URLWithString:headImgUrlStr];
    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"个人中心 (1)"] options:SDWebImageHighPriority];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.width/2;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 3.0f;
    imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    imageView.layer.shouldRasterize = YES;
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImgEvent)];
    [imageView addGestureRecognizer:tapG];
    
    UILabel * promptLab = [UILabel labelWithFrame:CGRectMake(screen_width/2 - 100, imageView.bottom + 5, 200, 30) text:@"点击头像选择图片" font:15 textColor:[UIColor lightGrayColor]];
    promptLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:promptLab];
    UILabel * titleLab = [UILabel labelWithFrame:CGRectMake(0, 0, 100, 40) text:@"  姓    名:" font:16 textColor:[UIColor blackColor]];
    _userName = [MYFactoryManager createTextField:CGRectMake(20, promptLab.bottom + 10, screen_width - 40, 40) withLeftView:titleLab withPlaceholder:@"请输入姓名" withDelegate:self];
    _userName.text = userData[@"nickname"];
    _userName.backgroundColor = [UIColor whiteColor];
    _userName.background = [UIImage imageNamed:@"TF_bg"];
    [self.view addSubview:_userName];
    
    UIImageView * sexView = [[UIImageView alloc] initWithFrame:CGRectMake(20, _userName.bottom + 20*heightScale, screen_width - 40, 40)];
    sexView.userInteractionEnabled = YES;
    sexView.image = [UIImage imageNamed:@"TF_bg"];
    UILabel * sexLab = [UILabel labelWithFrame:CGRectMake(0, 0, 100, 40) text:@"  性    别:" font:16 textColor:[UIColor blackColor]];
    [sexView addSubview:sexLab];
    NSArray * titleArr = @[@"男", @"女"];
    for (int i = 0; i < 2; i++) {
        _sexBtn = [[MyPicButton alloc] initWithFrame:CGRectMake(sexLab.right + i * 80, 0, 80, 40)];
        [_sexBtn setBtnViewWithImage:@"circle_o" withImageWidth:20 withTitle:titleArr[i] withTitleColor:[UIColor grayColor] withFont:systemFont(16)];
        [_sexBtn setBtnNomalImage:@"circle_o" withNomalTitle:titleArr[i] withNomalTitleColor:[UIColor grayColor]];
        [_sexBtn setBtnselectImage:@"dot_circle_o" withselectTitleColor:[UIColor blackColor]];
        _sexBtn.tag = 20 + i;
        [_sexBtn addTarget:self action:@selector(selectedMenEvent:) forControlEvents:UIControlEventTouchUpInside];
        [sexView addSubview:_sexBtn];
    }
    [self.view addSubview:sexView];
    
    if ([self.userModel.sex integerValue] == 1) {
        MyPicButton * btn = (MyPicButton *)[sexView viewWithTag:20];
        [btn setMyBtnSelected:YES];
    }else
    {
        MyPicButton * btn = (MyPicButton *)[sexView viewWithTag:21];
        [btn setMyBtnSelected:YES];
    }
    
    _sendBtn = [UIButton buttonWithFrame:CGRectMake(20, screen_height - 100, screen_width - 40, 40) title:@"保存修改" image:@"Button Background" target:self action:@selector(sendBtnEvent)];
    [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sendBtn.titleLabel.font = systemFont(17);
    [self.view addSubview:_sendBtn];
    
    [self showRightBtn:CGRectMake(self.navView.width - 45*widthScale, 24, 40*widthScale, 36) withFont:systemFont(16) withTitle:@"认证" withTitleColor:[UIColor whiteColor]];
}

#pragma mark - Event Hander
- (void)selectedMenEvent:(MyPicButton *)sexBtn
{
    NSLog(@"%ld", sexBtn.tag);
    [sexBtn setMyBtnSelected:YES];
    if (sexBtn.tag == 20) {
        self.userModel.sex = @"1";
        MyPicButton * btn = (MyPicButton *)[self.view viewWithTag:21];
        [btn setMyBtnSelected:NO];
    }else if (sexBtn.tag == 21)
    {
        self.userModel.sex = @"2";
        MyPicButton * btn = (MyPicButton *)[self.view viewWithTag:20];
        [btn setMyBtnSelected:NO];
    }
    //    [self.tableView reloadData];
}

-(void)navRightBtnClick:(UIButton *)button
{
    // 认证
    [self IDentityEvent];
}

// 身份认证
- (void)IDentityEvent{
    IDentityViewController * IDentityVC = [[IDentityViewController alloc] init];
    [self presentViewController:IDentityVC animated:YES completion:nil];
}

- (void)headImgEvent
{
    [self.view endEditing:YES];
    [self showCanEdit:YES photo:^(UIImage *photo) {
        
        imageView.image = photo;
        _image = photo;
    }];
}
#if 1
- (void)sendBtnEvent
{
    [self.view endEditing:YES];
    [self showHUD:@"信息修改中，请稍候。。。" isDim:YES];
    
//    NSString * urlStr = [URLSTRING stringByAppendingString:@"user_edit.html"];
    NSDictionary * params = @{@"nickname":self.userModel.nickname, @"sex":self.userModel.sex, @"uid":userData[@"uid"]};
    NSLog(@"%@?%@", API_ModifyPersonalInfo_URL, params);
    UIImage *image = [[UIImage alloc] init];
    if (_image) {
        image = _image;
    }else{
        image = imageView.image;
    }
    NSLog(@"%@?%@", API_ModifyPersonalInfo_URL, params);
    [NetRequest AF_RegisterByPostWithUrlString:API_ModifyPersonalInfo_URL params:params image:image success:^(id data) {
        
        [self hideHUD];
        if ([data[@"code"] isEqualToString:@"1"]) {
            NSLog(@"修改成功");
            [self showTipView:data[@"message"]];
            [self getData];
            [NSThread sleepForTimeInterval:1.0]; // 延迟一秒跳转
            [self dismissViewControllerAnimated:YES completion:nil];
        }else if ([data[@"code"] isEqualToString:@"2"]){
            NSLog(@"修改失败");
            [self showTipView:data[@"message"]];
        }
    } fail:^(id errorDes) {
        
        NSLog(@"%@", errorDes);
        [self showTipView:@"修改出错"];
    }];
    
}
#endif

- (void)getData{
    NSString * urlStr = @"http://202.91.248.43/project/index.php/Admin/App/find_user";
    NSDictionary * params = @{@"uid":userData[@"uid"]};
    [NetRequest postDataWithUrlString:urlStr withParams:params success:^(id data) {
        
        NSLog(@"userInfoData: %@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            // 获取个人信息成功
            NSLog(@"用户信息：%@", data);
            // 存储信息
            [self saveUserInfo:data[@"data"]];
            
        }else if ([data[@"code"] isEqualToString:@"2"]){
            [self showTipView:data[@"message"]];
        }
        
    } fail:^(id errorDes) {
        
        NSLog(@"%@", errorDes);
    }];
}

// 存储用户信息
- (void)saveUserInfo:(NSDictionary *)data{
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"data"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"存储信息成功！");
}


#pragma mark -- UITextFieldDelegate
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == _userName) {
        if (textField.text.length > 0) {
            self.userModel.nickname = textField.text;
        }
    }
    return YES;
}

-(void)backClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 添加向右轻扫手势
- (void)addSwipeRightGesture
{
    
    UISwipeGestureRecognizer * swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(addSwipeGestureRightEvent:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer * swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(addSwipeGestureRightEvent:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionDown;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:swipeDownGesture];
    [self.view addGestureRecognizer:swipeRightGesture];
}
// 向右轻扫手势所做的事
- (void)addSwipeGestureRightEvent:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight || swipe.direction == UISwipeGestureRecognizerDirectionDown){
        //向右轻扫做的事情
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
