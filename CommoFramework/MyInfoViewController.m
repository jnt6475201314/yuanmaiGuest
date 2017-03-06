//
//  MyInfoViewController.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/17.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "MyInfoViewController.h"

@interface MyInfoViewController ()
{
    UIImageView * _logoImgView;
    UILabel * _nameLabel;
    UILabel * _telLabel;
}


@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showBackBtn];
    self.titleLabel.text = @"我的信息";
    
    [self configUI];
}

- (void)configUI
{
    _logoImgView = [UIImageView imageViewWithFrame:CGRectMake(screen_width/2-68*widthScale*0.618, 80*heightScale, 136*widthScale*0.618, 96*heightScale*0.618) image:@"yuanmaiLogo"];
    [self.view addSubview:_logoImgView];
    
    NSDictionary * userData = GETData;
    NSLog(@"%@", userData);
    
    _nameLabel = [UILabel labelWithFrame:CGRectMake(screen_width/2-120*widthScale, _logoImgView.bottom +30*heightScale, 240*widthScale, 35*heightScale) text:[NSString stringWithFormat:@"姓名：%@", userData[@"nickname"]] font:16 textColor:[UIColor darkTextColor]];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_nameLabel];
    
    _telLabel = [UILabel labelWithFrame:CGRectMake(screen_width/2-120*widthScale, _nameLabel.bottom +20*heightScale, 240*widthScale, 35*heightScale) text:[NSString stringWithFormat:@"手机号：%@", userData[@"user_name"]] font:16 textColor:[UIColor darkTextColor]];
    _telLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_telLabel];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
